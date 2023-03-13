
// ****************************************************************************************************************************
// Program name: "Non-deterministic Random Numbers".                                                                          *
//  This program will allow a user to input float numbers into 2 different arrays of size 35, display the contents, and       *
//  calculate the magnitude for each array. It will then append the two arrays together into a new array of size 70.          *
//  It will then display the contents of the new array and calculate the magnitude of the new array.                          *
//  Copyright (C) 2023 Jared Pope.                                                                                            *
//                                                                                                                            *
// This file is part of the software program "Non-deterministic Random Numbers".                                              *
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
//   Program name: Non-deterministic Random Numbers
//   Programming languages: Assembly, C++, C, bash
//   Date program began: 2023 February 27
//   Date of last update: 2023 March 13
//   Date of reorganization of comments: 2023 March 13
//   Files in this program: main.cpp executive.asm fill_random_array.asm compar.c show_array.asm r.sh
//   Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
// 
// This file
//    File name: main.cpp
//    Language: X86 with Intel syntax.
//    Max page width: 132 columns
//    Compile: g++ -c -m64 -Wall -l main.lis -o main.o main.cpp -fno-pie -no-pie -std=c++17
//    Link: g++ -m64 -fno-pie -no-pie -o a.out compar.o show_array.o fill_random_array.o executive.o main.o -fno-pie -no-pie
//    Purpose: This is the main module for our program. It calls the executive function and prints the name of the user 
//              returned from the executive function. At the end, the program will return 0. 
// =============================================================================================================================


//===== Begin code area ===================================================================================================================================================

#include "bits/stdc++.h"

using namespace std;

extern "C" char* executive();

int main(int argc, char *argv[]) {
    printf("Welcome to Random Products, LLC\n");
    printf("This software is mantained by Jared Pope\n");
    char* name = executive();
    printf("Oh, %s.  We hope you enjoyed your arrays.  Do come again.\n", name);
    printf("A zero will be returned to the operating system.\n");
    return 0;
} // End of main
  //=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6**
