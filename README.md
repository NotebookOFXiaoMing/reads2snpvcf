# reads2snpvcf

基本流程

fastp 默认参数过滤

bwa 比对得到sam格式文件

samtools 将 sam  转换为 sorted.bam

minipileup 检测变异位点 

bcftools 过滤 保留二等位的snp位点

fastp bwa samtools bcftools snakemake 都可以通过conda安装
snakemake 安装 7.30.0 版本

minipileup 工具 https://github.com/lh3/minipileup

下载下来需要编译一下

测试数据 大肠杆菌

基因组数据下载链接

ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz 

下载好以后放到 ref 文件夹下 
解压

```
bgzip GCF_000005845.2_ASM584v2_genomic.fna.gz
mv GCF_000005845.2_ASM584v2_genomic.fna Ecoli.fa
```

重测序数据

SRR10001272 SRR10002237 SRR10005830

fastq格式

下载好以后放到 00.raw.fq 文件夹下

首先给参考基因组构建索引

```
bwa index ref/Ecoli.fa
```

运行脚本 主要测试文件路径是否正确

```
snakemake -s bwa_samtools_minipileup_bcftools.smk --configfiles=config_snp.yaml --cores 16 -p -n
```

集群提交任务

```
sbatch run_bwa_samtools_minipileup_bcftools.slurm
```
