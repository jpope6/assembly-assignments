;****************************************************************************************************************************
;Program name: "Non-deterministic Random Numbers".                                                                          *
; This program will allow a user to input float numbers into 2 different arrays of size 35, display the contents, and       *
; calculate the magnitude for each array. It will then append the two arrays together into a new array of size 70.          *
; It will then display the contents of the new array and calculate the magnitude of the new array.                          *
; Copyright (C) 2023 Jared Pope.                                                                                            *
;                                                                                                                           *
;This file is part of the software program "Non-deterministic Random Numbers".                                              *
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
;  Programming languages: Assembly, C++, bash
;  Date program began: 2023 February 27
;  Date of last update: 2023 February 21
;  Date of reorganization of comments: 2023 February 21
;  Files in this program: main.cpp executive.asm fill_random_array.asm quick_sort.cpp show_array.asm
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;
;This file
;   File name: executive.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l executive.lis -o executive.o executive.asm
;   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie manager.o magnitude.o input_array.o append.o display_array.o main.o
;   Purpose: 
;=============================================================================================================================


;Decleration
extern printf
extern scanf

global executive


segment .bss


segment .data
name db "Please enter your name:", 0
string_name db "%s", 0
title db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc):", 0
string_title db "%s", 0
greeting db "Nice to meet you %s %s", 0


segment .txt
executive:

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

;Print "Please enter you name: "
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, name               ;Set the first argument to the address of name
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Print "Please enter you title: "
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, title              ;Set the first argument to the address of title
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack


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
