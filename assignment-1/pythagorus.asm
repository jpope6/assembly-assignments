;****************************************************************************************************************************
;Program name: "Pythagoras".  This program demonstrates how to calculate the hypotenuse of a right triangle                 *
;The X86 function takes inputs of 2 triangle sides and calculates the hypotenuse, the C++ receives the calculated           *
;hypotenuse.  Copyright (C) 2023  Jared Pope                                                                                *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;The copyright holder may be contacted here: imthepope@csu.fullerton.edu                                                    *
;****************************************************************************************************************************
;
;
;
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Jared Pope
;  Author email: imthepope@csu.fullerton.edu
;
;Program information
;  Program name: Pythagoras
;  Programming languages: Main function in C++; Pythagoras function in X86-64
;  Date program began: 2023-Jan-30
;  Date of last update: 2023-Feb-6
;  Comments reorganized: 2023-Feb-6
;  Files in the program: driver.cpp, pythagoras.asm, r.sh
;
;Purpose
; The intent of this program is to calculate the hypotenuse of a right triangle. The program will prompt the user for the length
; of the two sides of the triangle and then calculate the hypotenuse. The program will then output the hypotenuse to the user.
;
;This file
;  File name: pythagoras.asm
;  Language: X86-64
;  Syntax: Intel
;  Max page width: 172 columns
;  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
;  Assemble: nasm -f elf64 -l pythagorus.lis -o pythagorus.o pythagorus.asm
;
;===== Begin code area ===================================================================================================================================================


;Declaration
global pythagoras                                           ;The name of the module
extern printf                                               ;external c++ function for writing to standard output device
extern scanf                                                ;external c++ function for reading from standard input device


segment .data                                              ;Place initialized data here

;===== Declare some messages ==============================================================================================================================================
;The identifiers in this segment are quadword pointers to ascii strings stored in heap space.  They are not variables.  They are not constants.  There are no constants in
;assembly programming.  There are no variables in assembly programming: the registers assume the role of variables.


welcome db "Welcome to Pythagoras' Math Lab programmed by Jared Pope", 10, 0

contact db "Please contact me at imthepope@csu.fullerton.edu if you need assistance.", 10, 10, 0

prompt1 db "Enter the length of the first side of the triangle: ", 0
float_form1 db "%lf", 0 ;%lf is the format specifier for a double

prompt2 db "Enter the length of the second side of the triangle: ", 0
float_form2 db "%lf", 0 ;%lf is the format specifier for a double

confirm db 10, "Thank you. You entered two sides: %0.8f and %0.8f", 10, 0

hypotenuse db "The hypotenuse of the triangle is: %0.8f", 10, 0
hypotenuse_float db "%lf", 0 ;%lf is the format specifier for a double

segment .bss                                              ;Declare pointers to uninitialized data here
;empty

segment .text                                             ;Place executable instructions here
pythagoras:                                               ;Entry point. Execution begins here

;Prolog ===== Insurance for any caller of this assembly module ========================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov  rbp,rsp
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf
pushf

;Executable code

;block to output welcome message
mov rax, 0                          ;Set the system call number to 0
mov rdi, welcome                    ;Set the first argument to the address of the welcome messages
call printf                         ;Call the printf function

;block to output contact information
mov rax, 0                          ;Set the system call number to 0
mov rdi, contact                    ;Set the first argument to the address of the contact information
call printf                         ;Call the printf function

;block to prompt user for first side
mov rax, 0                          ;Set the system call number to 0
mov rdi, prompt1                    ;Set the first argument to the address of the prompt1 message 
call printf                         ;Call the printf function

;block to read in first side
mov rax, 0                          ;Set the system call number to 0
mov rdi, float_form1                ;Set the first argument to the address of the float_form1 message 
push qword 0                        ;Push a 64-bit zero onto the stack
mov rsi, rsp                        ;Set the second argument to the address of the stack
call scanf                          ;Call the scanf function
movsd xmm12, [rsp]                  ;Move the 64-bit value from the stack to the xmm12 register 
pop rax                             ;Pop the 64-bit value from the stack

;block to prompt user for second side
mov rax, 0                          ;Set the system call number to 0
mov rdi, prompt2                    ;Set the first argument to the address of the prompt2 message 
call printf                         ;Call the printf function

;block to read in second side
mov rax, 0                          ;Set the system call number to 0
mov rdi, float_form2                ;Set the first argument to the address of the float_form2 message 
push qword 0                        ;Push a 64-bit zero onto the stack
mov rsi, rsp                        ;Set the second argument to the address of the stack
call scanf                          ;Call the scanf function
movsd xmm13, [rsp]                  ;Move the 64-bit value from the stack to the xmm13 register 
pop rax                             ;Pop the 64-bit value from the stack

;block to output confirmation of input
push qword 0                        ;Push a 64-bit zero onto the stack
mov rax, 2                          ;Set the system call number to 2
mov rdi, confirm                    ;Set the first argument to the address of the confirm message 
movsd xmm0, xmm12                   ;Move the value from xmm12 to xmm0
movsd xmm1, xmm13                   ;Move the value from xmm13 to xmm1 
call printf                         ;Call the printf function
pop rax                             ;Pop the 64-bit value from the stack

;block to calculate hypotenuse
movsd xmm0, xmm12                   ;Move the value from xmm12 to xmm0
mulsd xmm0, xmm0                    ;Square the value in xmm0
movsd xmm1, xmm13                   ;Move the value from xmm13 to xmm1 
mulsd xmm1, xmm1                    ;Square the value in xmm1 
addsd xmm0, xmm1                    ;Add the values in xmm0 and xmm1 
sqrtsd xmm0, xmm0                   ;Take the square root of the value in xmm0

;block to output hypotenuse
push qword 0                        ;Push a 64-bit zero onto the stack
mov rax, 1                          ;Set the system call number to 2
mov rdi, hypotenuse                 ;Set the first argument to the address of the hypotenuse message 
movsd xmm15, xmm0                   ;Move the value from xmm0 to xmm15
call printf                         ;Call the printf function
pop rax                             ;Pop the 64-bit value from the stack

;return the hypotenuse to the driver
movsd xmm0, xmm15                    ;Move the value from xmm15 to xmm0

;===== Restore original values to integer registers ===================================================================
popf                                                        ;Restore rflags
popf
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret

;========== End of program arrays-x86.asm =================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
