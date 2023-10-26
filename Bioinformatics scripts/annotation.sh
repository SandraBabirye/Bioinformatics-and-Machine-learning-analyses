#!/bin/bash
# Create a directory to store the output from Annotation
mkdir Annotation

for infile in Results/assembly_output/*
do
   # Extract the sample name from the infile (removing leading path)
   sample_name="$(basename "$infile")"
   
   # Remove the "/contig.fasta" part from the sample name
   sample_name="${sample_name%/contigs.fasta}"
   
   prokka  --cpus 4 --kingdom Bacteria --usegenus --genus Mycobacterium  --species tuberculosis --prefix "${sample_name}" --locustag "${sample_name}"  ${infile} \
   --outdir "Annotation/${sample_name}"

done

