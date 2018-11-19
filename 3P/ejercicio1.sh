#!/bin/bash

# compila los programas slow y fast si no están compilados.
make &> /dev/null
# inicializar variables
reps=3
P=7
Ninicio=$((10000+1024*$P))
Npaso=64
Nfinal=$((10000+1024*($P+1)))
#Ninicio=100
#Npaso=10
#Nfinal=1000
fDAT=ejercicio1.dat
fMEAN=means_time.dat
fPNG=ejercicio1.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG $fMEAN

# generar el fichero DAT vacío
touch $fDAT

echo "Running slow and fast..."

for ((rep = 1; rep <= $reps; rep += 1)); do
    for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
    	echo "N: $N / $Nfinal..."

    	slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
    	fastTime=$(./fast $N | grep 'time' | awk '{print $3}')

    	echo "$N $slowTime $fastTime" >> $fDAT
    done
done

echo "Calculating means..."
for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
    means=$(awk -v N=$((N)) '{if ($1 == N) printf ("%s %s\n",$2,$3);}'  < $fDAT | awk -v rep=$((reps)) '{{s+=$1}; {f+=$2};} END {printf("%s %s\n",s/rep,f/rep)}')
    echo "$N $means" >> $fMEAN
done

echo "Generating plot..."
gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fMEAN" using 1:2 with lines lw 2 title "slow", \
     "$fMEAN" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT
