#!/bin/bash
#SBATCH --job-name=${job_name}
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=${time}
#SBATCH --mem=${memory}
#SBATCH --cpus-per-task=${cpus}

# Activate the conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate spipe

# Combine results
split-pipe \
    --mode comb \
    --sublibraries ${output_dir_sub1} ${output_dir_sub2} \
    --output_dir ${combined_output_dir}