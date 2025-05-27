SAMPLES, = glob_wildcards(config["raw_fq"]["r1"])


print("Total sample size: ",len(SAMPLES))


rule all:
    input:
        "04.raw.vcf/snp.output.vcf.gz"


rule fastp:
    input:
        r1 = config["raw_fq"]["r1"],
        r2 = config["raw_fq"]["r2"]
    output:
        r1 = "00.clean.reads/{sample}_clean_R1.fq",
        r2 = "00.clean.reads/{sample}_clean_R2.fq",
        json = "00.fastp.report/{sample}.json",
        html = "00.fastp.report/{sample}.html"
    threads:
        8
    resources:
        mem_mb = 24000
    params:
        #"-f 10 -t 10 -F 10 -T 10"
        job_name = "{sample}_fastp"
    #benchmark:
        #"00.benchmarks/{sample}.fastp.benchmark.txt"
    shell:
        """
        fastp -i {input.r1} -I {input.r2} \
        -o {output.r1} -O {output.r2} \
        -j {output.json} -h {output.html} \
        -w {threads}
        """

rule bwa:
    input:
        r1 = rules.fastp.output.r1,
        r2 = rules.fastp.output.r2,
    output:
        "01.sam/{sample}.sam"
    threads:
        16
    resources:
        mem_mb = 96000
    params:
        job_name = "{sample}_bwa",
        ref = config["ref"]["index"]
    shell:
        """
        bwa mem -t {threads} -M {params.ref} {input.r1} {input.r2} -o {output}
        """

rule samtools_sort:
    input:
        rules.bwa.output
    output:
        bam = "02.sorted.bam/{sample}.sorted.bam"
    threads:
        8
    resources:
        mem_mb = 96000
    params:
        job_name = "{sample}_samtools_sort"
    shell:
        """
        samtools sort -@ {threads} -O BAM -o {output.bam} {input}
        samtools index {output.bam}
        """

rule minipileup:
    input:
        bam = expand(rules.samtools_sort.output.bam,sample=SAMPLES),
        ref = config["ref"]["fa"]
    output:
        "04.raw.vcf/snp.output.vcf.gz"
    threads:
        8
    resources:
        mem_mb = 96000
    params:
        job_name = "minipileup_snp"
    shell:
        """
        /share/org/YZWL/yzwl_wangzw/mingyan/biotools/minipileup-master/minipileup -f {input.ref} \
        -vcC -s5 -a2 -q30 -Q20 -l 90 {input.bam} | \
        bcftools view -v snps -m2 -M2 -O z -o {output}
        tabix {output}
        """
