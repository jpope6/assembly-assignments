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
extern getradicand
extern cpuid
extern rdtsc
extern getfreq


global manager


segment .bss
cpu_name resb 100

segment .data
welcome db "Welcome to Square Root Benchmarks by Jared Pope", 10, 10, 0
contact db "For customer service contact me at imthepope@csu.fullerton.edu", 10, 10, 0
cpu_type db "Your CPU is %s", 10, 10, 0
amd_cpu db "I cannot read the max clock speed of AMD CPUs. Please enter your CPUs max clock speed: ", 0
max_clock_speed db 10, "Your max clock speed is %d MHz", 10, 10, 0
square_root db 10, "The square root of %lf is %lf", 10, 10, 0
iterations db "Next enter the number of times iteration should be performed: ", 0
time db 10, "The time on the clock is %llu tics.", 10, 10, 0
in_progress db "The bench mark of the sqrtsd instruction is in progress.", 10, 10, 0
complete db "The time on the clock is %llu tics and the benchmark is completed.", 10, 10, 0
elapsed_time db "The elapsed time was %d tics", 10, 10, 0
time_for_one_sqrt db "The time for one square root computation is %f tics which equals %lf ns.", 10, 10, 0

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
mov r15, 0x80000002         ;Set r15 to the extended CPUID function 0x80000002
mov rax, r15                ;Copy the value of r15 to rax
cpuid                       ;Execute the CPUID instruction with the function number in rax

mov [cpu_name], rax         ;Store the first 4 bytes of the processor name in cpu_name
mov [cpu_name + 4], rbx     ;Store the next 4 bytes of the processor name in cpu_name + 4
mov [cpu_name + 8], rcx     ;Store the next 4 bytes of the processor name in cpu_name + 8
mov [cpu_name + 12], rdx    ;Store the next 4 bytes of the processor name in cpu_name + 12

mov r15, 0x80000003         ;Set r15 to the extended CPUID function 0x80000003
mov rax, r15                ;Copy the value of r15 to rax
cpuid                       ;Execute the CPUID instruction with the function number in rax

mov [cpu_name + 16], rax    ;Store the next 4 bytes of the processor name in cpu_name + 16
mov [cpu_name + 20], rbx    ;Store the next 4 bytes of the processor name in cpu_name + 20
mov [cpu_name + 24], rcx    ;Store the next 4 bytes of the processor name in cpu_name + 24
mov [cpu_name + 28], rdx    ;Store the next 4 bytes of the processor name in cpu_name + 28

mov r15, 0x80000004         ;Set r15 to the extended CPUID function 0x80000004
mov rax, r15                ;Copy the value of r15 to rax
cpuid                       ;Execute the CPUID instruction with the function number in rax

mov [cpu_name + 32], rax    ;Store the next 4 bytes of the processor name in cpu_name + 32
mov [cpu_name + 36], rbx    ;Store the next 4 bytes of the processor name in cpu_name + 36
mov [cpu_name + 40], rcx    ;Store the next 4 bytes of the processor name in cpu_name + 40
mov [cpu_name + 44], rdx    ;Store the next 4 bytes of the processor name in cpu_name + 44


;Print CPU name
push qword 0                ;Push a 0 onto the stack             
mov rax, 0                  ;Set the system call number to 0
mov rdi, cpu_type           ;Set the first argument to the address of cpu_type
mov rsi, cpu_name           ;Set the second argument to the address of cpu_name
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

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

;Set the AMD variable to be true
mov r10, 1                  ;1 = cpu is AMD

jmp intel_finish

not_amd:

;Set the amd variable to be false
mov r10, 0                  ;0 = intel

intel_finish:

;Block to call the getfreq function
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, r10                ;Set the first parameter to our AMD/Intel variable
call getfreq                ;Call the getfreq function
mov r12, rax                ;Store the clock frequency in r12
pop rax                     ;Pop the 0 off the stack

;Black to print the max clock speed of the cpu
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, max_clock_speed    ;Set the first argument to the address of max_clock_speed
mov rsi, r12                ;Set the second argument to the clock frequency
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;Block to call getradicand
push qword 0                ;Push a 0 onto the stack       
mov rax, 0                  ;Set the system call number to 0
call getradicand            ;Call the get radicand function
movsd xmm12, xmm0           ;Store the radicand in xmm12
pop rax                     ;Pop the 0 off the stack

;Take the square root of the input number
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
movsd xmm0, xmm12           ;Move the radicand value from xmm12 to xmm0
sqrtsd xmm0, xmm0           ;Compute the square root of the value in xmm0
movsd xmm11, xmm0           ;Store the computed square root in xmm11
pop rax                     ;Pop the 0 off the stack

;Print "The square root of ... is ..."
push qword 0                ;Push a 0 onto the stack
mov rax, 2                  ;Set the number of floating-point parameters for printf
mov rdi, square_root        ;Set the format string for printf
movsd xmm0, xmm12           ;Move the radicand value to xmm0
movsd xmm1, xmm11           ;Move the computed square root value to xmm1
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

;Block to output "Next enter the number of times iteration should be performed:"
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, iterations         ;Set the message for printf
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

