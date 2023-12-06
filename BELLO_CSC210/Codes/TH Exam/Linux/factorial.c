#include <chrono>
#include <iostream>

using namespace std;

int factorial(int n) {
    if (n <= 0) return 1;
    return n * factorial(n - 1);
}

void measureFactorial(size_t N) {
    auto start = chrono::high_resolution_clock::now();
    factorial(N);
    auto end = chrono::high_resolution_clock::now();

    chrono::duration<double, milli> timeTaken = end - start;
    cout << "Time taken for factorial of " << N << ": " << timeTaken.count() << " ms\n";
}

int main() {
    measureFactorial(10);
    measureFactorial(100);
    measureFactorial(1000);
    measureFactorial(10000);

    return 0;
}
