.section .data
array:
.byte 89, 10, 67, 1, 4, 27, 12, 34, 86, 3
array_end:
    .equ ARRAY_SIZE, array_end - array
array_fmt:
    .asciz " %d"

usort_str:
    .asciz "unsorted array:"
sort_str:
    .asciz "sorted array:"
newline:
    .asciz "\n"



.section .text

    .global _start

     _start:
        mov $usort_str, %rdi
        call puts
        mov $array_fmt, %rdi
        mov $array, %rsi
        mov $ARRAY_SIZE, %rdx
        call print_array_10
        xor %rax, %rax
        jmp _exit


     print_array_10:
        pushq %rbx
        # moving ARRAY_SIZE to rcx for looping
        mov %rdx, %rcx
        # moving array to r8, since %rsi is used to call printf each iteration
        mov %rsi, %r8
        xor %rbx, %rbx

     push_loop:
        xor %rax, %rax
        # cause of segfault, since r8 has changed during execution of printf
        movb (%r8, %rbx, 1), %al
        mov %rax, %rsi
        # saving rcx, as it might be clobbered during printf
        xor %rax, %rax
        pushq %rdi
        pushq %rcx
        pushq %r8
        call printf
        xor %rax, %rax
        # restoring %rcx
        popq %r8
        popq %rcx
        popq %rdi
        incq %rbx
        loop push_loop
        mov $newline, %rdi
        call printf
        popq %rbx
        ret


     _exit:
        movb $60, %al
        xor %rdi, %rdi
        syscall

