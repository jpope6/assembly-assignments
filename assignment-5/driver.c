//****************************************************************************************************************************
//Program name: "Arrays of Integers".                                                                                        *
// This program will allow a user to input float numbers into 2 different arrays of size 35, display the contents, and       *
// calculate the magnitude for each array. It will then append the two arrays together into a new array of size 70.          *
// It will then display the contents of the new array and calculate the magnitude of the new array.                          *
// Copyright (C) 2023 Jared Pope.                                                                                            *
//                                                                                                                           *
//This file is part of the software program "Arrays of Integers".                                                            *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************


//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Jared Pope
//  Author email: imthepope@csu.fullerton.edu
//
//Program information
//  Program name: Arrays of Integers
//  Programming languages: Assembly, C, bash
//  Date program began: 2023 February 10
//  Date of last update: 2023 February 21
//  Date of reorganization of comments: 2023 February 21
//  Files in this program: append.asm, display_array.c, input_array.asm, magnitude.asm, main.c, manager.asm, r.sh 
//  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
//
//This file
//   File name: main.c
//   Language: C
//   Max page width: 132 columns
//   Compile: gcc -c -m64 -Wall -std=c17 -o main.o main.c -fno-pie -no-pie
//   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie manager.o magnitude.o input_array.o append.o display_array.o main.o
//   Purpose: This file contains the main function for the program. It calls the manager function and prints the magnitude
//         returned by the manager function. It returns a 0 to the operating system when finished.
//========================================================================================================


#include <stdio.h>
#include <stdint.h>

extern double manager();


int main(int argc, char *argv[]) {
    printf("Welcome to Asterix Software Development Corporation\n");
    manager();
    return 0;
}
