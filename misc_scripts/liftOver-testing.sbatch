#!/bin/bash
#SBATCH --job-name=liftOverTesting
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=23:59:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

# Usage:
# for i in `seq 0 9`;
# do sbatch --export=filenumber=${i} liftOverTesting.sbatch;
# done

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

echo Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToPanTro6.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-panTro6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-panTro6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-panTro6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo panTro6 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*panTro6*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToPanPan3.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-panPan3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-panPan3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-panPan3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo panPan3 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*panPan3*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToGorGor6.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-gorGor6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-gorGor6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-gorGor6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo gorGor6 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*gorGor6*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToPonAbe3.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-ponAbe3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-ponAbe3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-ponAbe3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo ponAbe3 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*ponAbe3*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToNomLeu3.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-nomLeu3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-nomLeu3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-nomLeu3-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo nomLeu3 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*nomLeu3*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToRheMac10.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-rheMac10-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-rheMac10-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-rheMac10-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo rheMac10 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*rheMac10*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToPapAnu4.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-papAnu4-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-papAnu4-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-papAnu4-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo papAnu4 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*papAnu4*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToSaiBol1.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-saiBol1-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-saiBol1-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-saiBol1-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo saiBol1 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*saiBol1*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToBosTau9.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-bosTau9-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-bosTau9-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-bosTau9-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo bosTau9 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*bosTau9*

for value in `seq 0.005 0.005 1`;
do \
liftOver \
-minMatch=${value} \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-hg38-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/Shares/txpnevol/interspecies-nutlin/liftOverChains/hg38ToGalGal6.over.chain \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-galGal6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed \
/scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-galGal6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.unmapped.bed;
count=`wc -l /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/Human-galGal6-Nutlin-dREG-TFEA-ranked-500-${filenumber}.bed | cut -d' ' -f1`;
echo galGal6 ${value} ${count};
done
rm /scratch/Users/dara6367/PRO-seq_species-nutlin/liftOverTesting/*galGal6*

echo Job finished at `date +"%T %a %d %b %Y"`
