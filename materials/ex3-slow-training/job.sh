#!/bin/bash
#SBATCH --job-name=slow-training
#SBATCH --account=project_462001520
#SBATCH --partition=small-g
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gpus-per-node=1
#SBATCH --cpus-per-task=7
#SBATCH --mem=60G
#SBATCH --time=00:15:00
#SBATCH --output=%x_%j.out
#SBATCH --reservation=run-agent-with-lumi

# Load the LUMI AI Factory bind-mount setup (sets SINGULARITY_BIND)
module use /appl/local/laifs/modules
module load lumi-aif-singularity-bindings

# LUMI AI Factory PyTorch container (path from the LUMI AI Factory documentation)
SIF="/appl/local/laifs/containers/lumi-multitorch-latest.sif"

COURSE_SCRATCH="/scratch/${SLURM_JOB_ACCOUNT}" # Define scratch storage location

export DATADIR=$COURSE_SCRATCH/data # Directory where datasets are stored
export TORCH_HOME=$COURSE_SCRATCH/torch-cache # Cache location for PyTorch models and weights
export HF_HOME=$COURSE_SCRATCH/hf-cache # Cache location for Hugging Face models/tokenizers


export MLFLOW_TRACKING_URI=$COURSE_SCRATCH/data/users/$USER/mlruns # Directory where MLflow experiment logs will be stored
export TOKENIZERS_PARALLELISM=false # Disable HuggingFace tokenizers parallelism to avoid fork warnings

umask 002 # Ensures group-write permissions for created files

set -xv # Prints commands before executing them (useful for debugging)
srun singularity exec "$SIF" python3 "$@"
