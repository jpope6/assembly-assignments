#!/bin/bash

# Program: Array of Integers
# Author: Jared Pope

# Purpose: script file to run program files together
# Clear any previously compiled outputs
rm *.o
rm *.out 
rm *.lis

echo "Assemble manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Complile magnitude.asm"
nasm -f elf64 -l magnitude.lis -o magnitude.o magnitude.asm

echo "Compile input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

echo "Compile append.asm"
nasm -f elf64 -l append.lis -o append.o append.asm

echo "Complile display_array.c using gcc compiler standard 2017"
gcc -c -m64 -Wall -std=c17 -o display_array.o display_array.c -fno-pie -no-pie

echo "Compile main.c using gcc compiler standard 2017"
gcc -c -m64 -Wall -std=c17 -o main.o main.c -fno-pie -no-pie

echo "Link the object files using the g++ linker standard 2017"
g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie manager.o magnitude.o input_array.o append.o display_array.o main.o

echo "Run the program Array"
./a.out 

echo "The script file will terminate"

# Clean up after program is done
rm *.o
rm *.lis
rm *.out
