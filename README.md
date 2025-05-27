# reads2snpvcf

基本流程

fastp 默认参数过滤

bwa 比对得到sam格式文件

samtools 将 sam  转换为 sorted.bam

minipileup 检测变异位点 

bcftools 过滤 保留二等位的snp位点

fastp bwa samtools bcftools 都可以通过conda安装
snakemake 安装 7.30.0 版本

minipileup 工具 https://github.com/lh3/minipileup

测试数据 大肠杆菌

基因组数据下载链接

ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz 

重测序数据

SRR10001272 SRR10002237 SRR10005830

运行脚本

```
snakemake -s bwa_samtools_minipileup_bcftools.smk --configfiles=config_snp.yaml --cores 16 -p -k
```

集群提交任务

```
sbatch run_bwa_samtools_minipileup_bcftools.slurm
```
