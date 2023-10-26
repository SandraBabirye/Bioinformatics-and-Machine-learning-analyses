#!/bin/bash

mkdir -p Results/sam  Results/bam   Results/sorted.bam   Results/bcf    Results/vcf Results/Filtered_vcfs  Results/SNPS Results/INDELS Results/POS_REF_ALT_Extracted 

# Set the number of parallel jobs
num_jobs=4

# Read input sample names from the text file into an array
mapfile -t input_files <  sample_names.txt

# Define the function to process each sample in parallel
process_sample() {
    local sample=$1
    # Indexing the reference genome
    #bwa index MTB_Ref.fasta 
    # Indexing the reference genome (only needs to be done once)
    if [ ! -e MTB_Ref.fasta.bwt ]; then
        bwa index MTB_Ref.fasta
    fi

    # Step 1: Alignment with BWA
    bwa mem -t 4 MTB_Ref.fasta Results/Trimmed_reads/${sample}_1.trim.fastq.gz  Results/Trimmed_reads/${sample}_2.trim.fastq.gz > Results/sam/${sample}.sam

    # Step 2: Convert SAM to BAM and sort with Samtools
    samtools view -S -b -o  Results/bam/${sample}.bam  Results/sam/${sample}.sam
    
    # Sorting the bam file    
    samtools sort Results/bam/${sample}.bam > Results/sorted.bam/${sample}.sorted.bam

    # Step 3: Variant calling with BCFtools
    bcftools mpileup -O b -o  Results/bcf/${sample}.bcf -f MTB_Ref.fasta --threads 8  Results/sorted.bam/${sample}.sorted.bam
        

    # Step 4: Convert BCF to VCF
    bcftools call --ploidy 1 -m -v -o Results/vcf/${sample}.vcf  Results/bcf/${sample}.bcf

    #Filtering the variants for Quality and Depth of coverage
    
    bcftools filter -i 'QUAL >= 30 && DP >= 10' Results/vcf/${sample}.vcf | bcftools view -i 'FILTER="PASS"' -Oz -o Results/Filtered_vcfs/${sample}_filtered.vcf.gz
    
    #Extract the snps from the VCF file
    
    bcftools view -v snps Results/Filtered_vcfs/${sample}_filtered.vcf.gz -Oz -o Results/SNPS/${sample}_snps.vcf.gz
    
    # Extract the indels
    
    bcftools view -v indels Results/Filtered_vcfs/${sample}_filtered.vcf.gz -Oz -o Results/INDELS/${sample}_indels.vcf.gz
    
    #Extract the information: Position, Reference allele, Alternative allele
    
    bcftools query -f '%POS\t%REF\t%ALT\n' --print-header Results/SNPS/${sample}_snps.vcf.gz > Results/POS_REF_ALT_Extracted/${sample}.tsv

    # Clear storage space
    rm -rf Results/sam/${sample}.sam
    rm -rf Results/sorted.bam/${sample}.sorted.bam
    rm -rf Results/bam/${sample}.bam
}

export -f process_sample


# Run the variant calling in parallel for each input sample
parallel -j "$num_jobs" process_sample ::: "${input_files[@]}"


