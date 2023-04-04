;****************************************************************************************************************************
;Program name: "Benchmark".                                                                          *
; This program will allow a user to input float numbers into 2 different arrays of size 35, display the contents, and       *
; calculate the magnitude for each array. It will then append the two arrays together into a new array of size 70.          *
; It will then display the contents of the new array and calculate the magnitude of the new array.                          *
; Copyright (C) 2023 Jared Pope.                                                                                            *
;                                                                                                                           *
;This file is part of the software program "Benchmark".                                              *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Jared Pope
;  Author email: imthepope@csu.fullerton.edu
;
;Program information
;  Program name: Non-deterministic Random Numbers
;  Programming languages: Assembly, C++, C, bash
;  Date program began: 2023 April 3
;  Date of last update: 2023 March 13
;  Date of reorganization of comments: 2023 March 13
;  Files in this program: main.cpp executive.asm fill_random_array.asm quick_sort.cpp show_array.asm, r.sh
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;
;This file
;   File name: executive.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;   Link: g++ -m64 -fno-pie -no-pie -o a.out compar.o show_array.o fill_random_array.o executive.o main.o -fno-pie -no-pie
;   Purpose: This is the central module that will direct calls to different functions including fill_random_array,
;               show_array, and qsort. This module will also ask for the input of the user's name and title and will
;               return the name to the main function
;=============================================================================================================================


;Decleration
extern printf
extern scanf
extern getradicand


global manager


segment .bss

segment .data
welcome db "Welcome to Square Root Benchmarks by Jared Pope", 10, 10, 0
contact db "For customer service contact me at imthepope@csu.fullerton.edu", 10, 10, 0
cpu_type db "Your CPU is AMD Ryzen 3640.", 10, 10, 0
max_clock_speed db "Your max clock speed is 2800 MHz", 10, 10, 0
square_root db "The square root of 12.1999999995 is 3.78457514234.", 10, 10, 0
iterations db "Next enter the number of times iteration should be performed: ", 0
time db "The time on the clock is 2451294 tics.", 10, 10, 0
in_progress db "The bench mark of the sqrtsd instruction is in progress.", 10, 10, 0
complete db "The time on the clock is 2451399 tics and the benchmark is completed.", 10, 10, 0
elapsed_time db "The elapsed time was 238884 tics", 10, 10, 0
time_for_one_sqrt db "The time for one square root computation is 27.36841 tics which equals 9.28441 ns.", 10, 10, 0


segment .text
manager:

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

;Print the welcome message
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, welcome            ;Set the first argument to the address of welcome
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Print the contact message
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, contact            ;Set the first argument to the address of contact
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack


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
