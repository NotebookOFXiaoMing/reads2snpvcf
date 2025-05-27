#!/bin/bash


#SBATCH --job-name="minipileup"
#SBATCH --partition=login
#SBATCH -n 1 #threads
#SBATCH -N 1
#SBATCH --output=%j.out
#SBATCH --error=%j.error
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL


source activate minigraph

snakemake \
--cluster "sbatch --output=/share/org/YZWL/yzwl_wangzw/mingyan/mydata/slurm.log.output/%j.out \
--error=/share/org/YZWL/yzwl_wangzw/mingyan/mydata/slurm.log.output/%j.error \
--cpus-per-task={threads} --mem={resources.mem_mb} --partition=c01 --job-name={params.job_name}" \
--jobs 10 -s bwa_samtools_minipileup_bcftools.smk --configfiles=config_snp.yaml -p -k