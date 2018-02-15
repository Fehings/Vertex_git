#!/bin/bash
#$ -cwd
#$ -l h_vmem=16G
#$ -pe threaded 8
echo Starting job
echo pwd
module load matlab/R2016a
matlab -nodesktop -nosplash -r tut2_50k_stim4mvskewed
echo Finishing job
