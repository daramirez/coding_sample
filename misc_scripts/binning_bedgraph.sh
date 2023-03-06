
module load samtools/1.16.1

sample=PRO-BSA-Human-F
mr=`samtools view -c -F 260 ${sample}.bam`
pmm=`echo ${mr} / 1000000 | bc -l`
binSize=20
start=1

------LOOP------
start=1
end=`echo ${start}+${binSize} | bc -l`
endplus=`echo ${end}+1 | bc -l`
linesSum=`sed -n "${start},${end}p;${endplus}q" ${sample}.pos.bedgraph.tmp | cut -f 3 | tr '\n' '+' | sed 's/.$/\n/' | bc -l`
chr=`sed "${start}q;d" PRO-BSA-Human-F.pos.bedgraph.tmp | cut -f1`
bin_pmm=`echo ${linesSum} / ${pmm} | bc -l`
newLine=`echo -e "$chr\t$start\t$end\t$bin_pmm"`
------LOOP------

