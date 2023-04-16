;**********************************************************************************************************************
;Function name: "Get Frequency".  This software function extract the published frequency of processor running the     *
;processor executing the function.  Copyright (C) 2021 Floyd Holliday                                                 *
;                                                                                                                     *
;Get Frequency is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General   *
;Public License, version 3, as published by the Free Software Foundation.                                             *
;Get Frequency is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied  * 
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more *
;details.  You should have received a copy of the GNU Lesser General Public License along with Get Frequency.  If not *
;see <https://www.gnu.org/licenses/>.                                                                                 *
;**********************************************************************************************************************

;Copyright holder information
;Author: Floyd Holliday
;Contact: holliday@fullerton.edu

;Library function information
;Library function name: Get Frequency
;Language: X86-64 with Intel syntax
;Date development began: 2020-Sept-02
;Date of latest update:  2021-Nov-12
;File name getfrequency.asm
;Prototype:  double getfreq()
;Status: Beta, available for public comment.

;Purpose: Extract the CPU maximum published speed from the processor

;Translation: nasm -f elf64 -o freq.o getfrequency.asm
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
mov rdi, int_form           ;Set the first argument to the address of float_form
mov rsi, rsp                ;Set the second argument to the address of the rsp
call scanf                  ;Call the scanf function
mov r12, [rsp]              ;Store the input into xmm12
pop rax                     ;Pop the 0 off the stack

jmp finish

intel:
;Block to get max clock speed
mov rax, 0x0000000000000016
cpuid
mov r12, rbx

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
