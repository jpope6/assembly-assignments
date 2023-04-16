// ****************************************************************************************************************************
// Program name: "Benchmark".                                                                                                 *
//  This Program will benchmark the performance of the square root function in SSE. It will detect what CPU the user is on.   *
//    If the user is on an Intel CPU, it will detect your max clock speed. If the user is on an AMD CPU, it will ask the      *
//    user for their max clock speed. It will ask for a radicand and how many iterations the user wants to run the square     *
//    root function. It will find the amount of tics it took to run each square root function and calculate how many          *
//    nonseconds it took to run each square root function.                                                                    *
//  Copyright (C) 2023 Jared Pope.                                                                                            *
//                                                                                                                            *
// This file is part of the software program "Benchmark".                                                                     *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
// version 3 as published by the Free Software Foundation.                                                                    *
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
// A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
// ****************************************************************************************************************************
// 
// ========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
// 
// Author information
//   Author name: Jared Pope
//   Author email: imthepope@csu.fullerton.edu
// 
// Program information
//   Program name: Benchmark
//   Programming languages: Assembly, C++, bash
//   Date program began: 2023 April 3
//   Date of last update: 2023 April 16
//   Date of reorganization of comments: 2023 April 16
//   Files in this program: manager.asm, getradicand.asm, get_clock_freq.asm, main.cpp, r.sh
//   Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
// 
// This file
//    File name: main.cpp
//    Language: X86 with Intel syntax.
//    Max page width: 132 columns
//    Compile: g++ -c -m64 -Wall -l main.lis -o main.o main.cpp -fno-pie -no-pie -std=c++17
//    Link: g++ -m64 -fno-pie -no-pie -o a.out getradicand.o get_clock_freq.o manager.o main.o -fno-pie -no-pie
//    Purpose: This is the main program for the program. It calls the manager function and prints the nanoseconds
//              calculated in the manager module. At the end, the program will return 0.
// =============================================================================================================================

//===== Begin code area ===================================================================================================================================================

#include "bits/stdc++.h"

using namespace std;

extern "C" double manager();

int main(int argc, char *argv[]) {
    double ans = manager();
    printf("The main function has received this number %lf and will keep it for future reference.\n", ans);
    printf("\nThe main function will return a zero to the operating system.\n");
    return 0;
} // End of main
  //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6**
