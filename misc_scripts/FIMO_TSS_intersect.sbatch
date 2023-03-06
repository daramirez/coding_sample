#!/bin/bash
#SBATCH --job-name=TSS_FIMO-intersect
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=02:00:00
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
#species=Human
#assembly=hg38
dir=/scratch/Users/dara6367/fimo
alpha=p1e-6
#TFdb=JASPAR2020_CORE_vertebrates_non-redundant
TSSfilt=noFilt
bg=bgtm

# Makes temporary directory.
mkdir -p ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect

# Loops through each TF.
for TF in `cat ${dir}/${TFdb}_TF_names.txt`

	do

	# Makes a temporary actual BED file without header.
	tail -n +2 ${dir}/${species}/${assembly}-${TFdb}-${bg}-${alpha}_FIMO/${TF}.bed | cut -f3,4,5 \
	> ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}.bed

	# Determines for each FIMO motif instance, 1 if intersecting with TSS, 0 if not.
	intersectBed -c \
	-a ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}.bed \
	-b ${dir}/${species}/${assembly}.ncbiRefSeq.TSS.10kb.oneEntry.${TSSfilt}.bed \
	> ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp

	# Formats intersection results with only counts for 1 and 0, and adds TF name inside file.
	cut -f4 ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp | \
	sort | uniq -c | sed 's/^ *//' | awk -v OFS='\t' '{ print $2, $1}' \
	> ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp2
	echo -e "TF\t${TF}" | cat - ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp2 \
	> ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp3
	cut -f2 ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp3 | tr -s '\n' '\t' \
	> ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt

	# Removes intermediary files.
	rm ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp
	rm ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp2
	rm ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}_${assembly}-${alpha}-${TSSfilt}-intersect_TSS.10kb.txt.tmp3
	rm ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect/${TF}.bed

done

# Adds a new line at the end of every TF 0/1 count table.
cd ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect
for file in `ls | sed "s/\t/\n/g" | sed -e "s/\x1b\[[0-9;]*m//g"`
	do 
	echo "" >> ${file}
done

# Concatenates all TF 0/1 count tables to be loaded in R.
echo -e "motif\tenhancer\tpromoter" > ${dir}/${species}/TFs-${species}-${assembly}-TSS.10kb-${TSSfilt}-${TFdb}-FIMO_${alpha}-intersect.txt
cat * >> ${dir}/${species}/TFs-${species}-${assembly}-TSS.10kb-${TSSfilt}-${TFdb}-FIMO_${alpha}-intersect.txt

# Removes intermediary directory.
rm -R ${dir}/${species}/${species}-${assembly}-${TFdb}-${bg}-${alpha}-${TSSfilt}-intersect

echo Job finished at `date +"%T %a %d %b %Y"`
