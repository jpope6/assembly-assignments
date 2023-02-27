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
;   Assemble: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
;   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie manager.o magnitude.o input_array.o append.o display_array.o main.o
;   Purpose: This file contains the source code for the inputArray function. It will allow the user to input float numbers
;            into an array of size 35. It will then return the number of inputs.
;========================================================================================================


;Decleration
extern scanf
extern stdin
extern clearerr

global inputArray

segment .data
floatform db "%lf", 0

segment .bss
;empty

segment .text
inputArray:                     ;Start of the inputArray function

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
pushf

push qword 0                    ;Push a 0 to the stack
mov r15, rdi                    ;Save the address of the array in r15
mov r14, rsi                    ;Save the size of the array in r14

; while input is not Ctrl+D
; loop an input of numbers
; and store them in the array 
mov r13, 0                      ;Set the counter to 0
loop:
cmp r13, r14                    ;Check if the counter is equal to the size of the array 
je endloop                      ;If it is, jump to the end of the loop
mov rax, 0
mov rdi, floatform              ;Set the format to %lf
push qword 0                    ;Push a 0 to the stack
mov rsi, rsp                    ;Set the address of the 0 to rsi
call scanf                      ;Call scanf
cdqe                            ;Convert the return value to a 64 bit integer
cmp rax, -1                     ;Check if the input is Ctrl+D
pop r12
je endloop                      ;If it is, jump to the end of the loop
mov [r15 + 8*r13], r12        ;Store the input in the array 
inc r13                         ;Increment the counter
jmp loop                        ;Jump to the start of the loop

endloop:
;Set the failbit to 0
push qword 0
mov rax, 0
mov rdi, [stdin]
call clearerr
pop rax

pop rax
mov rax, r13                    ;Set the return value to the number of inputs

;===== Restore original values to integer registers ===================================================================
popf
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
pop rbp

ret

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
