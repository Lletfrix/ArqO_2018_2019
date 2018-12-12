#!/bin/bash
#
#$ -cwd
#$ -q intel.q
#$ -j y
#$ -S /bin/bash
#$ -o out2.txt
#

make &> /dev/null
# inicializar variables
low=25000000
high=1500000000
steps=10
incr=$(((high-low)/(steps)))
reps=10
C=16
fDAT=ejercicio3.dat
fMEAN=ej3_means_time_
fSPD=ej3_speedup_
fPNGtime=ejercicio3_tiempo.png
fPNGspd=ejercicio3_aceleracion.png

echo "Generating plots..."
gnuplot << END_GNUPLOT
set title "Serie-Par Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNGtime"
filenames = "4"
plot "$fMEAN"."4.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fMEAN".core.".dat" using 1:3 with lines lw 2 title "par_".core
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Serie-Par Speedup"
set ylabel "Speedup over serie"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNGspd"
filenames = "4"
plot "$fSPD"."4.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fSPD".core.".dat" using 1:3 with lines lw 2 title "par_".core
replot
quit
END_GNUPLOT
