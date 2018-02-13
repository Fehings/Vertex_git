#!/bin/bash
#
# A script to run the bsf model in VERTEX

# use current directory
#$ -cwd
# merge error and output into one file
#$ -j y
# use bash shell
#$ -S /bin/bash
# email me...
#$ -M f.hutchings@ncl.ac.uk
# ...when the job ends
#$ -m e
# request 12 workers for the parallel script
#$ -pe smp 12

matlab -nodisplay -nosplash < bsf_modrun4thick.m
