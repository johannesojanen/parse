#!/bin/bash

# ================= User-Defined Arguments ==================

# Base directory containing raw data sublibrary directories
RAW_DATA_BASE="/path/to/your/raw/data"

# List of sublibrary directories to process (full paths)
SUBLIB_DIRS=(
    "$RAW_DATA_BASE/Sub1"
    "$RAW_DATA_BASE/Sub2"
    "$RAW_DATA_BASE/Sub3"
    # Add or remove sublibraries as needed
)

# Path to the sample list file (single file for all sublibraries)
SAMPLE_LIST="/path/to/sample_list_dir/sample_list.txt"

# Genome directory for split-pipe
GENOME_DIR="/path/to/genome_dir"

# Output base directory for split-pipe outputs
OUTPUT_BASE_DIR="/path/to/output/directories"

# Chemistry version (v1, v2, or v3)
CHEMISTRY="v3"

# Dry run option ("yes" for dry run, "no" for actual run)
DRY_RUN="no"

# Job configuration
TIME="24:00:00"
MEMORY="32G"
CPUS="8"

# ===========================================================

# Activate the conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate spipe

# Loop over each sublibrary directory
for SUBLIB_DIR in "${SUBLIB_DIRS[@]}"
do
    SUBLIB_NAME=$(basename "$SUBLIB_DIR")
    echo "Processing $SUBLIB_NAME"

    # Define paths for concatenated files within sublib_dir
    R1_CONCAT="$SUBLIB_DIR/${SUBLIB_NAME}_R1_cat.fastq.gz"
    R2_CONCAT="$SUBLIB_DIR/${SUBLIB_NAME}_R2_cat.fastq.gz"

    # Check if concatenation is necessary
    R1_FILES=("$SUBLIB_DIR"/*_1.fq.gz)
    R2_FILES=("$SUBLIB_DIR"/*_2.fq.gz)

    NUM_R1_FILES=${#R1_FILES[@]}
    NUM_R2_FILES=${#R2_FILES[@]}

    # Check if concatenated files already exist
    CONCATENATED_R1_EXISTS=false
    CONCATENATED_R2_EXISTS=false

    if [ -f "$R1_CONCAT" ]; then
        CONCATENATED_R1_EXISTS=true
    fi
    if [ -f "$R2_CONCAT" ]; then
        CONCATENATED_R2_EXISTS=true
    fi

    # Concatenate R1 files if necessary
    if [ $NUM_R1_FILES -gt 1 ]; then
        if [ "$CONCATENATED_R1_EXISTS" = false ]; then
            echo "Concatenating R1 files for $SUBLIB_NAME"
            cat "${R1_FILES[@]}" > "$R1_CONCAT"
        else
            echo "Concatenated R1 file already exists for $SUBLIB_NAME"
        fi
    elif [ $NUM_R1_FILES -eq 1 ]; then
        # Single R1 file, no concatenation needed
        if [ "$CONCATENATED_R1_EXISTS" = false ]; then
            cp "${R1_FILES[0]}" "$R1_CONCAT"
        fi
    else
        echo "No R1 files found for $SUBLIB_NAME"
        continue
    fi

    # Concatenate R2 files if necessary
    if [ $NUM_R2_FILES -gt 1 ]; then
        if [ "$CONCATENATED_R2_EXISTS" = false ]; then
            echo "Concatenating R2 files for $SUBLIB_NAME"
            cat "${R2_FILES[@]}" > "$R2_CONCAT"
        else
            echo "Concatenated R2 file already exists for $SUBLIB_NAME"
        fi
    elif [ $NUM_R2_FILES -eq 1 ]; then
        # Single R2 file, no concatenation needed
        if [ "$CONCATENATED_R2_EXISTS" = false ]; then
            cp "${R2_FILES[0]}" "$R2_CONCAT"
        fi
    else
        echo "No R2 files found for $SUBLIB_NAME"
        continue
    fi

    # Prepare variables for split-pipe
    JOB_NAME="split_pipe_${SUBLIB_NAME}"
    FQ1="$R1_CONCAT"
    FQ2="$R2_CONCAT"
    OUTPUT_DIR="$OUTPUT_BASE_DIR/$SUBLIB_NAME"

    # Determine if dry run is requested
    if [ "$DRY_RUN" = "yes" ]; then
        DRY_RUN_OPTION="--dryrun"
    else
        DRY_RUN_OPTION=""
    fi

    # Submit the job
    sbatch --export=job_name="$JOB_NAME",time="$TIME",memory="$MEMORY",cpus="$CPUS",chemistry="$CHEMISTRY",genome_dir="$GENOME_DIR",fq1="$FQ1",fq2="$FQ2",output_dir="$OUTPUT_DIR",sample_list_file="$SAMPLE_LIST",dry_run_option="$DRY_RUN_OPTION" split_pipe_single_sample.sh

done