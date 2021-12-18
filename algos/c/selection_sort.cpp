// This is transpiled version of selection_sort.S
// I'm doing this solely for the purpose of learning assembly language

#include <stdio.h> // puts, printf
#include "algos.h"

void print_array10(const char* array_fmt, int32_t array[10], int32_t ARRAY_SIZE) {
    // array_fmt -> 8(%ebp)
    // array -> 12(%ebp)
    // ARRAY_SIZE -> 16(%ebp)

    // epilog
    // movl 8(%ebp), %edx
    // movl 12(%ebp), %ebx
    // movl 16(%ebp), %ecx
    // movl $0, %esi


    for (int32_t ecx = 0; ecx < ARRAY_SIZE; ecx++) {
        // movl 8(%ebp), %edx
        // xorl %eax, %eax
        // movb (%ebx, %esi, 1), %al

        // pushl %eax
        // pushl %edx
        // call printf
        printf(array_fmt, array[ecx]);
    }

    // pushl $newline
    // call printf
    // addl $4, %esp
    printf("\n");
}

void sort_routine20(int32_t array[10], int32_t ARRAY_SIZE) {
    // array -> 8(%ebp)
    // ARRAY_SIZE -> 12(%ebp)
    int32_t min_idx = 0;
    int32_t esi = 0;
    int32_t edi = 0;

    // outer_loop
    // decl %ecx
    // # Prepare for outer loop here
    // xorl %esi, %esi
    for (int32_t ecx = ARRAY_SIZE - 1; ecx > 0; ecx--) {
        // movl %esi, -4(%ebp)
        // movl %esi, %edi
        // incl %edi
        min_idx = esi;
        edi = esi + 1;

        // inner_loop
        // cmpl $ARRAY_SIZE, %edi
        // jge swap_vars
        while (edi < ARRAY_SIZE) {
            //  xorb %al, %al
            //  movl -4(%ebp), %edx
            //  movb (%ebx, %edx, 1), %al
            //  cmpb %al, (%ebx, %edi, 1)
            //  jge check_next
            if (array[edi] < array[min_idx]) {
                min_idx = edi;
            }
            // check_next:
            // incl %edi
            // jmp inner_loop
            edi++;
        }

        // swap_vars:
        // movl -4(%ebp), %edi
        // movb (%ebx, %edi, 1), %dl
        // movb (%ebx, %esi, 1), %al
        // movb %dl, (%ebx, %esi, 1)
        // movb %al, (%ebx, %edi, 1)
        // incl %esi
        // loop outer_loop
        int8_t dl = array[min_idx];
        int8_t al = array[esi];
        array[esi] = dl;
        array[min_idx] = al;
        esi++;
    }
}


void exec_selection_sort(int argc, const char* argv[]) {
    // although original assembly version declares byte array, i prefer using array of
    // 32-bit integers, as it's much more comfortable to deal with during debugging
    int32_t array[10] = {89, 10, 67, 1, 4, 27, 12, 34, 86, 3}; // .byte 89, 10, 67, 1, 4, 27, 12, 34, 86, 3
    int32_t ARRAY_SIZE = sizeof(array) / sizeof array[0]; //  .equ ARRAY_SIZE, array_end - array
    const char* array_fmt = " %d"; // .asciz " %d"
    const char* usort_str = "unsorted array:"; // .asciz "unsorted array:"
    const char* sort_str = "sorted array:"; //  .asciz "sorted array:"
    const char* newline = "\n"; // .asciz "\n"


    // pushl $usort_str
    // call puts
    puts(usort_str);

    //  pushl $ARRAY_SIZE
    //  pushl $array
    //  pushl $array_fmt
    //  call print_array10
    print_array10(array_fmt, array, ARRAY_SIZE);

    //  pushl $ARRAY_SIZE
    //  pushl $array
    //  call sort_routine20
    sort_routine20(array, ARRAY_SIZE);

    //  pushl $sort_str
    //  call puts
    puts(sort_str);

    //  pushl $ARRAY_SIZE
    //  pushl $array
    //  pushl $array_fmt
    //  call print_array10
    print_array10(array_fmt, array, ARRAY_SIZE);
}
