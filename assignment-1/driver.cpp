//****************************************************************************************************************************
//Program name: "Pythagoras".  This program demonstrates how to calculate the hypotenuse of a right triangle                 *
//The X86 function takes inputs of 2 triangle sides and calculates the hypotenuse, the C++ receives the calculated           *
//hypotenuse.  Copyright (C) 2023  Jared Pope                                                                                *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
//version 3 as published by the Free Software Foundation.                                                                    *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//The copyright holder may be contacted here: imthepope@csu.fullerton.edu                                                    *
//****************************************************************************************************************************




//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//Author information
//  Author name: Jared Pope
//  Author email: imthepope@csu.fullerton.edu
//
//Program information
//  Program name: Pythagoras
//  Programming languages: Main function in C++; Pythagoras function in X86-64
//  Date program began: 2023-Jan-30
//  Date of last update: 2023-Feb-6
//  Comments reorganized: 2023-Feb-6
//  Files in the program: driver.cpp, pythagoras.asm, r.sh
//
//Purpose
// The intent of this program is to calculate the hypotenuse of a right triangle. The program will prompt the user for the length
// of the two sides of the triangle and then calculate the hypotenuse. The program will then output the hypotenuse to the user.
//
//This file
//  File name: driver.cpp
//  Language: C++
//  Max page width: 132 columns
//  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
//  Compile: g++ -c -m64 -Wall -l driver.lis -o driver.o driver.cpp -fno-pie -no-pie -std=c++17
//  Link: g++ -m64 -fno-pie -no-pie -o pythagorus.out pythagorus.o driver.o -fno-pie -no-pie
//
//Execution: ./r.sh
//
//===== Begin code area ===================================================================================================================================================

#include "stdio.h"
#include "iostream"

using namespace std;

extern "C" double pythagoras();

int main(int argc, char *argv[]) {
    double result = pythagoras();
    printf("\nThe main file received this number: %.12lf, and will keep it for now.\n", result);
    cout << "We hoped you enjoyed your right angles. Have a good day.";
    cout << " A zero will be sent to your operating system." << endl;
    return 0;
} // End of main
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6**
