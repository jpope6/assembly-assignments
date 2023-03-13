# Non-deterministic Random Numbers  

## Description  
This assembly program generates up to 100 random 64-bit numbers using the non-deterministic random number generator found inside modern X86 microprocessors. Initially, random numbers are generated that extend throughout the entire space of all 64-bit IEEE754 numbers. Later, the random numbers are restricted to the interval 1.0 <= Number < 2.0.

## Goals  
This program is designed to provide experience in the following areas:

How to obtain 64-bit random numbers without a "seed"
How to input string data that may contain white space

## Requirements
The program should be written in assembly language and include the following features:

Generate up to 100 random 64-bit numbers without a seed  
Normalize the array to be between the intervals of 1.0 <= number < 2  
Sort the array and the normalized array using qsort  
Ask the user for their name and title and return name to the main function  
