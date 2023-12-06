#include <stdio.h>
#include <windows.h>

LARGE_INTEGER frequency;        // ticks per second
LARGE_INTEGER start, end;       // ticks

int gcd_recurs(int a, int b) {
    if (b == 0) 
        return a;
    else
        return gcd_recurs(b, a % b);
}

void StartCounter() {
    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&start);
}

double GetCounter() {
    QueryPerformanceCounter(&end);
    return (double)(end.QuadPart - start.QuadPart) / frequency.QuadPart;
}

void measureGCD(int a, int b, int N) {
    StartCounter();
    for (int i = 0; i < N; i++) {
        gcd_recurs(a, b);
    }
    double timeTaken = GetCounter() * 1000; // Convert to milliseconds
    printf("Average time for %d iterations: %f ms\n", N, timeTaken / N);
}

int main() {
    int a = 56;  // Example values
    int b = 98;

    measureGCD(a, b, 10);
    measureGCD(a, b, 100);
    measureGCD(a, b, 1000);
    measureGCD(a, b, 10000);

    return 0;
}
