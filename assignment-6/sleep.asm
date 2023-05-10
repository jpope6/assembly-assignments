;**********************************************************************************************************************
;Function name: "Get Radicand". This Program will ask for your the radicand that you want to test the benchmark with  *
;                                   and will return it the manager module.                                            *
; Copyright (C) 2023 Jared Pope                                                                                       *
;                                                                                                                     *
;Get Frequency is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General   *
;Public License, version 3, as published by the Free Software Foundation.                                             *
;Get Frequency is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied  * 
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more *
;details.  You should have received a copy of the GNU Lesser General Public License along with Get Frequency.  If not *
;see <https://www.gnu.org/licenses/>.                                                                                 *
;**********************************************************************************************************************
;Author information
;  Author name: Jared Pope
;  Author email: imthepope@csu.fullerton.edu
;
;Program information
;  Program name: Get Radicand
;  Programming languages: Assembly, C++, bash
;  Date program began: 2023 April 3
;  Date of last update: 2023 April 16
;  Date of reorganization of comments: 2023 April 16
;  Files in this program: manager.asm, getradicand.asm, get_clock_freq.asm, main.cpp, r.sh
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;
;This file
;   File name: getradicand.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm
;   Link: g++ -m64 -fno-pie -no-pie -o a.out getradicand.o get_clock_freq.o manager.o main.o -fno-pie -no-pie
;   Purpose: This is the getradicand module. This module will ask the user what radicand they want to use for 
;               the square root benchmark test and will return it to the manager module.
;======================================================================================================================


;Decleration
extern printf
extern scanf


global sleep


segment .bss

segment .data
enter_num db "Please enter a floating radicand for square root bench marking: ", 0

float_form db "%lf", 0


segment .text
sleep:

;Prolog ===== Insurance for any caller of this assembly module ========================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov rbp, rsp
push rdi
push rsi
push rdx
push rcx
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
push rbx
pushf

push qword 0

pop rax


;===== Restore original values to integer registers ===================================================================
popf
pop rbx
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rcx
pop rdx
pop rsi
pop rdi
mov rsp, rbp
pop rbp

ret
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3

