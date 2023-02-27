#!/bin/bash

# Author: Jared Pope
# Program name: Pythagorus

nasm -f elf64 -l pythagorus.lis -o pythagorus.o pythagorus.asm

g++ -c -m64 -Wall -l driver.lis -o driver.o driver.cpp -fno-pie -no-pie -std=c++17

g++ -m64 -fno-pie -no-pie -o pythagorus.out pythagorus.o driver.o -fno-pie -no-pie

./pythagorus.out

rm *.lis
rm *.o
rm *.out

