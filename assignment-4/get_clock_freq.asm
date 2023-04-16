;**********************************************************************************************************************
;Function name: "Get Frequency". This Program will ask for your clock freq if you are on on AMD CPU or it will        *
;                   detect your max clock freq if you are on an Intel cpu.                                            *
; Copyright (C) 2023 Jared Pope                                                                                       *
;                                                                                                                     *
;Get Frequency is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General   *
;Public License, version 3, as published by the Free Software Foundation.                                             *
;Get Frequency is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied  * 
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more *
;details.  You should have received a copy of the GNU Lesser General Public License along with Get Frequency.  If not *
;see <https://www.gnu.org/licenses/>.                                                                                 *
;**********************************************************************************************************************
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
;   File name: get_clock_freq.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l get_clock_freq.lis -o get_clock_freq.o get_clock_freq.asm
;   Link: g++ -m64 -fno-pie -no-pie -o a.out getradicand.o get_clock_freq.o manager.o main.o -fno-pie -no-pie
;   Purpose: This is the get_clock_freq module. This module will get the max clock frequency for the cpu that the 
;               user is on and will return it to the manager module.
;======================================================================================================================

;Declaration area
global getfreq
extern cpuid
extern scanf

segment .data
int_form db "%d", 0

segment .bss
;Empty

segment .text
getfreq:

;Prolog: Back up the GPRs
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf

push qword 0

mov r15, rdi                ;AMD vs Intel Variable

cmp r15, 0                  ;If variable is 0, then cpu is Intel
je intel


;Block to get clock speed input
push qword 0                ;Push 0 onto the stack
mov rax, 0                  ;Set the system call number to 0
mov rdi, int_form           ;Set the first argument to the address of int_form
mov rsi, rsp                ;Set the second argument to the address of the rsp
call scanf                  ;Call the scanf function
mov r12, [rsp]              ;Store the input into r12
pop rax                     ;Pop the 0 off the stack

jmp finish

intel:
;Block to get max clock speed
mov rax, 0x0000000000000016 ;Load CPUID lead 0x16 into rax
cpuid                       ;Call the cpuid function
mov r12, rbx                ;Store the max freq in r12

finish:
pop rax
mov rax, r12                ;Return the max clock speed

;Epilogue: restore data to the values held before this function was called.
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp               ;Restore the base pointer of the stack frame of the caller.
ret

ret
