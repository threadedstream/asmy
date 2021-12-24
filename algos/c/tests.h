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

//  80	70	60	50
//  240	214	188	162
// 	400	358	316	274
//	560	502	444	386
static void testMatMult() {
    const auto m1 = Mat4x4{
        .entry_0 = Vec{1, 2, 3, 4},
        .entry_1 = Vec{5, 6, 7, 8},
        .entry_2 = Vec{9, 10, 11, 12},
        .entry_3 = Vec{13, 14, 15, 16}
    };

    const auto m2 = Mat4x4{
        .entry_0 = Vec{16, 12, 8, 4},
        .entry_1 = Vec{15, 11, 7, 3},
        .entry_2 = Vec{14, 10, 6, 2},
        .entry_3 = Vec{13, 9, 5, 1}
    };

    const auto expected_mat = Mat4x4 {
        .entry_0 = Vec{80, 70, 60, 50},
        .entry_1 = Vec{240, 214, 188, 162},
        .entry_2 = Vec{400, 358, 316, 274},
        .entry_3 = Vec{560, 502, 444, 386}
    };

    const auto m3 = matMult(m1, m2);
    assert(m3 == expected_mat && "m3 should be equal to expected_mat");
}