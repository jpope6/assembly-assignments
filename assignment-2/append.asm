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
;   Assemble: nasm -f elf64 -l append.lis -o append.o append.asm
;   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie manager.o magnitude.o input_array.o append.o display_array.o main.o
;   Purpose: This file contains the code for the append function. It takes in 2 arrays and appends them together into a new array.
;            It returns the total number of elements in the new array.
;===============================================================================================================================


;Decleration
global append 

segment .data

segment .bss

segment .text
append:

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

;Code
;func append(arr1, arr2, arr3, s1, s2)
;returns the total number of elements in arr1 and arr2
mov r15, rdi               ;arr1
mov r14, rsi               ;arr2
mov r13, rdx               ;arr3
mov r12, rcx               ;s1
mov r11, r8                ;s2

mov r10, 0                 ;i
mov r9, 0                  ;j
mov r8, 0                  ;k

append_loop:
cmp r10, r12              ;i < s1
jge append_loop2
movsd xmm0, [r15 + r10 * 8] ;arr1[i]
movsd [r13 + r8 * 8], xmm0  ;arr3[k] = arr1[i]
inc r10                   ;i++
inc r8                    ;k++
jmp append_loop 

append_loop2:
cmp r9, r11               ;j < s2
jge append_loop3
movsd xmm0, [r14 + r9 * 8]  ;arr2[j]
movsd [r13 + r8 * 8], xmm0  ;arr3[k] = arr2[j]
inc r9                    ;j++
inc r8                    ;k++
jmp append_loop2

append_loop3:
mov rax, r8               ;return k

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
mov rsp, rbp
pop rbp

ret

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

