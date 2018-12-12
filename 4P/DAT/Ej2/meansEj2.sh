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
low=3000000
high=300000000
steps=10
incr=$(((high-low)/(steps-1)))
reps=5
C=16
fDAT=ejercicio2.dat
fMEAN=ej2_means_time_
fSPD=ej2_speedup_
fPNGtime=ejercicio2_tiempo.png
fPNGspd=ejercicio2_aceleracion.png

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
