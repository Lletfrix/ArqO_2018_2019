#!/bin/bash
#
#$ -cwd
#$ -q intel.q
#$ -j y
#$ -S /bin/bash
#$ -o out3a.txt
#

size1=1024
size2=2048

echo "Running with size 1024..."
./multMatrix_serie $size1 | grep 'time' | awk -v core=$((core)) '{print "Serie: "  $3}'
for ((core = 1; core <=4; core += 1));do
	export OMP_NUM_THREADS=$core
	./multMatrix_par1 $size1 | grep 'time' | awk -v core=$((core)) '{print "Paralelo 1("core" hilos): "  $3}'
	./multMatrix_par2 $size1 | grep 'time' | awk -v core=$((core)) '{print "Paralelo 2 ("core" hilos): "  $3}'
	./multMatrix_par3 $size1 | grep 'time' | awk -v core=$((core)) '{print "Paralelo 3 ("core" hilos): "  $3}'
done

echo "Running with size 2048..."
./multMatrix_serie $size2 | grep 'time' | awk -v core=$((core)) '{print "Serie: "  $3}'
for ((core = 1; core <=4; core += 1));do
	export OMP_NUM_THREADS=$core
	./multMatrix_par1 $size2 | grep 'time' | awk -v core=$((core)) '{print "Paralelo 1("core" hilos): "  $3}'
	./multMatrix_par2 $size2 | grep 'time' | awk -v core=$((core)) '{print "Paralelo 2 ("core" hilos): "  $3}'
	./multMatrix_par3 $size2 | grep 'time' | awk -v core=$((core)) '{print "Paralelo 3 ("core" hilos): "  $3}'
done
