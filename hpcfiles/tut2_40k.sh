#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -pe threaded 8 
#$ -l h_vmem=16G
echo Starting job
module load matlab/R2016a
matlab -nodisplay -nosplash -r tut2_40kND
echo Finishing job
