#!/bin/bash
#
#$ -cwd
#$ -q intel.q
#$ -j y
#$ -S /bin/bash
#$ -o out.txt
#

for ((core=1; core <= 4; core +=1)); do
	export OMP_NUM_THREADS=$core
	./multMatrix_par1 20
done
