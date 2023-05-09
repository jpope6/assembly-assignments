;****************************************************************************************************************************
;Program name: "Benchmark".                                                                                                 *
; This Program will benchmark the performance of the square root function in SSE. It will detect what CPU the user is on.   *
;   If the user is on an Intel CPU, it will detect your max clock speed. If the user is on an AMD CPU, it will ask the      *
;   user for their max clock speed. It will ask for a radicand and how many iterations the user wants to run the square     *
;   root function. It will find the amount of tics it took to run each square root function and calculate how many          *
;   nonseconds it took to run each square root function.                                                                    *
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
;  Program name: Benchmark
;  Programming languages: Assembly, C++, bash
;  Date program began: 2023 April 3
;  Date of last update: 2023 April 16
;  Date of reorganization of comments: 2023 April 16
;  Files in this program: manager.asm, getradicand.asm, get_clock_freq.asm, main.cpp, r.sh
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;
;This file
;   File name: manager.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;   Link: g++ -m64 -fno-pie -no-pie -o a.out getradicand.o get_clock_freq.o manager.o main.o -fno-pie -no-pie
;   Purpose: This is the central module that will direct calls to different functions including get_clock_freq and
;               getradicand. It will detect the name of of your CPU. It will calculate how many tics the program took
;               to run and will calculate tics per iteration and nanoseconds per iteration.
;=============================================================================================================================


;Decleration
extern printf
extern scanf
extern cpuid
extern rdtsc
extern getfreq


global birthday


segment .bss
cpu_name resb 100

segment .data
greetings db 10, "We will send a birthday greeting to Chris", 10, 0
cards db 10, "How many birthday cards do you wish to send? ", 0
delay db 10, "What is the delay time (ms) between sending greetings? ", 0
max_clock_speed db 10, "Your max clock speed is %d MHz", 10, 0
amd_cpu db 10, "I cannot read the max clock speed of AMD CPUs. Please enter your CPUs max clock speed: ", 0
start_tics db 10, "Thank you.  The time on the clock is now %llu tics.", 10, 10, 0
hap_bir db "Happy Birthday, Chris", 10, 0
time db 10, "The time on the clock is now %llu tics", 10, 0
elapsed_time db 10, "The elapsed time was %d tics", 10, 0
returned db 10, "The elapsed time will be returned to the caller.", 10, 0

float_form db "%lf", 0
int_form db "%d", 0

segment .text
birthday:

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

;Print the greetings message
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, greetings          ;Set the first argument to the address of greetings
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Print the cards message
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, cards              ;Set the first argument to the address of cards
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to read in the amount of times to say happy brithday
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, int_form           ;Set the format string for scanf
mov rsi, rsp                ;Set the address of the integer value to read
call scanf                  ;Call scanf to read the integer value
mov r15, [rsp]              ;Store the read integer value in r15
pop rax                     ;Pop the 0 off the stack

;Print the delay message
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, delay              ;Set the first argument to the address of delay
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to read in the amount of time for delay
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, int_form           ;Set the format string for scanf
mov rsi, rsp                ;Set the address of the integer value to read
call scanf                  ;Call scanf to read the integer value
mov r14, [rsp]              ;Store the read integer value in r14
pop rax                     ;Pop the 0 off the stack

;Block to get the name of the CPU
mov r13, 0x80000002         ;Set r15 to the extended CPUID function 0x80000002
mov rax, r13                ;Copy the value of r15 to rax
cpuid                       ;Execute the CPUID instruction with the function number in rax

mov [cpu_name], rax         ;Store the first 4 bytes of the processor name in cpu_name
mov [cpu_name + 4], rbx     ;Store the next 4 bytes of the processor name in cpu_name + 4
mov [cpu_name + 8], rcx     ;Store the next 4 bytes of the processor name in cpu_name + 8
mov [cpu_name + 12], rdx    ;Store the next 4 bytes of the processor name in cpu_name + 12

mov r13, 0x80000003         ;Set r15 to the extended CPUID function 0x80000003
mov rax, r13                ;Copy the value of r15 to rax
cpuid                       ;Execute the CPUID instruction with the function number in rax

mov [cpu_name + 16], rax    ;Store the next 4 bytes of the processor name in cpu_name + 16
mov [cpu_name + 20], rbx    ;Store the next 4 bytes of the processor name in cpu_name + 20
mov [cpu_name + 24], rcx    ;Store the next 4 bytes of the processor name in cpu_name + 24
mov [cpu_name + 28], rdx    ;Store the next 4 bytes of the processor name in cpu_name + 28

mov r13, 0x80000004         ;Set r15 to the extended CPUID function 0x80000004
mov rax, r13                ;Copy the value of r15 to rax
cpuid                       ;Execute the CPUID instruction with the function number in rax

mov [cpu_name + 32], rax    ;Store the next 4 bytes of the processor name in cpu_name + 32
mov [cpu_name + 36], rbx    ;Store the next 4 bytes of the processor name in cpu_name + 36
mov [cpu_name + 40], rcx    ;Store the next 4 bytes of the processor name in cpu_name + 40
mov [cpu_name + 44], rdx    ;Store the next 4 bytes of the processor name in cpu_name + 44

