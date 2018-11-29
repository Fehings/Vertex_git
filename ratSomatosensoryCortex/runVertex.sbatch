#!/bin/bash
#SBATCH -A mknr
#SBATCH --job-name=fulldensitytest1001
#SBATCH --output=fulldensitytest1001.out
#SBATCH --error=fulldensitytest1001.err
#SBATCH --time=23:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --mail-type=ALL
#SBATCH --mail-user=c.thornton@ncl.ac.uk
#SBATCH --mem-per-cpu=8000

echo Starting job
echo pwd
  module load MATLAB/2017a
  export MATLABPATH=~/Vertex_git/
  matlab -nodesktop -nosplash -r loadandrunrat > output.txt;
echo Finishing job
