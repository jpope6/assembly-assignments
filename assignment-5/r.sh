#!/bin/bash

# Program: Sine Benchmark
# Author: Jared Pope

# Purpose: script file to run program files together
# Clear any previously compiled outputs
rm *.o
rm *.out 
rm *.lis

echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Compile isFloat.cpp using gcc compiler standard 2017"
g++ -c -m64 -Wall -l isFloat.lis -o isFloat.o isFloat.cpp -fno-pie -no-pie -std=c++17

echo "Compile driver.c using gcc compiler standard 2017"
gcc -c -m64 -Wall -std=c17 -o driver.o driver.c -fno-pie -no-pie

echo "Link the object files using the g++ linker standard 2017"
g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie isFloat.o manager.o driver.o

echo "Run the program Array"
./a.out 

echo "The script file will terminate"

# Clean up after program is done
rm *.o
rm *.lis
rm *.out
