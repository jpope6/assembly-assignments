//****************************************************************************************************************************
//Program name: "Sine Benchmark".                                                                                            *
//   This program will Calculate sine using the MacLaurin Taylor series formula. This program will validate the angle
//       that the user inputs to ensure it is a float value. This program will also run a benchmark for calculating
//       sine using the MacLaurin Taylor series vs using the sin function in the math.h file.
// Copyright (C) 2023 Jared Pope.                                                                                            *
//                                                                                                                           *
//This file is part of the software program "Sine Benchmark".                                                            *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
//****************************************************************************************************************************
//
//========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Jared Pope
//  Author email: imthepope@csu.fullerton.edu
//
//Program information
//  Program name: Sine Benchmark
//  Programming languages: Assembly, C, C++, bash
//  Date program began: 2023 April 30
//  Date of last update: 2023 April 17
//  Date of reorganization of comments: 2023 April 30
//  Files in this program: isFloat.cpp, driver.c, manager.asm, r.sh 
//  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
//
//This file
//   File name: driver.c
//   Language: X86 with Intel syntax.
//   Max page width: 132 columns
//   Compile: gcc -c -m64 -Wall -std=c17 -o driver.o driver.c -fno-pie -no-pie
//   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie isFloat.o manager.o driver.o
//   Purpose: This is the driver module that will call manager.asm.
//========================================================================================================


#include <stdio.h>
#include <stdint.h>

extern int manager();


int main(int argc, char *argv[]) {
    printf("Welcome to Asterix Software Development Corporation\n");
    int ans = manager();
    printf("Thank you for using this program.  Have a great day.\n\n");
    printf("The driver program received this number %d. A zero will be returned to the OS. Bye.\n\n", ans);
    return 0;
}
