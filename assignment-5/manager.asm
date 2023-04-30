;****************************************************************************************************************************
;Program name: "Sine Benchmark".                                                                                            *
;   This program will Calculate sine using the MacLaurin Taylor series formula. This program will validate the angle
;       that the user inputs to ensure it is a float value. This program will also run a benchmark for calculating
;       sine using the MacLaurin Taylor series vs using the sin function in the math.h file.
; Copyright (C) 2023 Jared Pope.                                                                                            *
;                                                                                                                           *
;This file is part of the software program "Sine Benchmark".                                                            *
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
;  Program name: Sine Benchmark
;  Programming languages: Assembly, C, C++, bash
;  Date program began: 2023 April 30
;  Date of last update: 2023 April 17
;  Date of reorganization of comments: 2023 April 30
;  Files in this program: isFloat.cpp, driver.c, manager.asm, r.sh 
;  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
;
;This file
;   File name: manager.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Compile: gcc -c -m64 -Wall -std=c17 -o driver.o driver.c -fno-pie -no-pie
;   Link: g++ -m64 -std=c++17 -o a.out -fno-pie -no-pie isFloat.o manager.o driver.o
;   Purpose: This is the central module that will validate the angle that the user input. It will calulate how many tics
;               it took to calculate the sin using the MacLaurin Taylor Series. It will also calculate how many tics it
;               took to calculate tp calculate sin using the math.h sin function. This module will return the amount
;               of tics it took to calculate using the MacLaurin Taylor Series.
;========================================================================================================


;Decleration
extern printf
extern scanf
extern fgets
extern stdin
extern strlen
extern cpuid
extern rdtsc
extern isFloat
extern atof
extern sin

global manager

INPUT_LEN equ 256

segment .bss
string_name resb INPUT_LEN

segment .data

program db 10, "This program Sine Function Benchmark is maintained by Jared Pope", 10, 0
name db 10, "Please enter your name: ", 0
angle_number db 10, "It is nice to meet you %s.  Please enter an angle number in degrees: ", 0
num_terms db 10, "Thank you.  Please enter the number of terms in a Taylor series to be computed: ", 0
compute db 10, "Thank you.  The Taylor series will be used to compute the sine of your angle.", 10, 10, 0
answer db "The computation completed in %llu tics and the computed value is %lf", 10, 10, 0
sin_math_msg db "Next the sine of %.9lf will be computed by the function ",34,"sin",34," in the library <math.h>. ", 10, 10, 0
sin_tics_msg db "The computation completed in %llu tics and gave the value %.9lf ", 10, 10, 0

invalid_msg db "Invalid. Please try again: ", 0

floatformat db "%lf", 0
intformat db "%d", 0
stringformat db "%s", 0

one_eighty dq 180.0

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

return:

;Block to prompt user for the angle number
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, stringformat       ;Set the first argument to stringformat
mov rsi, rsp                ;Set the second argument to rsp
call scanf                  ;Call the scanf function

;Validate first string
mov rax, 0                  ;Set the sytem call number to 0
mov rdi, rsp                ;Set the first argument to the address of the rsp
call isFloat                ;Call the is float function

;Validate first string value
cmp rax, 0                  ;Check if isfloat return a 0
je invalid                  ;If it is a 0, jump to invalid

;Block to convert from string to float
mov rax, 0                  ;Set the system call number to 0   
mov rdi, rsp                ;Set the first argument to the address of the rsp
call atof                   ;Call the atof function
movsd xmm15, xmm0           ;Store the float in xmm15
pop rax                     ;Pop the 0 off the stack

jmp continue

invalid:
;A invalid message displays if the user did not input a valid float value
mov rax, 0                  ;Set the system call number to 0
mov rdi, invalid_msg        ;Set the first argument to the address of invalid_msg
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack
jmp return   

continue:

;Convert degrees into radians
mov rax, 0x400921FB54442D18 ;Load pi into rax
push rax
movsd xmm14, [rsp]          ;Store pi in xmm14
pop rax

movsd xmm13, [one_eighty]   ;Store 180.0 in xmm13

;pi/180
divsd xmm14, xmm13

;pi/180 * degrees = radians
mulsd xmm15, xmm14

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

;Block to get the time in tics at start
push qword 0                ;Push a 0 onto the stack
xor rax, rax                ;zero out the rax register
cpuid                       ;cpu identification
rdtsc                   
shl rdx, 32                 ;Shift left 32
add rax, rdx
mov r14, rax                ;Store the tics before in r14
pop rax                     ;Pop the 0 off the stack


