;****************************************************************************************************************************
;Program name: "Arrays of Integers".                                                                                        *
; This program will allow a user to input float numbers into 2 different arrays of size 35, display the contents, and       *
; calculate the magnitude for each array. It will then append the two arrays together into a new array of size 70.          *
; It will then display the contents of the new array and calculate the magnitude of the new array.                          *
; Copyright (C) 2023 Jared Pope.                                                                                            *
;                                                                                                                           *
;This file is part of the software program "Arrays of Integers".                                                            *
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
;  Program name: Arrays of Integers
;  Programming languages: Assembly, C, bash
;  Date program began: 2023 February 10
;  Date of last update: 2023 February 21
;  Date of reorganization of comments: 2023 February 21
;  Files in this program: append.asm, display_array.c, input_array.asm, magnitude.asm, main.c, manager.asm, r.sh 
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;
;This file
;   File name: manager.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie manager.o magnitude.o input_array.o append.o display_array.o main.o
;   Purpose: This is the central module that will direct calls to different functions including inputArray, display_array,
;            magnitude, and append.
;            Using those functions, the magnitude of the new array containing array A and array B will be returned to 
;            the main file.
;========================================================================================================


;Decleration
extern printf
extern scanf
extern fgets
extern stdin
extern strlen

global manager

INPUT_LEN equ 256

segment .bss
string_name resb INPUT_LEN

segment .data

program db 10, "This program Sine Function Benchmark is maintained by Jared Pope", 10, 0
name db 10, "Please enter your name: ", 0
angle_number db 10, "It is nice to meet you %s.  Please enter an angle number in degrees: ", 0
num_terms db 10, "Thank you.  Please enter the number of terms in a Taylor series to be computed: ", 0
compute db 10, "Thank you.  The Taylor series will be used to compute the sine of your angle.", 10, 0

floatformat db "%lf", 0
intformat db "%d", 0

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

;Block to print "This program Sine Function Benchmark is maintained by..."
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, program            ;Set the first argument to the address of program
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Print "Please enter your name: "
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, name               ;Set the first argument to the address of name
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Prompt for name
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, string_name        ;Set the first argument to the address of string_name
mov rsi, INPUT_LEN          ;Set the second argument to max input length
mov rdx, [stdin]            ;Store the input into rdx
call fgets                  ;Call the C function to get a line of text and stop when NULL is encountered or 31 chars have been stored.
pop rax                     ;Pop the 0 off the stack

;Block to remove the \n from string_name
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, string_name        ;Set the first argument to the address of string_name
call strlen                 ;Call external function strlen, which returns the length of the string leading up to '\0'
sub rax, 1                  ;The length is stored in rax. Here we subtract 1 from rax to obtain the location of '\n'
mov byte [string_name + rax], 0 ;Replace the byte where '\n' exits with '\0'
pop rax                     ;Pop the 0 off the stack

;Print "Its nice to meet you..., please enter an angle number in degrees."
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, angle_number       ;Set the second argument to the address of angle_number
mov rsi, string_name        ;Set the first argument to the address of string_name
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to prompt user for the angle number
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, floatformat        ;Set the first argument to floatformat
mov rsi, rsp                ;Set the second argument to rsp
call scanf                  ;Call the scanf function
movsd xmm0, [rsp]           ;Store the input in xmm0
pop rax                     ;Pop the 0 off the stack

;Print "Please enter the number of terms in a Taylor series to be computed: "
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, num_terms          ;Set the first argument to the address of num_terms
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to prompt user for number of terms for Taylor series
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, intformat          ;Set the first argument to floatformat
mov rsi, rsp                ;Set the second argument to rsp
call scanf                  ;Call the scanf function
mov r15, [rsp]              ;Store the input in r15
pop rax                     ;Pop the 0 off the stack

;Print "The Taylor series will be used to compute the sine of your angle."
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, compute            ;Set the first argument to the address of num_terms
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
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
