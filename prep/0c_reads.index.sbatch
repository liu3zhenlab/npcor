#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64G
#SBATCH --time=20-00:00:00

##################################################
# subject to change
npDir=/homes/liu3zhen/software/nanopolish/nanopolish_0.11.0
f5Dir=/bulk/liu3zhen/LiuRawData/nanopore/fast5/
reads=/bulk/liu3zhen/LiuRawData/nanopore/guppy/all_merge/A188WGS_Sep2Dec2019_min5kb_guppyPASS.fasta  # or fastq
##################################################

seqsumList=1o-seqsum_list
log=1o-run.log

# generate a list for sequencing_summary.txt, including full paths
ls /bulk/liu3zhen/LiuRawData/nanopore/guppy/*/*/sequencing_summary.txt -1 > $seqsumList

# index reads:
$npDir/nanopolish index -d $f5Dir -f $seqsumList $reads &>$log