;Block to check if cpu_name starts with AMD
mov al, byte [cpu_name]     ;Load the first character of the string into the AL register
cmp al, 'A'                 ;Compare the first character with 'A'
jne not_amd
mov al, byte [cpu_name + 1] ;Load the second charater of the string into the AL register
cmp al, 'M'                 ;Compare the second character with 'M'
jne not_amd
mov al, byte [cpu_name + 2] ;Load the third character of the string into the AL register
cmp al, 'D'                 ;Compare the third character with 'D'
jne not_amd

;Print the not_amd prompt
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, amd_cpu            ;Set the first argument to the address of amd_cpu
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to get clock speed input
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, int_form           ;Set the first argument to the address of int_form
mov rsi, rsp                ;Set the second argument to the address of the rsp
call scanf                  ;Call the scanf function
mov r13, [rsp]              ;Store the input into r13
pop rax                     ;Pop the 0 off the stack

jmp finish

not_amd:

;Block to get cpu frequency
push qword 0                ;Push a 0 onto the stack
mov rax, 0x0000000000000016 ;Load CPUID lead 0x16 into rax
cpuid                       ;Call the cpuid function
mov r13, rbx                ;Store the max freq in r13
pop rax                     ;Pop the 0 off the stack

finish:

;Block to print the max clock speed of the cpu
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, max_clock_speed    ;Set the first argument to the address of max_clock_speed
mov rsi, r13                ;Set the second argument to the clock frequency
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to get the time in tics at start
push qword 0                ;Push a 0 onto the stack
xor rax, rax                ;Zero out rax
xor rdx, rdx                ;Zero out rdx
cpuid                       ;Execute CPUID to serialize instructions
rdtsc                       ;Read the Time Stamp Counter
shl rdx, 32                 ;Shift the high-order 32 bits of the TSC to the left
add rdx, rax                ;Combine the high and low-order 32 bits of the TSC
mov r12, rdx                ;Store the TSC value in r14
pop rax                     ;Pop the 0 off the stack

;Print "The time on the clock is..."
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, start_tics         ;Set the message for printf
mov rsi, r12                ;Move the TSC value to rsi
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

;Block to print Happy Birthday Chris as many times as wanted
mov r14, 0                  ;Store the counter in 0
loop:
    cmp r14, r15            ;Compare the counter to the amount entered
    je endloop

    push qword 0            ;Push a 0 onto the stack
    mov rax, 0              ;Set the system call number to 0
    mov rdi, hap_bir        ;Set the message for printf
    call printf             ;Call printf to print the message
    pop rax                 ;Pop the 0 off the stack

    inc r14
    jmp loop

endloop:

;Block to get the time in tics at end
push qword 0                ;Push a 0 onto the stack
xor rax, rax                ;Zero out rax
xor rdx, rdx                ;Zero out rdx
cpuid                       ;Execute CPUID to serialize instructions
rdtsc                       ;Read the Time Stamp Counter
shl rdx, 32                 ;Shift the high-order 32 bits of the TSC to the left
add rdx, rax                ;Combine the high and low-order 32 bits of the TSC
mov r11, rdx                ;Store the TSC value in r11
pop rax                     ;Pop the 0 off the stack

;Print "The time on the clock is now"
push qword 0            ;Push a 0 onto the stack
mov rax, 0              ;Set the system call number to 0
mov rdi, time           ;Set the message for printf
call printf             ;Call printf to print the message
pop rax                 ;Pop the 0 off the stack

;Subtract the start tics and end tics to get the elapsed tics
push qword 0            ;Push a 0 onto the stack
mov rax, 0              ;Set the system call number to 0
cvtsi2sd xmm0, r12      ;Convert the end TSC value to a double and store in xmm0
cvtsi2sd xmm1, r11      ;Convert the start TSC value to a double and store in xmm1
subsd xmm0, xmm1        ;Subtract the start TSC value from the end TSC value
movsd xmm15, xmm0       ;Store the elapsed TSC value in xmm15
pop rax                 ;Pop the 0 off the stack

;Print elapsed tics
push qword 0            ;Push a 0 onto the stack
mov rax, 1              ;Set the number of floating-point parameters for printf
mov rdi, elapsed_time   ;Set the format string for printf
movsd xmm0, xmm15       ;Move the elapsed TSC value to xmm0
call printf             ;Call printf to print the message
movsd xmm15, xmm0
pop rax                 ;Pop the 0 off the stack

;Print "The elapsed time will be returned to the caller."
push qword 0            ;Push a 0 onto the stack
mov rax, 0              ;Set the system call number to 0
mov rdi, time           ;Set the message for printf
call printf             ;Call printf to print the message
pop rax                 ;Pop the 0 off the stack

pop rax
movsd xmm0, xmm15       ;Return the amount of elapsed tics to main

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
