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

# Single sample run
split-pipe \
    --mode all \
    --chemistry ${chemistry} \
    --genome_dir ${genome_dir} \
    --fq1 ${fq1} \
    --fq2 ${fq2} \
    --output_dir ${output_dir} \
    --sample ${sample1} \
    --sample ${sample2}