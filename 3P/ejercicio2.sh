#!/bin/bash

# compila los programas slow y fast si no están compilados.
make &> /dev/null
# inicializar variables
reps=3
P=7
#Ninicio=$((2000+1024*$P))
#Npaso=64
#Nfinal=$((2000+1024*($P+1)))
Ninicio=100
Npaso=100
Nfinal=1000
fDAT=cache_
frPNG=cache_lectura.png
fwPNG=cache_escritura.png
fCACHE=cache2.dat

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT*.dat $fwPNG $frPNG $fCACHE

echo "Running cachegrind..."
# bucle para N desde P hasta Q
#for N in $(seq $Ninicio $Npaso $Nfinal);

for ((cache=1024; cache<=8192; cache*=2)); do
    for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
    	echo "N: $N / $Nfinal..."
        valgrind --tool=cachegrind --I1=$cache,1,64 --D1=$cache,1,64 --LL=8192,1,64 --cachegrind-out-file=$fCACHE ./slow $N &> /dev/null
    	slowMisses=$(cg_annotate $fCACHE | head -n 30 | awk '{if($NF == "TOTALS") printf("%s %s\n", $5, $8)}' | sed 's/,//g')
        rm $fCACHE
        valgrind --tool=cachegrind --I1=$cache,1,64 --D1=$cache,1,64 --LL=8192,1,64 --cachegrind-out-file=$fCACHE ./fast $N &> /dev/null
    	fastMisses=$(cg_annotate $fCACHE | head -n 30 | awk '{if($NF == "TOTALS") printf("%s %s\n", $5, $8)}' | sed 's/,//g')
        rm $fCACHE
    	echo "$N $slowMisses $fastMisses" >> $fDAT$cache.dat
    done
done
echo "Generating plots..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"

gnuplot << END_GNUPLOT
    set title "Slow-Fast Cache Read Misses"
    set ylabel "Read Misses"
    set xlabel "Matix Size"
    set key left top
    set grid
    set term png
    set output "$frPNG"
    filenames = "1024 2048 4096 8192"
    plot for [cache in filenames] "$fDAT".cache.".dat" using 1:2 with lines lw 2 title cache."_{slow}", \
         for [cache in filenames] "$fDAT".cache.".dat" using 1:4 with lines lw 2 title cache."_{fast}"
    replot
    quit
END_GNUPLOT
gnuplot << END_GNUPLOT
    set title "Slow-Fast Cache Write Misses"
    set ylabel "Write Misses"
    set xlabel "Matix Size"
    set key left top
    set grid
    set term png
    set output "$fwPNG"
    filenames = "1024 2048 4096 8192"
    plot for [cache in filenames] "$fDAT".cache.".dat" using 1:3 with lines lw 2 title cache."_{slow}", \
         for [cache in filenames] "$fDAT".cache.".dat" using 1:5 with lines dt 2 title cache."_{fast}"
    replot
    quit
END_GNUPLOT

rm $fCACHE
