#include <cstdint>
#include <iostream>
#include <stdint.h>

using namespace std;

extern "C" void quick_sort(double array[], int size);

// function to partition the array
int partition(double arr[], int low, int high) {
    int pivot = arr[high]; // select the last element as pivot
    int i = (low - 1); // index of smaller element
    for (int j = low; j <= high - 1; j++) {
        // if current element is smaller than or equal to pivot
        if (arr[j] <= pivot) {
            i++; // increment index of smaller element
            swap(arr[i], arr[j]); // swap arr[i] and arr[j]
        }
    }
    swap(arr[i + 1], arr[high]); // swap arr[i + 1] and arr[high]
    return (i + 1); // return the index of pivot
}

// function to perform quick sort
void quickSort(double arr[], int low, int high) {
    if (low < high) {
        // partition the array around pivot and get the index of pivot
        int pi = partition(arr, low, high);
        // recursively sort the sub-arrays before and after the pivot
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

// function to call quick sort with only array and size as parameters
void quick_sort(double arr[], int size) {
    quickSort(arr, 0, size - 1); // call quickSort with initial low and high values
}

int main() {
    double arr[] = { 1.2, 8.3, 3.1, 4.7, 9.2, 0.7, 7.2, 3.8, 12.8, 5,8 };
    quick_sort(arr, 10);

    for (int i = 0; i < 10; i++) {
        cout << arr[i] << ", ";
    }
     cout << "\n";
}
