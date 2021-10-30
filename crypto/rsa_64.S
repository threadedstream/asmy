.section .data
a:
    .long 10
b:
    .long 3

fmt:
    .asciz "The number is: %d\n"

.section .text
    .global _start

    _start:
        mov $a, %rcx
        mov $b, %r8
        xor %rdi, %rdi
        xor %rsi, %rsi
        movl (%rcx), %edi
        movl (%r8), %esi
        call compute_gcd
        mov %rax, %rsi
        mov $fmt, %rdi
        xor %rax, %rax
        call printf
        jmp _exit

    compute_gcd:
        movl %edi, %eax
        cltd
        idivl %esi
        test %edx, %edx
        jnz next_gcd_call
        movl %esi, %eax
        ret

    next_gcd_call:
        movl %edx, %esi
        mov %esi, %edi
        jmp compute_gcd

    _exit:
        mov $60, %rax
        xor %rdi, %rdi
        syscall