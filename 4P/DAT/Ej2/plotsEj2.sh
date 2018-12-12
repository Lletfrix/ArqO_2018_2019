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
fMEAN=ej2_means_time_
fSPD=ej2_speedup_
fPNGtime=ejercicio2_tiempo.png
fPNGspd=ejercicio2_aceleracion.png

echo "Generating plots..."
gnuplot << END_GNUPLOT
set title "Serie-Par Execution Time"
set ylabel "Execution time (s)"
set xlabel "Vector Size"
set key right bottom
set grid
set output "$fPNGtime"
set terminal pngcairo dashed
set style line 1  lc rgb '#006be5' lt 1 lw 1.5 # --- blue
set style line 2  lc rgb '#0e64d8' lt 1 lw 1.5 #      .
set style line 3  lc rgb '#1d5dcc' lt 1 lw 1.5 #      .
set style line 4  lc rgb '#3a50b3' lt 1 lw 1.5 #      .
set style line 5  lc rgb '#4949a7' lt 1 lw 1.5 #      .
set style line 6  lc rgb '#58429a' lt 1 lw 1.5 #      .
set style line 7  lc rgb '#663c8e' lt 1 lw 1.5 #      .
set style line 8  lc rgb '#753582' lt 1 lw 1.5 #      .
set style line 9 lc rgb '#842e75' lt 1 lw 1.5 #      .
set style line 10 lc rgb '#922869' lt 1 lw 1.5 #      .
set style line 11 lc rgb '#a1215c' lt 1 lw 1.5 #      .
set style line 12 lc rgb '#b01a50' lt 1 lw 1.5 #      .
set style line 13 lc rgb '#be1444' lt 1 lw 1.5 #      .
set style line 14 lc rgb '#cd0d37' lt 1 lw 1.5 #      .
set style line 15 lc rgb '#dc062b' lt 1 lw 1.5 #      .
set style line 16 lc rgb '#eb001f' lt 1 lw 1.5 # --- red
filenames = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16"
plot "$fMEAN"."1.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fMEAN".core.".dat" using 1:3 with lines ls core title "par_{".core."}"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Serie-Par Speedup"
set ylabel "Speedup over serie"
set xlabel "Vector Size"
set key right bottom
set grid
set output "$fPNGspd"
set terminal pngcairo dashed
set style line 1  lc rgb '#006be5' lt 1 lw 1.5 # --- blue
set style line 2  lc rgb '#0e64d8' lt 1 lw 1.5 #      .
set style line 3  lc rgb '#1d5dcc' lt 1 lw 1.5 #      .
set style line 4  lc rgb '#3a50b3' lt 1 lw 1.5 #      .
set style line 5  lc rgb '#4949a7' lt 1 lw 1.5 #      .
set style line 6  lc rgb '#58429a' lt 1 lw 1.5 #      .
set style line 7  lc rgb '#663c8e' lt 1 lw 1.5 #      .
set style line 8  lc rgb '#753582' lt 1 lw 1.5 #      .
set style line 9 lc rgb '#842e75' lt 1 lw 1.5 #      .
set style line 10 lc rgb '#922869' lt 1 lw 1.5 #      .
set style line 11 lc rgb '#a1215c' lt 1 lw 1.5 #      .
set style line 12 lc rgb '#b01a50' lt 1 lw 1.5 #      .
set style line 13 lc rgb '#be1444' lt 1 lw 1.5 #      .
set style line 14 lc rgb '#cd0d37' lt 1 lw 1.5 #      .
set style line 15 lc rgb '#dc062b' lt 1 lw 1.5 #      .
set style line 16 lc rgb '#eb001f' lt 1 lw 1.5 # --- red
filenames = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16"
plot "$fSPD"."1.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fSPD".core.".dat" using 1:3 with lines ls core title "par_{".core."}"
replot
quit
END_GNUPLOT
