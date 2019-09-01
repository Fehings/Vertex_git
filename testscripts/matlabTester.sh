#!/bin/bash
#SBATCH -A mknr
#SBATCH --job-name=matTest
#SBATCH --output=matest.out
#SBATCH --error=matest.err
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=frances.hutchings@ncl.ac.uk
#SBATCH --mem-per-cpu=500
#SBATCH --workdir=~/vertex/hpcScripts

echo Starting job
echo pwd
  module load MATLAB/2017a
  export MATLABPATH=~/vertex/hpcScripts
  matlab -nodesktop -nosplash -r testscript_rocket > output.txt;
echo Finishing job
