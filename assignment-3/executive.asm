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
extern fill_random_array
extern show_array
extern quick_sort
extern printf
extern scanf
extern stdin
extern fgets
extern strlen

global executive

INPUT_LEN equ 256

segment .bss
string_name resb INPUT_LEN
string_title resb INPUT_LEN
myArray1 resq 100

segment .data
name db "Please enter your name: ", 0
title db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): ", 0
greeting db "Nice to meet you %s %s", 10, 0
generate db "This program will generate 64-bit IEEE float numbers.", 10, 0
numbers db "How many numbers do you want? Today’s limit is 100 per customer. ", 0
stored db "Your numbers have been stored in an array.  Here is that array.", 10, 10, 0
sorted db 10, "The array is now being sorted.", 10, 10, 0
updated db "Here is the updated array.", 10, 10, 0
normalized db 10, "The random numbers will be normalized. Here is the normalized array", 10, 10, 0
goodbye db 10, "Good bye %s. You are welcome any time.", 10, 10, 0

stringformat db "%s", 0             ;General string format
floatformat db "%lf", 0
intformat db "%d", 0

segment .text
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

push qword 0

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

;Print "Please enter your title: "
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, title              ;Set the first argument to the address of title
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Prompt for title
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, string_title       ;Set the first argument to the address of string_title
mov rsi, INPUT_LEN          ;Set the second argument to max input length                 
mov rdx, [stdin]            ;Store the input into rdx
call fgets                  ;Call the C function to get a line of text and stop when NULL is encountered or 31 chars have been stored.
pop rax                     ;Pop the 0 off the stack

;Block to remove the \n from string_title
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, string_title       ;Set the first argument to the address of string_title
call strlen                 ;Call external function strlen, which returns the length of the string leading up to '\0'
sub rax, 1                  ;The length is stored in rax. Here we subtract 1 from rax to obtain the location of '\n'
mov byte [string_title + rax], 0 ;Replace the byte where '\n' exits with '\0'
pop rax                     ;Pop the 0 off the stack

;Print "Nice to meet you..."
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, greeting           ;Set the first argument to the address of greeting
mov rsi, string_title       ;Set the second argument to the address of string_title
mov rdx, string_name        ;Set the third argument to the address of string_name
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Print "The program will generate 64-bit IEEE float numbers"
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, generate           ;Set the first argument to the address of generate
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Print "How many numbers do you want? Todays limit is 100 per customer"
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, numbers            ;Set the first argument to the address of numbers
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to prompt user for how many numbers they want
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, intformat        ;Set the first argument to floatformat
mov rsi, rsp                
call scanf
mov r15, [rsp]
pop rax

;Print "Your numbers have been stored in an array.  Here is that array."
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, stored             ;Set the first argument to the address of stored
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Prepare to call fill_random_array
push qword 0
mov rax, 0
mov rdi, myArray1
mov rsi, r15
call fill_random_array
mov r14, rax
pop rax

;Prepare to call show_array
push qword 0
mov rax, 0
mov rdi, myArray1
mov rsi, r14
call show_array
pop rax

;Print "The array is now being sorted."
push qword 0
mov rax, 0
mov rdi, sorted
call printf
pop rax

;Print "Here is the updated array."
push qword 0
mov rax, 0
mov rdi, updated
call printf
pop rax

;Prepare to call quick_sort
push qword 0
mov rax, 0
mov rdi, myArray1
mov rsi, r14
call quick_sort
mov r13, rax
pop rax

;Prepare to call show_array
push qword 0
mov rax, 0
mov rdi, r13
mov rsi, r14
call show_array
pop rax

;Print "The random numbers will be normalized. Here is the normalized array"
push qword 0
mov rax, 0
mov rdi, normalized
call printf
pop rax

;Block to normalize the array
push qword 0
mov rax, 0

mov r12, 0
beginLoop:
    cmp r12, r14
    je endLoop

    mov rbx, [r13 + 8 * r12]
    shl rbx, 12
    shr rbx, 12
    mov r8, 0x3FF
    shl r8, 52
    or rbx, r8
    mov [r13 + 8 * r12], rbx

    inc r12

    jmp beginLoop

endLoop:
pop rax

;Prepare to call quick_sort
push qword 0
mov rax, 0
mov rdi, r13
mov rsi, r14
call quick_sort
mov r10, rax
pop rax

;Prepare to call show_array
push qword 0
mov rax, 0
mov rdi, r10
mov rsi, r14
call show_array
pop rax

;Print "Good bye <name>.  You are welcome any time."
push qword 0
mov rax, 0
mov rdi, goodbye
mov rsi, string_title
call printf
pop rax

;Block to remove the \n from string_name
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, string_name       ;Set the first argument to the address of string_title
call strlen                 ;Call external function strlen, which returns the length of the string leading up to '\0'
sub rax, 1                  ;The length is stored in rax. Here we subtract 1 from rax to obtain the location of '\n'
mov byte [string_name + rax], 0 ;Replace the byte where '\n' exits with '\0'
pop rax                     ;Pop the 0 off the stack


pop rax
mov rax, string_name

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
