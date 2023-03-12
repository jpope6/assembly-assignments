#include <cstdint>
#include <iostream>
#include <stdint.h>

using namespace std;

extern "C" void quick_sort(double array[], int size);

// function to swap elements
void swap(double *a, double *b) {
  double t = *a;
  *a = *b;
  *b = t;
}

// function to print the array
void printArray(double array[], int size) {
  int i;
  for (i = 0; i < size; i++)
    cout << array[i] << " ";
  cout << endl;
}

// function to rearrange array (find the partition point)
int partition(double array[], int low, int high) {
    
  // select the rightmost element as pivot
  int pivot = array[high];
  
  // pointer for greater element
  int i = (low - 1);

  // traverse each element of the array
  // compare them with the pivot
  for (int j = low; j < high; j++) {
    if (array[j] <= pivot) {
        
      // if element smaller than pivot is found
      // swap it with the greater element pointed by i
      i++;
      
      // swap element at i with element at j
      swap(&array[i], &array[j]);
    }
  }
  
  // swap pivot with the greater element at i
  swap(&array[i + 1], &array[high]);
  
  // return the partition point
  return (i + 1);
}

void quickSort(double array[], int low, int high) {
  if (low < high) {
      
    // find the pivot element such that
    // elements smaller than pivot are on left of pivot
    // elements greater than pivot are on righ of pivot
    int pi = partition(array, low, high);

    // recursive call on the left of pivot
    quickSort(array, low, pi - 1);

    // recursive call on the right of pivot
    quickSort(array, pi + 1, high);
  }
}

void quick_sort(double array[], int size) {
    quickSort(array, 0, size - 1);
}

int main() {
    double numbers[] = { -1.7285404906529e+35, 
        -1.0783269166497e+215,
        2.3023511350123e+281,
        -1.7120468634983e-150, 
        -2.7013251521238e-77, 
        -1.3927477891903e-13, 
        3.2122097456195e+122, 
        1.8128471332481e-175, 
        3.0647883250649e+45, 
        9.4147083516543e+81
    };

    double number[] = { 2.5, 8.3, 6.5, 84.2, 9.54, 5.19, 6.2, 62.2 , 84.1, 52.3 };

    quick_sort(number, 10);

    for (int i = 0; i < 10; i++) {
        cout << number[i] << ", ";
    }
}
