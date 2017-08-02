#!/bin/bash
#$ -cwd
#$ -V
#$ -pe smp 12 
#$ -l h_vmem=16G
echo Starting job
module add apps/Matlab
matlab -nodisplay -nosplash -r tut2_40kND
echo Finishing job
