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
;   Assemble: nasm -f elf64 -l magnitude.lis -o magnitude.o magnitude.asm
;   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie manager.o magnitude.o input_array.o append.o display_array.o main.o
;   Purpose: This module will take the array and calculate the magnitude of the array. The magnitude is the square root of 
;            the sum of the squares of the values in the array. The magnitude will be return to the manager module.
;========================================================================================================

;Decleration
global magnitude

segment .data

segment .bss

segment .text
magnitude:

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

;loop through the array
;square each double
;add the squares together
;taking the square root of the sum
push qword 0

mov r15, rdi ;r15 = array
mov r14, rsi ;r14 = size

;loop through array, square each value, add to sum
mov rax, 2 ;we will be using 2 xmm registers
mov rdx, 0 
cvtsi2sd xmm15, rdx ;convert rdx to double and store in xmm15
cvtsi2sd xmm14, rdx ;convert rdx to double and store in xmm14
mov r13, 0
loop:
cmp r13, r14 ;compare i to size
je endloop ;if i == size, end loop
movsd xmm15, [r15 + r13*8] ;xmm15 = array[i]
mulsd xmm15, xmm15 ;xmm15 = array[i]^2
addsd xmm14, xmm15 ;xmm14 = sum
inc r13 ;i++
jmp loop 

endloop:
sqrtsd xmm14, xmm14 ;xmm14 = sqrt(sum)

;return the value
pop rax
movsd xmm0, xmm14 ;xmm0 = sqrt(sum)

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
pop rbp

ret

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
