#!/bin/bash

# Program: Benchmark
# Author: Jared Pope

# Purpose: script file to run program files together

# Clear any previously compiled outputs
rm *.o
rm *.out 
rm *.lis

echo "Assemble birthday.asm"
nasm -f elf64 -l birthday.lis -o birthday.o birthday.asm

echo "Compile main.cpp using gcc compiler standard 2017"
g++ -c -m64 -Wall -l main.lis -o main.o main.cpp -fno-pie -no-pie -std=c++17

echo "Link the object files using the g++ linker standard 2017"
g++ -m64 -fno-pie -no-pie -o a.out birthday.o main.o -fno-pie -no-pie

echo "Run the program"
./a.out 

echo "The script file will terminate"

# Clean up after program is done
rm *.o
rm *.lis
rm *.out
