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
extern inputArray
extern display_array
extern magnitude 
extern append 
extern printf
extern scanf

global manager

segment .bss
myArray1 resq 35                ;Declare array of 35 8 byte elements
myArray2 resq 35                ;Declare array of 35 8 byte elements
myArray resq 70                 ;Declare array of 70 8 byte elements

segment .data
program db 10, "This program will manage your arrays of 64-bit floats", 10, 0
enter_a db "For array A enter a sequence of 64-bit floats separated by white space. ", 10, 0
enter_b db 10, "For array B enter a sequence of 64-bit floats separated by white space. ", 10, 0
exit db "After the last input press enter followed by Control+D:", 10, 0
recieved_a db 10, "These number were received and placed into array A: ",10, 0
recieved_b db 10, "These number were received and placed into array B: ",10, 0
magnitude_a db 10, "The magnitude of array A is: %lf", 10, 0
magnitude_b db 10, "The magnitude of array B is: %lf", 10, 0
append_str db 10, "Arrays A and B have been appended and given the name A⊕ B.", 10, 0
contains db "A⊕ B contains", 10, 0
magnitude_both db 10, 10, "The magnitude of A⊕ B is: %lf", 10, 0


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

;Print program string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, program                ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Print enter_a string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, enter_a                ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Print exit string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, exit                   ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Call inputArray to get array A
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray1               ;Set the first argument to the address of the array 
mov rsi, 35                     ;Set the second argument to the number of elements in the array
call inputArray                 ;Call the inputArray function 
mov r15, rax                    ;Store the return value in r15
pop rax                         ;Pop the 0 off the stack
pop rax                         ;Pop the 0 off the stack

;Print recieved_a string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, recieved_a             ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Call display_array to print array A
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray1               ;Set the first argument to the address of the array 
mov rsi, r15                    ;Set the second argument to the number of elements in the array 
call display_array              ;Call the display_array function 
pop rax                         ;Pop the 0 off the stack

;Call magnitude to get magnitude of array A
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray1               ;Set the first argument to the address of the array 
mov rsi, r15                    ;Set the second argument to the number of elements in the array 
call magnitude                  ;Call the magnitude function
movsd xmm15, xmm0               ;Move the return value into xmm15
pop rax                         ;Pop the 0 off the stack

;Print magnitude_a string
push qword 0                    ;Push 0 onto the stack
mov rax, 1                      ;Set the system call number to 1
mov rdi, magnitude_a            ;Set the first argument to the address of the string
movsd xmm0, xmm15               ;Move the return value into xmm0
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Print enter_b string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, enter_b                ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Print exit string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, exit                   ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack
pop rax                         ;Pop the 0 off the stack

;Call inputArray to get array B
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray2               ;Set the first argument to the address of the array 
mov rsi, 35                     ;Set the second argument to the number of elements in the array 
call inputArray                 ;Call the inputArray function
mov r14, rax                    ;Store the return value in r14
pop rax                         ;Pop the 0 off the stack
pop rax                         ;Pop the 0 off the stack

;Print recieved_b string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, recieved_b             ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Call display_array to print array B
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray2               ;Set the first argument to the address of the array 
mov rsi, r14                    ;Set the second argument to the number of elements in the array 
call display_array              ;Call the display_array function
pop rax                         ;Pop the 0 off the stack

;Call magnitude to get magnitude of array B
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray2               ;Set the first argument to the address of the array 
mov rsi, r14                    ;Set the second argument to the number of elements in the array 
call magnitude                  ;Call the magnitude function
movsd xmm14, xmm0               ;Move the return value into xmm14 
pop rax                         ;Pop the 0 off the stack

;Print magnitude_b string
push qword 0                    ;Push 0 onto the stack
mov rax, 1                      ;Set the system call number to 1
mov rdi, magnitude_b            ;Set the first argument to the address of the string
movsd xmm0, xmm14               ;Move the return value into xmm0
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Print append_str string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, append_str             ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

;Print contains string
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, contains               ;Set the first argument to the address of the string
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack
pop rax                         ;Pop the 0 off the stack

;Call append_array to append array B to array A
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray1               ;Set the first argument to the address of the array 
mov rsi, myArray2               ;Set the second argument to the address of the array 
mov rdx, myArray                ;Set the third argument to the address of the array 
mov rcx, r15                    ;Set the fourth argument to the number of elements in array A
mov r8, r14                     ;Set the fifth argument to the number of elements in array B
call append                     ;Call the append_array function 
mov r13, rax                    ;Store the return value in r13
pop rax                         ;Pop the 0 off the stack
pop rax                         ;Pop the 0 off the stack

;call display_array to print myArray 
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray                ;Set the first argument to the address of the array 
mov rsi, r13                    ;Set the second argument to the number of elements in the array 
call display_array              ;Call the display_array function
pop rax                         ;Pop the 0 off the stack

;Call magnitude to get magnitude of myArray 
push qword 0                    ;Push 0 onto the stack
mov rax, 0                      ;Set the system call number to 0
mov rdi, myArray                ;Set the first argument to the address of the array 
mov rsi, r13                    ;Set the second argument to the number of elements in the array 
call magnitude                  ;Call the magnitude function
movsd xmm13, xmm0               ;Move the return value into xmm13 
pop rax                         ;Pop the 0 off the stack

;Print magnitude_both string
push qword 0                    ;Push 0 onto the stack
mov rax, 1                      ;Set the system call number to 1
mov rdi, magnitude_both         ;Set the first argument to the address of the string
movsd xmm0, xmm13               ;Move the return value into xmm0
call printf                     ;Call the printf function
pop rax                         ;Pop the 0 off the stack

movsd xmm0, xmm13               ;Move the return value into xmm0

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
