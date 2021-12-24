#pragma once

#include <stdint.h> // int8_t
#include <immintrin.h>

struct Vec {
    float x;
    float y;
    float z;
    float w;

};


struct Mat4x4 {
    Vec entry_0;
    Vec entry_1;
    Vec entry_2;
    Vec entry_3;

};


static bool operator==(const Vec& one, const Vec &other) {
    return ((one.x == other.x) &&
            (one.y == other.y) &&
            (one.z == other.z) &&
            (one.w == other.w));

}

static bool operator== (const Mat4x4& one, const Mat4x4& other) {
    return ((one.entry_0 == other.entry_0) &&
            (one.entry_1 == other.entry_1) &&
            (one.entry_2 == other.entry_2) &&
            (one.entry_3 == other.entry_3));
}


void print_array10(const char *array_fmt, int32_t array[10], int32_t ARRAY_SIZE);

void sort_routine20(int32_t array[10], int32_t ARRAY_SIZE);

void exec_selection_sort(int argc, const char *argv[]);


float clangDotO1(const Vec &v1, const Vec &v2);

float clangDotO2(const Vec &v1, const Vec &v2);

Mat4x4 matMult(const Mat4x4 &m1, const Mat4x4 &m2);