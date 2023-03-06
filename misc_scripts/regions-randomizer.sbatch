#!/bin/bash
#SBATCH --job-name=regions-randomizer
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=12:00:00
#SBATCH --partition=short
#SBATCH --output=/scratch/Users/dara6367/hal_testing/eofiles/%x.%j.out
#SBATCH --error=/scratch/Users/dara6367/hal_testing/eofiles/%x.%j.err

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

# Defines input assembly.
assembly=panTro6
species=Chimp

# Loops through each original SAF entry, and obtains a random region from the same chr with the same length.
for entry in `cut -f1 /scratch/Users/dara6367/hal_testing/mergingBidirs/${species}.${assembly}.all.saf`
do
        chr_entry=`grep -w ${entry} /scratch/Users/dara6367/hal_testing/mergingBidirs/${species}.${assembly}.all.saf | awk -v OFS='\t' '{print $2}'`
        length_entry=`grep -w ${entry} /scratch/Users/dara6367/hal_testing/mergingBidirs/${species}.${assembly}.all.saf | awk -v OFS='\t' '{print $4-$3}'`
        length_chr=`grep -w ${chr_entry} /Shares/txpnevol/genomes/${assembly}/${assembly}.main.chrom.sizes | awk -v OFS='\t' '{print $2}'`
        length_limit=`echo ${length_chr} - ${length_entry} | bc -l`
        entry_new_start=`shuf -i 1-${length_limit} -n 1`
        entry_new_end=`echo ${entry_new_start} + ${length_entry} | bc -l`
        echo "${entry}\t${chr_entry}\t${entry_new_start}\t${entry_new_end}\t." >> /scratch/Users/dara6367/hal_testing/mergingBidirs/hal-random-hg38-${assembly}.saf
done

# Corrects tabs so that they are real tabs.
sed -i 's/\\t/\t/g' /scratch/Users/dara6367/hal_testing/mergingBidirs/hal-random-hg38-${assembly}.saf

echo Job finished at `date +"%T %a %d %b %Y"`
