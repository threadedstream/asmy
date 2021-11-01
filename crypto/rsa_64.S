.section .data
message:
    .long 24

prime_table:
    .long 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 73, 79, 83, 89, 97, 101, 103, 107, 109

power_mod_fmt:
    .asciz "%d raised to the power %d mod %d is equal to %d\n"

base:
    .long 40

exp:
    .long 12

mod:
    .long 30

.section .text
    .global _start

    _start:
        mov $base, %rdi
        movl (%rdi), %edi
        mov $exp, %rsi
        movl (%rsi), %esi
        mov $mod, %rdx
        movl (%rdx), %edx
        call power_mod
        mov $power_mod_fmt, %rdi
        mov $base, %rsi
        movl (%rsi), %esi
        mov $exp, %rdx
        movl (%rdx), %edx
        mov $mod, %r10
        movl (%r10), %r10d
        mov %rax, %r8
        xor %rax, %rax
        call printf
        jmp _exit

    power_mod:
        # accepts base, exp, and mod (%edi, %esi, %edx)
        pushq %rbx
        movl $1, %r8d
        # store mod into ebx, as edx will be used as a result of mod operation
        mov %edx, %ebx
        xor %rax, %rax

    power_mod_loop:
        cmpl $0, %esi
        jz power_mod_ret
        test $1, %esi
        jz half_exp_assign_base
        movl %r8d, %eax
        imul %edi
        idivl %ebx
        movl %edx, %r8d

    half_exp_assign_base:
        shr $1, %esi
        imul %edi, %edi
        movl %edi, %eax
        # converts eax to eax:edx
        cltd
        idivl %ebx
        mov %edx, %edi
        jmp power_mod_loop


    power_mod_ret:
        popq %rbx
        mov %r8, %rax
        ret

    _exit:
        xor %rdi, %rdi
        call exit