;Block to read in the amount of times to iterate
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, int_form           ;Set the format string for scanf
mov rsi, rsp                ;Set the address of the integer value to read
call scanf                  ;Call scanf to read the integer value
mov r15, [rsp]              ;Store the read integer value in r15
pop rax                     ;Pop the 0 off the stack

;Block to get the time in tics at start
push qword 0                ;Push a 0 onto the stack
xor rax, rax                ;Zero out rax
xor rdx, rdx                ;Zero out rdx
cpuid                       ;Execute CPUID to serialize instructions
rdtsc                       ;Read the Time Stamp Counter
shl rdx, 32                 ;Shift the high-order 32 bits of the TSC to the left
add rdx, rax                ;Combine the high and low-order 32 bits of the TSC
mov r14, rdx                ;Store the TSC value in r14
pop rax                     ;Pop the 0 off the stack

;Print "The time on the clock is..."
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, time               ;Set the message for printf
mov rsi, r14                ;Move the TSC value to rsi
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

;Print "The benchmark of the sqrtsd instruction is in progress"
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, in_progress        ;Set the message for printf
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

;Block to loop sqrt calculation
mov r13, 0                  ;Set the counter to 0
loop:
    cmp r13, r15            ;Compare the counter to the number of iterations
    je endloop              ;If it is equal, exit the loop

    mov rax, 0
    movsd xmm0, xmm12       ;Move the radicand value from xmm12 to xmm0
    sqrtsd xmm0, xmm0       ;Compute the square root of the value in xmm0

    inc r13                 ;Increment the counter
    jmp loop                ;Jump back to the loop

endloop:

;Block to get the time in tics after benchmark
push qword 0                ;Push a 0 onto the stack
xor rax, rax                ;Zero out rax
xor rdx, rdx                ;Zero out rdx
cpuid                       ;Execute CPUID to serialize instructions
rdtsc                       ;Read the Time Stamp Counter
shl rdx, 32                 ;Shift the high-order 32 bits of the TSC to the left
add rdx, rax                ;Combine the high and low-order 32 bits of the TSC
mov r13, rdx                ;Store the TSC value in r13
pop rax                     ;Pop the 0 off the stack

;Print "The time on the clock is ... tics and the benchmark is completed."
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, complete           ;Set the message for printf
mov rsi, r13                ;Move the TSC value to rsi
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

;Subtract the start tics and end tics to get the elapsed tics
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
cvtsi2sd xmm0, r13          ;Convert the end TSC value to a double and store in xmm0
cvtsi2sd xmm1, r14          ;Convert the start TSC value to a double and store in xmm1
subsd xmm0, xmm1            ;Subtract the start TSC value from the end TSC value
movsd xmm15, xmm0           ;Store the elapsed TSC value in xmm15
pop rax                     ;Pop the 0 off the stack

;Print tics
push qword 0                ;Push a 0 onto the stack
mov rax, 1                  ;Set the number of floating-point parameters for printf
mov rdi, elapsed_time       ;Set the format string for printf
movsd xmm0, xmm15           ;Move the elapsed TSC value to xmm0
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

;Calculate how many tics per square root computation
push qword 0                ;Push a 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
movsd xmm0, xmm15           ;Move the elapsed TSC value to xmm0
cvtsi2sd xmm1, r15          ;Convert the number of iterations to a double and store in xmm1
divsd xmm0, xmm1            ;Divide the elapsed TSC value by the number of iterations
movsd xmm14, xmm0           ;Store the tics per square root computation in xmm14
pop rax                     ;Pop the 0 off the stack

;Calculate nanoseconds
push qword 0                ;Push a 0 onto the stack
movsd xmm0, xmm14           ;Move the tics per square root computation to xmm0
mov rax, r12                ;Move the clock speed in MHz into rax
cvtsi2sd xmm1, rax          ;Convert the clock speed to a double and store in xmm1
mov rax, 0xF4240            ;Load 1,000,000 (10^6) into rax
cvtsi2sd xmm2, rax          ;Convert 1,000,000 from integer to double and store in xmm2
mulsd xmm1, xmm2            ;Multiply MHz by 1,000,000 to get to Hz
divsd xmm0, xmm1            ;Divide tics per square root computation by Hz
mov rax, 0x3B9ACA00         ;Load 1,000,000,000 (10^9) into rax
cvtsi2sd xmm3, rax          ;Convert 1,000,000,000 from integer to double and store in xmm3
mulsd xmm0, xmm3            ;Multiply the result by 1,000,000,000 to get nanoseconds
movsd xmm15, xmm0           ;Store the nanoseconds per square root computation in xmm15
pop rax                     ;Pop the 0 off the stack

;Print "The time for one square root computation is..."
push qword 0                ;Push a 0 onto the stack
mov rax, 2                  ;Set the number of floating-point parameters for printf
mov rdi, time_for_one_sqrt  ;Set the format string for printf
movsd xmm0, xmm14           ;Move the tics per square root computation to xmm0
movsd xmm1, xmm15           ;Move the nanoseconds per square root computation to xmm1
call printf                 ;Call printf to print the message
pop rax                     ;Pop the 0 off the stack

pop rax
movsd xmm0, xmm15           ;Return the amount of nanoseconds

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
