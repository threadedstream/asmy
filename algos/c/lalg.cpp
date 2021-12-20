#include "algos.h"


float clangDotO1(const Vec& v1, const Vec& v2) {
    float res{0.0f};
    // not sure of safety of the following operations
    auto v1_ptr = reinterpret_cast<float*>((float*)&v1);
    auto v2_ptr = reinterpret_cast<float*>((float*)&v2);

    __m128 xmm0 = (__m128) {0};
    __m128 xmm1 = (__m128) {0};
    __m128 xmm2 = (__m128) {0};

    //  movss   xmm0, dword ptr [rdi]
    //  mulss   xmm0, dword ptr [rsi]
    xmm0 = _mm_load_ss(v1_ptr);
    auto temp = _mm_load_ss(v2_ptr);
    xmm0 = _mm_mul_ss(xmm0, temp);

    //  movss   xmm1, dword ptr [rdi + 4]
    //  mulss   xmm1, dword ptr [rsi + 4]
    xmm1 = _mm_load_ss(v1_ptr + 1);
    temp = _mm_load_ss(v2_ptr + 1);
    xmm1 = _mm_mul_ss(xmm1, temp);

    //  addss   xmm1, xmm0
    xmm1 = _mm_add_ss(xmm1, xmm0);

    //  movss   xmm2, dword ptr [rdi + 8]
    //  mulss   xmm2, dword ptr [rsi + 8]
    xmm2 = _mm_load_ss(v1_ptr + 2);
    temp = _mm_load_ss(v2_ptr + 2);
    xmm2 = _mm_mul_ss(xmm2, temp);

    // addss   xmm2, xmm1
    xmm2 = _mm_add_ss(xmm2, xmm1);

    // movss   xmm0, dword ptr [rdi + 12]
    // mulss   xmm0, dword ptr [rsi + 12]
    xmm0 = _mm_load_ss(v1_ptr + 3);
    temp = _mm_load_ss(v2_ptr + 3);
    xmm0 = _mm_mul_ss(xmm0, temp);

    // addss   xmm0, xmm2
    xmm0 = _mm_add_ss(xmm0, xmm2);

    _mm_store_ss(&res, xmm0);

    return res;
}

float clangDotO2(const Vec& v1, const Vec& v2) {
    float res{0.0f};
    auto v1_ptr = reinterpret_cast<float*>((float*)&v1);
    auto v2_ptr = reinterpret_cast<float*>((float*)&v2);

    __m128 xmm0 = (__m128) {0};
    __m128 xmm1 = (__m128) {0};
    __m128 xmm2 = (__m128) {0};

    // movss   xmm0, dword ptr [rdi]
    // movss   xmm1, dword ptr [rdi + 4]
    xmm0 = _mm_load_ss(v1_ptr);
    xmm1 = _mm_load_ss(v1_ptr+1);

    // mulss   xmm0, dword ptr [rsi]
    // mulss   xmm1, dword ptr [rsi + 4]
    auto temp = _mm_load_ss(v2_ptr);
    xmm0 = _mm_mul_ss(xmm0, temp);
    temp = _mm_load_ss(v2_ptr+1);
    xmm1 = _mm_mul_ss(xmm1, temp);

    // addss   xmm1, xmm0
    xmm1 = _mm_add_ss(xmm1, xmm0);


    //  movsd   xmm2, qword ptr [rdi + 8]
    //  movsd   xmm0, qword ptr [rsi + 8]
    xmm2 = _mm_load_sd(reinterpret_cast<double*>(v1_ptr+2));
    xmm0 = _mm_load_sd(reinterpret_cast<double*>(v2_ptr+2));

    //  mulps   xmm0, xmm2
    //  addss   xmm1, xmm0
    xmm0 = _mm_mul_ps(xmm0, xmm2);
    xmm1 = _mm_add_ss(xmm1, xmm0);

    //  shufps  xmm0, xmm0, 85
    //  addss   xmm0, xmm1
    // TODO(threadedstream):

    return res;
}