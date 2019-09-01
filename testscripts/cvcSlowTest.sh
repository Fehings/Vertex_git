#!/bin/bash
#SBATCH -A mknr
#SBATCH --job-name=cvcSlowTest
#SBATCH --output=cvcSlowTest.out
#SBATCH --error=cvcSlowTest.err
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --mail-type=ALL
#SBATCH --mail-user=frances.hutchings@ncl.ac.uk
#SBATCH --mem-per-cpu=5000
#SBATCH --workdir=~/vertex/VERTEX_CoreFiles/catVisModel

echo Starting job
echo pwd
  module load MATLAB/2017a
  export MATLABPATH=~/vertex/
  matlab -nodesktop -nosplash -r cvc_model_run > output.txt;
echo Finishing job
