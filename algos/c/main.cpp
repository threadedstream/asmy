#include "algos.h"

int main(int argc, const char* argv[]) {

    __m128 a = (__m128) {0, 0, 0, 0};
    __m128 b = (__m128) {0, 0, 0, 0};

    const auto res = dot(a, b);

    return 0;
}