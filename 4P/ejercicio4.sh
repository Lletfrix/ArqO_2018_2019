#!/bin/bash
echo "Padding 1:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 1 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 2:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 2 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 4:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 4 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 6:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 6 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 7:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 7 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 8:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 8 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 9:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 9 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 10:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 10 | grep "Tiempo" | awk '{print $2}'
done
echo "Padding 12:"
for ((i=1; i<=5; i+=1)); do
    ./pi_par3 12 | grep "Tiempo" | awk '{print $2}'
done
