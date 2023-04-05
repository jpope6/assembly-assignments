# Square Root Benchmark
A benchmarking tool for comparing the performance of the square root instruction in SSE and the square root program in the standard C library.  
## Introduction
Benchmarking is the process of measuring the performance of software or hardware components. It does not focus on uncovering bugs but rather seeks to measure the use of time and space by a program or processor. This project aims to create a benchmarking tool that measures the performance of the square root instruction in SSE and the square root program in the standard C library.
## Abstract View
The goal is to create a program with modules in the three languages of this course that will benchmark the performance of the square root instruction in SSE and the square root program in the standard C library.
## Detail
We want to know how much time is required for an instruction to execute. We'll use the sqrtsd instruction in the SSE component. The plan is to execute the sqrtsd instruction many times, say 10 million times. Measure the time required for those 10 million computations, then divide the execution time by 10 million to obtain a kind of average execution time for one instance of the sqrtsd instruction.

Performance varies and is dependent on other factors, such as the clock speed of the CPU. However, the average execution time computed over millions of executions is probably a reasonably accurate measure of the true execution time for the instruction.
