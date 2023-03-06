#!/bin/bash 
#SBATCH --job-name=multicov
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=06:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load bedtools/2.28.0

dir=/scratch/Users/dara6367/PRO-seq_interspecies-nutlin

multiBamCov \
-bams \
${dir}/bam/PRO-DMSO-Gorilla-2.sorted.bam \
${dir}/bam/PRO-DMSO-Gorilla-3.sorted.bam \
${dir}/bam/PRO-Nutlin-Gorilla-2.sorted.bam \
${dir}/bam/PRO-Nutlin-Gorilla-3.sorted.bam \
-bed ${dir}/regions/Gorilla-tfit-prelim-all.bed \
> ${dir}/multicov/Gorilla-tfit-prelim-all.counts

echo Job finished at `date +"%T %a %d %b %Y"`
