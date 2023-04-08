;****************************************************************************************************************************
;Program name: "Benchmark".                                                                                                 *
; This program will allow a user to input float numbers into 2 different arrays of size 35, display the contents, and       *
; calculate the magnitude for each array. It will then append the two arrays together into a new array of size 70.          *
; It will then display the contents of the new array and calculate the magnitude of the new array.                          *
; Copyright (C) 2023 Jared Pope.                                                                                            *
;                                                                                                                           *
;This file is part of the software program "Benchmark".                                                                     *
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


global getradicand


segment .bss

segment .data
enter_num db "Please enter a floating radicand for square root bench marking: ", 0

float_form db "%lf", 0


segment .text
getradicand:

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

;Print "Please enter a floating radicand for square root bench marking: "
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, enter_num          ;Set the first argument to the address of enter
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to read in radicand
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, float_form         ;Set the first argument to the address of float_form
mov rsi, rsp                ;Set the second argument to the address of the rsp
call scanf                  ;Call the scanf function
movsd xmm12, [rsp]          ;Store the input into xmm12
pop rax                     ;Pop the 0 off the stack


pop rax
movsd xmm0, xmm12           ;Return the input number


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

