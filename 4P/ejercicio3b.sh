#!/bin/bash
#
#$ -cwd
#$ -q intel.q
#$ -j y
#$ -S /bin/bash
#$ -o out3b.txt
#

make &> /dev/null
# inicializar variables
P=7
low=$((512+P))
#high=$((1024+low))
high=$((128+low))
incr=64
reps=10
C=16
fDAT=ejercicio3.dat
fMEAN=ej3_means_time_
fSPD=ej3_speedup_
fPNGtime=ejercicio3_tiempo.png
fPNGspd=ejercicio3_aceleracion.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG *.dat

# generar el fichero DAT vacío
touch $fDAT

echo "Running serie and par..."

for ((rep = 1; rep <= $reps; rep += 1)); do
    for ((N = low ; N <= high ; N += incr)); do
    	echo "N: $N / $high..."
        serieTime=$(./multMatrix_serie $N | grep 'time' | awk '{print $3}')
        for ((core = 4; core <= 4; core+= 1)); do
            export OMP_NUM_THREADS=$core
            parTime=$(./multMatrix_par3 $N | grep 'time' | awk '{print $3}')
            echo "$N $core $serieTime $parTime" >> $fDAT
        done

    done
done

echo "Calculating means..."

for ((N = low ; N <= high ; N += incr)); do
    echo "N: $N / $high..."
    for ((core = 4; core <= 4; core+= 1)); do
        means=$(awk -v N=$((N)) -v core=$((core)) '{if ($1 == N && $2 == core) printf ("%s %s\n",$3,$4);}'  < $fDAT | awk -v rep=$((reps)) '{{serie+=$1}; {par+=$2};} END {printf("%s %s\n",serie/rep,par/rep)}')
        echo "$N $means" >> $fMEAN$core.dat
    done

done

for ((core = 4 ; core <= 4 ; core += 1)); do
    line=$(awk '{printf("%s %s %s\n",$1,$2/$2,$2/$3)}' < $fMEAN$core.dat)
    echo "$line" >> $fSPD$core.dat
done
