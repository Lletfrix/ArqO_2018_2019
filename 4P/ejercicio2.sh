#!/bin/bash

# compila los programas slow y fast si no están compilados.
make &> /dev/null
# inicializar variables
low=250000
high=25000000
steps=10
incr=$(((high-low)/(steps)))
reps=10
C=8
fDAT=ejercicio2.dat
fMEAN=means_time_
fSPD=speedup_
fPNGtime=ejercicio2_tiempo.png
fPNGspd=ejercicio2_aceleracion.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG *.dat

# generar el fichero DAT vacío
touch $fDAT

echo "Running serie and par..."

for ((rep = 1; rep <= $reps; rep += 1)); do
    for ((N = low ; N <= high ; N += incr)); do
    	echo "N: $N / $high..."
        serieTime=$(./pescalar_serie $N | grep 'Tiempo' | awk '{print $2}')
        for ((core = 1; core <= C; core+= 1)); do
            parTime=$(./pescalar_par2 $N $core| grep 'Tiempo' | awk '{print $2}')
            echo "$N $core $serieTime $parTime" >> $fDAT
        done

    done
done

echo "Calculating means..."

for ((N = low ; N <= high ; N += incr)); do
    echo "N: $N / $high..."
    for ((core = 1; core <= C; core+= 1)); do
        means=$(awk -v N=$((N)) -v core=$((core)) '{if ($1 == N && $2 == core) printf ("%s %s\n",$3,$4);}'  < $fDAT | awk -v rep=$((reps)) '{{serie+=$1}; {par+=$2};} END {printf("%s %s\n",serie/rep,par/rep)}')
        echo "$N $means" >> $fMEAN$core.dat
    done

done

for ((core = 1 ; core <= C ; core += 1)); do
    line=$(awk '{printf("%s %s %s\n",$1,$2/$2,$2/$3)}' < $fMEAN$core.dat)
    echo "$line" >> $fSPD$core.dat
done

echo "Generating plots..."
gnuplot << END_GNUPLOT
set title "Serie-Par Execution Time"
set ylabel "Execution time (s)"
set xlabel "Vector Size"
set key right bottom
set grid
set term png
set output "$fPNGtime"
filenames = "1 2 3 4 5 6 7 8"
plot "$fMEAN"."1.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fMEAN".core.".dat" using 1:3 with lines lw 2 title "par_".core
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Serie-Par Speedup"
set ylabel "Execution time (s)"
set xlabel "Vector Size"
set key right bottom
set grid
set term png
set output "$fPNGspd"
filenames = "1 2 3 4 5 6 7 8"
plot "$fSPD"."1.dat" using 1:2 with lines dt 2 title "serie", \
     for [core in filenames] "$fSPD".core.".dat" using 1:3 with lines lw 2 title "par_".core
replot
quit
END_GNUPLOT
