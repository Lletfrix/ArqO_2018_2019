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
fDAT=ejercicio2.dat
fMEAN=means_time_
fSPD=speedup_
fPNGtime=ejercicio2_tiempo.png
fPNGspd=ejercicio2_aceleracion.png

echo "Generating plots..."
gnuplot << END_GNUPLOT
set title "Serie-Par Execution Time"
set ylabel "Execution time (s)"
set xlabel "Vector Size"
set key right bottom
set grid
set term png
set output "$fPNGtime"
filenames = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16"
plot "$fMEAN"."1.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fMEAN".core.".dat" using 1:3 with lines lw 2 title "par_{".core."}"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Serie-Par Speedup"
set ylabel "Speedup over serie"
set xlabel "Vector Size"
set key right bottom
set grid
set term png
set output "$fPNGspd"
filenames = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16"
plot "$fSPD"."1.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fSPD".core.".dat" using 1:3 with lines lw 2 title "par_{".core."}"
replot
quit
END_GNUPLOT
