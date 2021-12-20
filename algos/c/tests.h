#pragma once

#include "algos.h"
#include <assert.h>


static void testDots() {
    const auto v1 = Vec{1, 2, 3, 4};
    const auto v2 = Vec{2, 4, 6, 8};

    const auto expected_result = 0x3c;

    const auto clang_dot_o1_res = clangDotO1(v1, v2);
    assert(clang_dot_o1_res == expected_result && "clangDotO1 gave incorrect result!!!!");

    const auto clang_dot_o2_res = clangDotO2(v1, v2);
    assert(clang_dot_o1_res == expected_result && "clangDotO1 gave incorrect result!!!!");

}