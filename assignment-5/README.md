# Sine Function Benchmark

This repository contains the `Sine Function Benchmark` program, designed and maintained by Jared Pope. The purpose of this program is to compare the performance of two methods for calculating the sine of a given angle: the Taylor series method and the built-in `sin` function in the `<math.h>` library.

## Getting Started

To get started with the `Sine Function Benchmark` program, follow these steps:

1. Clone the repository to your local machine.
2. Compile the source code using a C compiler.
3. Run the compiled program.

## Usage

When running the `Sine Function Benchmark` program, you will be prompted for the following inputs:

1. **Your name**: Enter your name.
2. **Angle in degrees**: Enter the angle for which you want to compute the sine function (in degrees).
3. **Number of terms in Taylor series**: Enter the number of terms to be used in the Taylor series computation.

The program will then compute the sine of the given angle using the Taylor series method and the `sin` function from the `<math.h>` library. The results will be displayed along with the time taken for each method (in tics).

## Example Output

```
Welcome to Asterix Software Development Corporation

This program Sine Function Benchmark is maintained by Jared Pope

Please enter your name: Jared

It is nice to meet you Jared. Please enter an angle number in degrees: 30.0

Thank you. Please enter the number of terms in a Taylor series to be computed: 200

Thank you. The Taylor series will be used to compute the sine of your angle.

The computation completed in 5698 tics and the computed value is 0.500000

Next the sine of 30.000000000 will be computed by the function "sin" in the library <math.h>.

The computation completed in 55685 tics and gave the value 0.500000000

Thank you for using this program. Have a great day.

The driver program received this number 5698. A zero will be returned to the OS. Bye.

The script file will terminate
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
