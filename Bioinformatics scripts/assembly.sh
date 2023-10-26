#!/bin/bash

# Function to run SPAdes for a single sample
run_spades() {
    infile="$1"
    base="$(basename "${infile}" _1.trimmed.fastq.gz)"
    spades.py -t 4 -o Results/assembly_output/"${base}" --pe1-1 "${infile}" --pe1-2 "Results/trimmed_output/${base}_2.trimmed.fastq.gz"
}

export -f run_spades

# Run SPAdes in parallel for all samples
find Results/trimmed_output/ -type f -name "*_1.trimmed.fastq.gz" | xargs -I {} -P 4 bash -c 'run_spades "$@"' _ {}

