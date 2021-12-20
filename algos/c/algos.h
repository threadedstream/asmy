#pragma once

#include <stdint.h> // int8_t
#include <immintrin.h>

struct Vec {
    float x;
    float y;
    float z;
    float w;
};

void print_array10(const char* array_fmt, int32_t array[10], int32_t ARRAY_SIZE);
void sort_routine20(int32_t array[10], int32_t ARRAY_SIZE);
void exec_selection_sort(int argc, const char* argv[]);


float clangDotO1(const Vec& v1, const Vec& v2);
float clangDotO2(const Vec& v1, const Vec& v2);
