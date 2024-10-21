#!/bin/bash

# ================= User-Defined Arguments ==================

# Path to the manually created sublibraries list file
SUBLIB_LIST_FILE="/path/to/sublibs.lis"

# Output directory for combined results
COMBINED_OUTPUT_DIR="/path/to/output/combined_results"

# Job configuration
JOB_NAME="split_pipe_combine"
TIME="24:00:00"
MEMORY="32G"
CPUS="8"

# Dry run option ("yes" for dry run, "no" for actual run)
DRY_RUN="no"

# ===========================================================

# Activate the conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate spipe

# Determine if dry run is requested
if [ "$DRY_RUN" = "yes" ]; then
    DRY_RUN_OPTION="--dryrun"
else
    DRY_RUN_OPTION=""
fi

# Submit the job
sbatch --export=job_name="$JOB_NAME",time="$TIME",memory="$MEMORY",cpus="$CPUS",sublib_list_file="$SUBLIB_LIST_FILE",combined_output_dir="$COMBINED_OUTPUT_DIR",dry_run_option="$DRY_RUN_OPTION" split_pipe_combine.sh