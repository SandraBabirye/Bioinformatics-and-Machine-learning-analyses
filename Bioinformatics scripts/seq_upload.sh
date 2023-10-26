#!/bin/bash

Samples=$(cat PRJNA481638.txt)

for sample in $Samples; do
    # Download the sample using fasterq-dump and store in project_reads directory
    sratoolkit.3.0.5-ubuntu64/bin/fasterq-dump-orig.3.0.5 $sample --outdir project_reads/  
done


# Compress the downloaded reads using gzip

gzip project_reads/SRR75*

