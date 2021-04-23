#!/bin/sh

#################################
# supply full-path for inputs
#################################
prefix=np
npcor=/homes/liu3zhen/scripts2/npcor/npcor
reads=/bulk/liu3zhen/research/projects/wheatBlast2.0/06-B71asm.nanopore.Guppy344/guppy344/B71.guppy344.gt5kb.fastq
ref=/bulk/liu3zhen/research/projects/wheatBlast2.0/06-B71asm.nanopore.Guppy344/asm1_canu1.9/6_noFlyePolish/1-np/B71ONTc1.9v1.np1.fasta
bam=/bulk/liu3zhen/research/projects/wheatBlast2.0/06-B71asm.nanopore.Guppy344/asm1_canu1.9/6_noFlyePolish/2-np2/1o-reads2ref.bam
npDir=/homes/liu3zhen/software/nanopolish/nanopolish_0.11.0
scriptDir=/homes/liu3zhen/scripts2/npcor/utils
splitseqDir=2o-split
javaModule=Java/1.8.0_192
samtoolsModule=SAMtools/1.9-foss-2018b
ncpu=4
log=2o-run.log

date > $log

# spliting
echo "1. split fasta" &>>$log

if [ -d $splitseqDir ]; then
	rm -rf $splitseqDir
fi
mkdir $splitseqDir
cd $splitseqDir
perl $scriptDir/split.fasta.pl --num 1 --prefix $prefix --decrease $ref &>>../$log 
cd ..

echo "2. run NP correction" &>>$log
# run correction
for ctg in $splitseqDir/*[0-9]; do
	echo "np: "$ctg >> $log
	$npcor -n $npDir -f $ctg -r $reads -b $bam \
		-s $scriptDir \
		-l $javaModule \
		-l $samtoolsModule \
		-c $ncpu \
		-g 8 \
		-y 1 \
		>> $log
done
date >> $log

