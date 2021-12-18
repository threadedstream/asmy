#pragma once

#include <stdint.h> // int8_t
#include <immintrin.h>


void print_array10(const char* array_fmt, int32_t array[10], int32_t ARRAY_SIZE);
void sort_routine20(int32_t array[10], int32_t ARRAY_SIZE);
void exec_selection_sort(int argc, const char* argv[]);


__m128 dot(__m128 a, __m128 b);