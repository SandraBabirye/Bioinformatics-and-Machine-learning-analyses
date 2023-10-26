#!/bin/bash

genome=MTB_Ref.fasta

for infile in Results/assembly_output/*
do
   # Extract the sample name from the infile (removing leading path)
   sample_name="$(basename "$infile")"
   
   # Remove the "/contig.fasta" part from the sample name
   sample_name="${sample_name%/contigs.fasta}"
   
   # Run quast.py and save results to the quast_output directory using the sample name
   python /home/sandra.babirye/miniconda3/envs/myenv/bin/quast.py -r "$genome" "${infile}/contigs.fasta" -o "Results/quast_output/${sample_name}"
done

