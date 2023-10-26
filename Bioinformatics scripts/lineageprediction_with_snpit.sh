#!/bin/bash

# Define the directory containing VCF files
vcf_directory="../vcfs/"

# Create an array to store output file paths
declare -a output_tsv_files

# Iterate through the VCF files
for vcf_file in "$vcf_directory"*.vcf; do
    # Extract sample name from the file name
    sample_name=$(basename "$vcf_file" .vcf)

    # Define the output file path with sample name
    output_tsv_file="${sample_name}_lineage.tsv"
    output_tsv_files+=("$output_tsv_file")

    # Run snpit command for each VCF file
    snpit -i "$vcf_file" --threshold 95 -o "$output_tsv_file"
done

# Merge the resulting TSV files into one
cat "${output_tsv_files[0]}" > merged_lineage.tsv  # Copy the header

# Append the content from the rest of the files
for tsv_file in "${output_tsv_files[@]:1}"; do
    tail -n +2 "$tsv_file" >> merged_lineage.tsv
done

# Clean up individual TSV files (optional)
rm "${output_tsv_files[@]}"

echo "Processing complete. Merged file: merged_lineage.tsv"


