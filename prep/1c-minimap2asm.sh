#!/bin/bash -l
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=2G
#SBATCH --time=0-24:00:00
#SBATCH --partition=ksu-gen-reserved.q,batch.q,ksu-biol-ari.q,ksu-plantpath-liu3zhen.q

module load SAMtools

ncpu=$SLURM_CPUS_PER_TASK
ref=<fasta_to_be_polished>
reads=<guppy_fastq>
out=<output_dir>
refdb=<aln_output_prefix>

# aln
/homes/liu3zhen/software/minimap2/minimap2 -x map-ont -d ${refdb}.mmi $ref
/homes/liu3zhen/software/minimap2/minimap2 -ax map-ont -N 0 -t $ncpu ${refdb}.mmi $reads 1>$out.sam 2>$out.log

# bam and sort
samtools view -b -@ $ncpu $out.sam | samtools sort -@ $ncpu -o $out.bam
samtools index -@ $ncpu $out.bam

