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
extern cpuid
extern rdtsc


global manager


segment .bss
cpu_name resb 100

segment .data
welcome db "Welcome to Square Root Benchmarks by Jared Pope", 10, 10, 0
contact db "For customer service contact me at imthepope@csu.fullerton.edu", 10, 10, 0
cpu_type db "Your CPU is %s", 10, 10, 0
max_clock_speed db "Your max clock speed is %d GHz", 10, 10, 0
square_root db 10, "The square root of %lf is %lf", 10, 10, 0
iterations db "Next enter the number of times iteration should be performed: ", 0
time db 10, "The time on the clock is %llu tics.", 10, 10, 0
in_progress db "The bench mark of the sqrtsd instruction is in progress.", 10, 10, 0
complete db "The time on the clock is %llu tics and the benchmark is completed.", 10, 10, 0
elapsed_time db "The elapsed time was %d tics", 10, 10, 0
time_for_one_sqrt db "The time for one square root computation is 27.36841 tics which equals 9.28441 ns.", 10, 10, 0

float_form db "%lf", 0
int_form db "%d", 0


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

;Block to get the name of the CPU
mov r15, 0x80000002
mov rax, r15
cpuid

mov [cpu_name], rax
mov [cpu_name + 4], rbx
mov [cpu_name + 8], rcx
mov [cpu_name + 12], rdx

mov r15, 0x80000003
mov rax, r15
cpuid

mov [cpu_name + 16], rax
mov [cpu_name + 20], rbx
mov [cpu_name + 24], rcx
mov [cpu_name + 28], rdx

mov r15, 0x80000004
mov rax, r15
cpuid

mov [cpu_name + 32], rax
mov [cpu_name + 36], rbx
mov [cpu_name + 40], rcx
mov [cpu_name + 44], rdx

;Print CPU name
push qword 0
mov rax, 0
mov rdi, cpu_type
mov rsi, cpu_name
call printf
pop rax

;Block to get max clock speed
mov rax, 0x0000000000000016
cpuid
mov rdx, rbx

push qword 0
mov rax, 0
mov rdi, max_clock_speed
mov rsi, rdx
call printf
pop rax

;Block to call getradicand
push qword 0
mov rax, 0
call getradicand
movsd xmm12, xmm0
pop rax

;Take the square root of the input number
push qword 0
mov rax, 0
movsd xmm0, xmm12
sqrtsd xmm0, xmm0
movsd xmm11, xmm0
pop rax

;Print "The square root of ... is ..."
push qword 0
mov rax, 2
mov rdi, square_root
movsd xmm0, xmm12
movsd xmm1, xmm11
call printf
pop rax

;Block to output "Next enter the number of times iteration should be performed:"
push qword 0
mov rax, 0
mov rdi, iterations
call printf
pop rax

;Block to read in the amount of times to iterate
push qword 0
mov rax, 0
mov rdi, int_form
mov rsi, rsp
call scanf
mov r15, [rsp]
pop rax

;Block to get the time in tics at start
push qword 0
xor rax, rax
xor rdx, rdx
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r14, rdx
pop rax

;Print "The time on the clock is..."
push qword 0
mov rax, 0
mov rdi, time
mov rsi, r14
call printf
pop rax

;Print "The bench mark of the sqrtsd instruction is in progress"
push qword 0
mov rax, 0
mov rdi, in_progress
call printf
pop rax

;Block to loop sqrt calculation
mov r13, 0                  ;Set the counter to 0
loop:
    cmp r13, r15            ;Compare the counter to the amount of times we want to loop
    je endloop              ;If it is equal, exit the loop

    mov rax, 0
    movsd xmm0, xmm12
    sqrtsd xmm0, xmm0

    inc r13
    jmp loop

endloop:

;Block to get the time in tics after benchmark
push qword 0
xor rax, rax
xor rdx, rdx
cpuid
rdtsc
shl rdx, 32
add rdx, rax
mov r13, rdx
pop rax

;Print "The time on the clock is ... tics and the benchmark is completed."
push qword 0
mov rax, 0
mov rdi, complete
mov rsi, r13
call printf
pop rax

;Subtract the start tics and end tics to get the elapsed tics
push qword 0
mov rax, 0
sub r13, r14
pop rax

;Print tics
push qword 0
mov rax, 0
mov rdi, elapsed_time
mov rsi, r13
call printf
pop rax

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
