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
incr=33000000
reps=5
C=16
fDAT=ejercicio2.dat
fMEAN=ej2_means_time_
fSPD=ej2_speedup_
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
            export OMP_NUM_THREADS=$core
            parTime=$(./pescalar_par2 $N | grep 'Tiempo' | awk '{print $2}')
            echo "$N $core $serieTime $parTime" >> $fDAT
        done

    done
done
