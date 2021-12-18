#include "algos.h"



__m128 dot(__m128 a, __m128 b) {
    // __m64 acts as a 2d vector of 32-bit floats

    // a_low = [0x0, 0xdeadbeef]
    const __m64 a_low = _mm_set_pi32(0x0, 0xdeadbeef);
    // b_low = [0x0, 0xcafebabe]
    const __m64 b_low = _mm_set_pi32(0x0, 0xcafebabe);


    // intuitively, __m128 is a 4d vector of 32-bit floats

    // a = [0x0, 0x0, 0x0, 0xdeadbeef]
    a = _mm_loadl_pi(a, &a_low);

    // b = [0x0, 0x0, 0x0, 0xcafebabe]
    b = _mm_loadl_pi(b, &b_low);

    // note that arrays are read according to little-endian format, i.e
    // the last element is a first one, etc.

    // c = a[0] + b[0] -> [0, 0, 0, 0xdeadbeef + 0xcafebabe]
    __m128 c = _mm_add_ss(a, b);

    return c;
}