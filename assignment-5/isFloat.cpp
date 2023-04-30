//****************************************************************************************************************************
//Program name: "isFloat".                                                                                                   *
//  This program takes a char array as an input and will validate if the input is a float or not. This module will return    *
//      true if it is a float and false if it is not a float                                                                 *
// Copyright (C) 2023 Jared Pope.                                                                                            *
//                                                                                                                           *
//This file is part of the software program "Sine Benchmark".                                                                *
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
//  Program name: ifFloat
//  Programming languages: Assembly, C, C++, bash
//  Date program began: 2023 April 30
//  Date of last update: 2023 April 17
//  Date of reorganization of comments: 2023 April 30
//  Files in this program: isFloat.cpp, driver.c, manager.asm, r.sh 
//  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
//
//This file
//   File name: isFloat.cpp
//   Language: X86 with Intel syntax.
//   Max page width: 132 columns
//   Compile: g++ -c -m64 -Wall -l isFloat.lis -o isFloat.o isFloat.cpp -fno-pie -no-pie -std=c++17
//   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie isFloat.o manager.o driver.o
//   Purpose: This module will take in a char array and will return whether or not it is a float number or not.
//      True will be return if it is a float, otherwise it will return false.
//========================================================================================================

#include <iostream>

extern "C" bool isFloat(char [ ]);

bool isFloat(char w[ ])
{   bool result = true;
    bool onepoint = false;
    int start = 0;
    if (w[0] == '-' || w[0] == '+') start = 1;
    unsigned long int k = start;
    while (!(w[k] == '\0') && result )
    {    if (w[k] == '.' && !onepoint)
               onepoint = true;
         else
               result = result && isdigit(w[k]) ;
         k++;
     }
     return result && onepoint;
}
