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
        # output usort_str
        mov $usort_str, %rdi
        call puts

        # print unsorted array
        mov $array_fmt, %rdi
        mov $array, %rsi
        mov $ARRAY_SIZE, %rdx
        call print_array_10

        # sort array
        mov $array, %rdi
        mov $ARRAY_SIZE, %rsi
        call sort_routine20

        # output sort_str
        mov $sort_str, %rdi
        call puts

        # print sorted array
        mov $array_fmt, %rdi
        mov $array, %rsi
        mov $ARRAY_SIZE, %rdx
        call print_array_10
        xor %rax, %rax

        # hop right into exit
        jmp _exit


     print_array_10:
        # saving callee-saved registers
        pushq %rbx
        pushq %r12
        # moving ARRAY_SIZE to rcx for looping
        mov %rdx, %rcx
        # moving array to r12, since %rsi is used to call printf each iteration
        mov %rsi, %r12
        xor %rbx, %rbx

     push_loop:
        xor %rax, %rax
        # cause of segfault, since r8 has changed during execution of printf
        movb (%r12, %rbx, 1), %al
        mov %rax, %rsi
        # saving rcx, as it might be clobbered during printf
        xor %rax, %rax
        pushq %rdi
        pushq %rcx
        call printf
        xor %rax, %rax
        # restoring %rcx
        popq %rcx
        popq %rdi
        incq %rbx
        loop push_loop
        mov $newline, %rdi
        call printf

        # restoring callee-saved registers
        popq %r12
        popq %rbx
        ret

    sort_routine20:
        pushq %rbx
        pushq %r12
        mov %rsi, %rcx
        decq %rcx
        xor %rsi, %rsi

    outer_loop:
        mov %rsi, %r12
        mov %rsi, %rbx
        incq %rbx

    inner_loop:
        cmp $ARRAY_SIZE, %rbx
        jge swap_vars
        xor %rax, %rax
        movb (%rdi, %r12, 1), %al
        cmpb %al, (%rdi, %rbx, 1)
        jge check_next
        mov %rbx, %r12

    check_next:
        incq %rbx
        jmp inner_loop

    swap_vars:
        movb (%rdi, %r12, 1), %dl
        movb (%rdi, %rsi, 1), %al
        movb %dl, (%rdi, %rsi, 1)
        movb %al, (%rdi, %r12, 1)
        inc %rsi
        loop outer_loop
        popq %r12
        popq %rbx
        ret

     _exit:
        movb $60, %al
        xor %rdi, %rdi
        syscall

