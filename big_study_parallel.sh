#!/bin/bash

#SBATCH --job-name=test_parallel_finegrid_june_12
#SBATCH --output=result_%j.out
#SBATCH --error=error_%j.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=64  
#SBATCH --mem=64GB


module purge 
module load R/4.2.1-gimkl-2022a
Rscript big_study_parallel.R