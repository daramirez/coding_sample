#!/bin/bash
#SBATCH --job-name=FIMO_bidirs_intersect_coretwice
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=03:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load bedtools/2.28.0

# Defines variables.
#species=Chicken
#assembly=galGal6
dir=/scratch/Users/dara6367/fimo
alpha=p1e-6
#TFdb=JASPAR2020_CORE_vertebrates_non-redundant
bidirs=tfit
#condition=Nutlin
bg=bgtm

# Makes temporary directory.
mkdir -p ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect
mkdir -p ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-positions3kb

# Loops through each TF from a given database.
for TF in `cat ${dir}/${TFdb}_TF_names.txt`
do
	# Makes a temporary actual BED file without header.
	tail -n +2 ${dir}/${species}/${assembly}-${TFdb}-${bg}-${alpha}_FIMO/${TF}.bed | cut -f3,4,5 \
	> ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}.bed

        # Intersects all given motif instances file with all bidirs.
        # Removes motif entries that did not intersect with any bidir.
        # Obtains position where the motif was found within the relative 3kb.
        # If a motif entry is just outside of the 3kb window with negative value, make it zero.
        intersectBed -wao \
        -a ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}.bed \
        -b ${dir}/${species}/PRO-${condition}-${species}-${bidirs}_MUMERGE.3kb.bed | grep -v "\." | awk -v OFS='\t' '{print ($2-$5)}' | \
        awk -v OFS='\t' '{if ($1 < 0) print 0; if ($1 > 0) print $0}' | sort -V \
        > ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-positions3kb/${TF}.relative3kb.positions

	# Loops using the three input bidir BED regions: the 300bp core, and the peripheric lenght and right.
	for length in `cat ${dir}/md_lengths.txt`
	do

		# Determines for each bidir, 1 if intersecting with bidir, 0 if not.
		intersectBed -c \
		-a ${dir}/${species}/PRO-${condition}-${species}-${bidirs}_MUMERGE.${length}.bed \
		-b ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}.bed \
		> ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-${length}-intersect.txt.c
	done

	# Combines both core 300bp (1st column) and extended 3kb (2nd column) count files.
	paste --delimiters='\t' ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-300bp-intersect.txt.c \
	${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-3kb-intersect.txt.c \
	> ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-intersect.txt.c.tmp

	# Removes extra columns, sums number instances, and makes a single-line output file.
	echo -en ${TF}\\t`awk -v OFS='\t' '{print $4,$8}' \
	${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-intersect.txt.c.tmp | \
	cut -f1 | paste -sd+ | bc -l | sed 's/\(.*\)/\1\t/'` \
	>> ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-intersect.counts
	echo -e \\t`awk -v OFS='\t' '{print $4,$8}' \
	${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-intersect.txt.c.tmp | \
	cut -f2 | paste -sd+ | bc -l` \
	>> ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-intersect.counts

	# Removes intermediary files.
	rm ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-intersect.txt.c.tmp
	rm ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-300bp-intersect.txt.c
	rm ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}_${assembly}-${alpha}-${bidirs}-3kb-intersect.txt.c
	rm ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect/${TF}.bed
done

# Concatenates all TF 0/1 count tables to be loaded in R.
echo -e "motif\tcore\textended" >> ${dir}/${species}/TFs-${species}-${assembly}-${condition}-${TFdb}-${bg}-FIMO_${alpha}-intersect-${bidirs}-bidirs.txt
cd ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect
cat *.counts >> ${dir}/${species}/TFs-${species}-${assembly}-${condition}-${TFdb}-${bg}-FIMO_${alpha}-intersect-${bidirs}-bidirs.txt

# Removes intermediary directory.
rm -R ${dir}/${species}/${species}-${assembly}-${condition}-${TFdb}-${bg}-${alpha}-${bidirs}-intersect

echo Job finished at `date +"%T %a %d %b %Y"`
