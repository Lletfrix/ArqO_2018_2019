#!/bin/bash

# compila los programas slow y fast si no están compilados.
make &> /dev/null
# inicializar variables
reps=3
P=7
Ninicio=$((64+64*$P))
Npaso=16
Nfinal=$((64+64*($P+1)))
fDAT=ejercicio4
ftPNG=ej4_time.png
frPNG=ej4_read.png
fwPNG=ej4_write.png
fCACHE=cache4.dat

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT*.dat $frPNG $ftPNG $fwPNG

echo "Running normal and transposed..."
for ((nvias = 1; nvias <= 8; nvias*=8)); do
    for ((cache = 16384; cache <= 32768; cache*=2)); do
        touch "$fDAT"-"$cache"-"$nvias".dat
        for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
        	echo "N: $N / $Nfinal..."
            multTime=$(valgrind --tool=cachegrind --I1=$cache,$nvias,64 --D1=$cache,$nvias,64 --cachegrind-out-file=$fCACHE ./mult $N 2> /dev/null | grep 'time' | awk '{print $3}')
        	multMisses=$(cg_annotate $fCACHE | head -n 30 | awk '{if($NF == "TOTALS") printf("%s %s\n", $5, $8)}' | sed 's/,//g')
            rm $fCACHE
            transTime=$(valgrind --tool=cachegrind --I1=$cache,$nvias,64 --D1=$cache,$nvias,64 --cachegrind-out-file=$fCACHE ./multT $N 2> /dev/null | grep 'time' | awk '{print $3}')
        	transMisses=$(cg_annotate $fCACHE | head -n 30 | awk '{if($NF == "TOTALS") printf("%s %s\n", $5, $8)}' | sed 's/,//g')
            rm $fCACHE
        	echo "$N $multTime $multMisses $transTime $transMisses" >> "$fDAT"-"$cache"-"$nvias".dat
        done
    done
done

echo "Generating plots..."

gnuplot << END_GNUPLOT
    set title "Normal-Trans Execution Time"
    set ylabel "Execution Time (s)"
    set xlabel "Matix Size"
    set key left top
    set grid
    set term png
    set output "$ftPNG"
    filenames = "-16384-1 -16384-8 -32768-1 -32768-8"
    plot for [comb in filenames] "$fDAT".comb.".dat" using 1:2 with lines lw 2 title "normal".comb, \
         for [comb in filenames] "$fDAT".comb.".dat" using 1:5 with lines dt 2 title "trans".comb
    replot
    quit
END_GNUPLOT

gnuplot << END_GNUPLOT
    set title "Normal-Trans Cache Read Misses"
    set ylabel "Read Misses"
    set xlabel "Matix Size"
    set key left top
    set grid
    set term png
    set output "$frPNG"
    filenames = "-16384-1 -16384-8 -32768-1 -32768-8"
    plot for [comb in filenames] "$fDAT".comb.".dat" using 1:3 with lines lw 2 title "normal".comb, \
         for [comb in filenames] "$fDAT".comb.".dat" using 1:6 with lines dt 2 title "trans".comb
    replot
    quit
END_GNUPLOT

gnuplot << END_GNUPLOT
    set title "Normal-Trans Cache Write Misses"
    set ylabel "Write Misses"
    set xlabel "Matix Size"
    set key left top
    set grid
    set term png
    set output "$fwPNG"
    filenames = "-16384-1 -16384-8 -32768-1 -32768-8"
    plot for [comb in filenames] "$fDAT".comb.".dat" using 1:4 with lines lw 2 title "normal".comb, \
         for [comb in filenames] "$fDAT".comb.".dat" using 1:7 with lines dt 2 title "trans".comb
    replot
    quit
END_GNUPLOT
