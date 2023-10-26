#!/bin/bash

mkdir -p Results/Trimmed  Results/TrimmedUnpaired  Results/Aggregated_QC  Results/New_Trimmed_qc_reports/

#Trimming using Trimmomatic

for infile in project_reads/*_1.fastq.gz
do
    echo $infile
    base="$(basename ${infile} _1.fastq.gz)"
    Trimmed_R1=Results/Trimmed/${base}_1.trim.fastq.gz 
    Trimmed_R2=Results/Trimmed/${base}_2.trim.fastq.gz
    TrimmedUn_R1=Results/TrimmedUnpaired/${base}_1un.trim.fastq.gz 
    TrimmedUn_R2=Results/TrimmedUnpaired/${base}_2un.trim.fastq.gz
    trimmomatic PE -threads 20 -phred33 ${infile} input/${base}_2.fastq.gz $Trimmed_R1 $TrimmedUn_R1 $Trimmed_R2 $TrimmedUn_R2\
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True\ SLIDINGWINDOW:4:20 MINLEN:25  
    
                
done


#Checking the quality after trimming

fastqc -t 20 Results/Trimmed/* -o Results/New_Trimmed_qc_reports/

## Aggregating the quality reports into one single report

multiqc Results/New_Trimmed_qc_reports/ --outdir Results/Aggregated_QC/

