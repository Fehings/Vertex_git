#!/bin/bash
#$ -cwd
#$ -l h_vmem=16G
#$ -pe smp 12
echo Starting job
echo pwd
module add apps/Matlab/2015a
matlab -nodesktop -nosplash -r tut2_50k_stim4mvskewed
echo Finishing job
