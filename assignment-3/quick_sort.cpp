#include <iostream>

using namespace std;

extern "C" int* quick_sort(int array[], int size);

int partition(int arr[], int low, int high)
{
    int pivot = arr[high]; // pivot
    int i
        = (low - 1); // Index of smaller element and indicates
                 // the right position of pivot found so far
 
    for (int j = low; j <= high - 1; j++) {
        // If current element is smaller than the pivot
        if (arr[j] < pivot) {
            i++; // increment index of smaller element
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return (i + 1);
}

void quickSort(int arr[], int low, int high)
{
    if (low < high) {
        /* pi is partitioning index, arr[p] is now
        at right place */
        int pi = partition(arr, low, high);
 
        // Separately sort elements before
        // partition and after partition
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

int* quick_sort(int array[], int size) {
    int* sorted_array = new int[size];
    for (int i = 0; i < size; i++) {
        sorted_array[i] = array[i];
    }
    quickSort(sorted_array, 0, size - 1);
    return sorted_array;
}