;Block to calculate the Sine Taylor series using the T_n term
movsd xmm14, xmm15          ;First term is x

;Using these numbers as a float in our equation (2.0, 3.0, -1.0)
mov rax, 2
cvtsi2sd xmm13, rax

mov rax, 3
cvtsi2sd xmm12, rax

mov rax, -1
cvtsi2sd xmm5, rax

xorpd xmm10, xmm10

mov r13, 0 ;loop counter
mov rax, r13
cvtsi2sd xmm11, rax

startLoop:
;Condition to check if the loop reaches the number of terms in a Taylor series
cmp r13, r15
je endLoop

;Add the current term of sequence
addsd xmm10, xmm14

; Then, compute the next term of the sequence (place into xmm14)
; 2n+3 - xmm13 * xmm11 + xmm12
; creating temporary register for calculations xmm9
;(2n + 3)
movsd xmm9, xmm13
mulsd xmm9, xmm11
addsd xmm9, xmm12

; 2n+2 - xmm13 * xmm11 + xmm13
; creating temporary register for calculations xmm8
;(2n + 2)
movsd xmm8, xmm13
mulsd xmm8, xmm11
addsd xmm8, xmm13

;(2n + 3)*(2n + 2)
mulsd xmm8, xmm9

;X^2
movsd xmm7, xmm15
mulsd xmm7, xmm7

;X^2
;--------
;(2n + 3)*(2n+2)
divsd xmm7, xmm8

;multiply -1
mulsd xmm7, xmm5

mulsd xmm14, xmm7
inc r13
cvtsi2sd xmm11, r13
jmp startLoop

endLoop:

movsd xmm0, xmm10


;measure the tics after the benchmark test is ran
xor rax, rax                ;Zero out the rax register
cpuid                       ;Cpu identification 
rdtsc               
shl rdx, 32
add rax, rdx
mov r12, rax                ;Store the tics after into the r12 register

sub r12, r14                ;Subtract the tics (after - before) to get elapsed time

;Print "The computation completed in %llu tics and the computed value is %lf"
push qword 0                ;Push a 0 onto the stack
mov rax, 1                  ;Set the system call number to 1
mov rdi, answer             ;Set the first argument to the address of answer
mov rsi, r12                ;Set the second argument to the address of r12
movsd xmm0, xmm10           ;Set the thirs argument to the address of xmm10
call printf                 ;Call the printf function
pop rax                     ;Pop the 0 off the stack

;===== calculation for math.h sin and elapsed tics =====

movsd xmm13, [one_eighty]

;Pi is used to convert the angle input into radians
mov rax, 0x400921FB54442D18
push rax
movsd xmm14, [rsp]
pop rax

;180 * radians
mulsd xmm15, xmm13

;answer / pi 
divsd xmm15, xmm14

;Message showing the user's input and preparing it for computation 
push qword 0
mov rax, 1
mov rdi, sin_math_msg       ;"Next the sine of %.9lf will be computed by the function ",34,"sin",34," in the library <math.h>. "
movsd xmm0, xmm15
call printf
pop rax

;convert back to radians for calculations
;(pi/180)
divsd xmm14, xmm13

;(pi / 180) * degrees = radians 
mulsd xmm15, xmm14          ;The value in radians is backed up and stored in xmm15

;get tics before 
;Here is where the tics is measured and counted before the benchmark test is run
xor rax, rax                ;zero out the rax register
cpuid                       ;cpu identification
rdtsc                   
shl rdx, 32
add rax, rdx
mov r14, rax                ;stores the tics before in r14


;Math.h sine function "sin" is called 
push qword 0
mov rax, 2
movsd xmm0, xmm15
call sin
movsd xmm13, xmm0
pop rax

;measure the tics after the benchmark test is ran
xor rax, rax                ;zero out the rax register
cpuid                       ;cpu identification 
rdtsc               
shl rdx, 32
add rax, rdx
mov r11, rax                ;store the tics after into the r12 register

sub r11, r14                ;subtract the tics (after - before) to get elapsed time

;The elapsed tics and sine value is displayed 
push qword 0
mov rax, 1
mov rdi, sin_tics_msg       ;"The computation completed in %llu tics and gave the value %.9lf "
mov rsi, r11
movsd xmm0, xmm13
call printf
pop rax

mov rax, r12                ;Return the tic count to the driver

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
