#!/bin/bash
#SBATCH --job-name=hal9000-bidirs
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --partition=long
#SBATCH --output=/scratch/Users/dara6367/hal_testing/eofiles/%x.%j.out
#SBATCH --error=/scratch/Users/dara6367/hal_testing/eofiles/%x.%j.err

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

# Loads modules.
module load bedtools/2.25.0

# Defines variables.
#dir=/scratch/Users/dara6367/hal_testing \
#inputBED=Chimp.panTro6-tfit-3kb-ext-MUMERGE.bed \
#species_name_to=Homo_sapiens \
#species_assembly_to=hg38 \
#species_name_from=Pan_troglodytes \
#species_assembly_from=panTro6 \
#sbatch halLiftover-bidirs.sbatch

# Creates temporary directories.
mkdir -p ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}

# Loops through each entry in the input BED file.
for bidir in `cut -f4 ${dir}/inputs/${inputBED}`
do
        # Feeds each separate BED file to HAL to obtain individual output BED files.
        /Users/dara6367/repos/hal/bin/halLiftover \
	/Shares/txpnevol/cactusGenomicAlignments/241-mammalian-2020v2.hal \
        ${species_name_from} \
        ${dir}/inputs/${species_assembly_from}-individual-bidirs/${bidir}.${inputBED} \
        ${species_name_to} \
        ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp1.bed

        # Sorts the individual output BED files.
        sort \
        -k 1,1 -k2,2n \
        ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp1.bed \
        > ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp2.bed

        # Merges all the entries that are within 1000 bp of each other.
        mergeBed \
        -d 1000 \
        -i ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp2.bed \
        > ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp3.bed

        # Adds 5th column with the length of each interval.
        awk -v OFS='\t' '{print $1, $2, $3, $3-$2}' \
        ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp3.bed \
        > ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp4.bed

        # Sorts intervals by their length (4th column) in descending order.
        sort -t $'\t' -k4,4rn \
        ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp4.bed \
        > ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp5.bed

        # Keeps only the biggest merged region per BED file.
        head -1 ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp5.bed \
        > ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp6.bed

	# Replaces the 4th width column with the entry name.
        awk -v OFS='\t' '{print $1, $2, $3}' \
        ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp6.bed \
        > ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}-${species_assembly_from}-${species_assembly_to}.bed
        sed -i "s/$/\t${bidir}/g" ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}-${species_assembly_from}-${species_assembly_to}.bed

	# Removes intermediary files.
	rm ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp1.bed
	rm ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp2.bed
	rm ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp3.bed
	rm ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp4.bed
	rm ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp5.bed
	rm ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/${bidir}.tmp6.bed
done

# Combines all individual merged BED files onto a single file.
printf '%s\0' ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/*-${species_assembly_from}-${species_assembly_to}.bed | \
xargs -r0 cat -- > ${dir}/hal-output/hal-bidirs-${species_assembly_from}-${species_assembly_to}.bed

# Renames the chr to actual chr names.
#for oldID in `cut -f1 ${dir}/chromAlias/table-${species_assembly_to}.txt`
#        do
#        newID=`grep ${oldID} ${dir}/chromAlias/table-${species_assembly_to}.txt | cut -f2`
#        sed -i "s/${oldID}/${newID}/g" ${dir}/hal-bidirs-${species_assembly_from}-${species_assembly_to}.bed
#done

# Removes intermediary files.
rm -R ${dir}/hal-output/bidirs-${species_assembly_from}-${species_assembly_to}/

echo Job finished at `date +"%T %a %d %b %Y"`
