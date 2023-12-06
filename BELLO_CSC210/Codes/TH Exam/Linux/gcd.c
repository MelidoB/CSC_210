#include <iostream>
#include <chrono>

int gcd_recurs(int a, int b) {
    if (b == 0)
        return a;
    else
        return gcd_recurs(b, a % b);
}

void measureGCD(int a, int b, int N) {
    auto start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < N; i++) {
        gcd_recurs(a, b);
    }
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double, std::milli> timeTaken = end - start;
    std::cout << "Average time for " << N << " iterations: " << timeTaken.count() / N << " ms" << std::endl;
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
