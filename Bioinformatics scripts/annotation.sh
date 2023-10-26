#!/bin/bash

mkdir Annotation

for infile in filtered_contigs_output_500/*                       
do
   # Extract the sample name from the infile (removing leading path and file extension)
   sample_name=$(basename "$infile" _filtered_contigs.fasta)
   

   prokka  --cpus 4 --kingdom Bacteria --usegenus --genus Mycobacterium  --species tuberculosis --prefix "${sample_name}" --locustag "${sample_name}"  ${infile} \
   --outdir "Annotation/${sample_name}"

done

