#include <iostream>
#include <windows.h>

using namespace std;

double PCFreq = 0.0;
LONGLONG CounterStart = 0;

void StartCounter() {
    LARGE_INTEGER li;
    if (!QueryPerformanceFrequency(&li))
        cout << "QueryPerformanceFrequency failed!\n";

    PCFreq = double(li.QuadPart) / 1000.0;
    QueryPerformanceCounter(&li);
    CounterStart = li.QuadPart;
}

double GetCounter() {
    LARGE_INTEGER li;
    QueryPerformanceCounter(&li);
    return double(li.QuadPart - CounterStart) / PCFreq;
}

int factorial(int n) {
    if (n == 1) return 1;
    return (n * factorial(n - 1));
}

void measureFactorial(int N, int numMeasurements) {
    double totalTime = 0.0;
    for (int i = 0; i < numMeasurements; ++i) {
        StartCounter();
        factorial(N);
        totalTime += GetCounter();
    }
    double averageTime = totalTime / numMeasurements;
    cout << "Average time taken for factorial of " << N << ": " << averageTime << " ms\n";
}

int main() {
    const int numMeasurements = 10000;
    measureFactorial(10, numMeasurements);
    measureFactorial(100, numMeasurements);
    measureFactorial(1000, numMeasurements);
    measureFactorial(4000, numMeasurements); 

    return 0;
}
