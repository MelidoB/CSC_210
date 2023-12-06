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
    if (n <= 0) return 1;
    return n * factorial(n - 1);
}

void measureFactorial(int N) {
    StartCounter();
    factorial(N);
    double timeTaken = GetCounter();
    cout << "Time taken for factorial of " << N << ": " << timeTaken << " ms\n";
}

int main() {
    measureFactorial(10);
    measureFactorial(100);
    measureFactorial(1000);
    measureFactorial(10000);

    return 0;
}
