# rsa algorithm written in 64-bit gnu assembly
# The following list represents the registers acting as parameters to the functions.
# Note that order is quite important
# rdi, rsi, rdx, rcx, r8, r9

.section .data
message:
    .long 24

prime_table:
    .long 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 73, 79, 83, 89, 97, 101, 103, 107, 109

rout:
    .long 0

vout:
    .long 0

uout:
    .long 0

fmt:
    .asciz "vout: %d, uout: %d\n"

.section .text
    .global _start

    _start:
        xor %rdi, %rdi
        xor %rsi, %rsi
        movl $120, %edi
        movl $23, %esi
        mov $rout, %rdx
        mov $vout, %rcx
        mov $uout, %r8
        call extended_eucl_iter
        mov $fmt, %rdi
        mov $vout, %rax
        movl (%rax), %esi
        mov $uout, %rax
        movl (%rax), %edx
        call printf
        jmp _exit

    # int32_t power_mod(int32_t base, int32_t exp, int32_t mod)
    power_mod:
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

    # void extended_eucl_iter(int32_t a, int32_t b, int32_t *rout, int32_t *vout, int32_t *uout)
    # a in %edi, b in %esi, rout in %rdx, vout in %rcx, uout in %r8
    extended_eucl_iter:
        # initialization stage
        pushq %rbx
        pushq %r10
        pushq %rbp

        # save rdx
        mov %rdx, %r10

        mov %rsp, %rbp
        # int32_t r = a
        movl %edi, -4(%rbp)
        # int32_t u = 1
        movl $1, -8(%rbp)
        # int32_t v = 0
        movl $0, -12(%rbp)
        # int32_t rp = b
        movl %esi, -16(%rbp)
        # int32_t up = 0
        movl $0, -20(%rbp)
        # int32_t vp = 1
        movl $1, -24(%rbp)
        # int32_t upold = 0
        movl $0, -28(%rbp)
        # int32_t vpold = 0
        movl $0, -32(%rbp)
        # int32_t rpold = 0
        movl $0, -36(%rbp)
        xor %rax, %rax

    extended_eucl_loop:
        cmpl $0, -16(%rbp)
        jz extended_eucl_assign_and_ret

        # upold = up
        # note: mov does not allow memory-to-memory transfer
        movl -20(%rbp), %eax
        movl %eax, -28(%rbp)

        # vpold = vp
        movl -24(%rbp), %eax
        movl %eax, -32(%rbp)

        # rpold = rp
        movl -16(%rbp), %eax
        movl %eax, -36(%rbp)

    extended_eucl_update_ps:
        # up = u - (r / rp) * up
        mov -4(%rbp), %eax
        cltd
        idivl -16(%rbp)
        movl %eax, %ebx
        imull -20(%rbp)
        subl -8(%rbp), %eax
        negl %eax
        movl %eax, -20(%rbp)

        # vp = v - (r / rp) * vp
        mov %ebx, %eax
        mull -24(%rbp)
        subl -12(%rbp), %eax
        negl %eax
        movl %eax, -24(%rbp)

        # rp = r - (r / rp) * rp
        mov %ebx, %eax
        mull -16(%rbp)
        subl -4(%rbp), %eax
        negl %eax
        movl %eax, -16(%rbp)

    extended_eucl_loop_assign:
        # r = rpold
        movl -36(%rbp), %eax
        movl %eax, -4(%rbp)

        # u = upold
        movl -28(%rbp), %eax
        movl %eax, -8(%rbp)

        # v = vpold
        movl -32(%rbp), %eax
        movl %eax, -12(%rbp)

        jmp extended_eucl_loop

    extended_eucl_assign_and_ret:
        # *rout = r
        movl -4(%rbp), %eax
        movl %eax, (%r10)

        # *uout = u
        movl -8(%rbp), %eax
        movl %eax, (%rcx)

        # *vout = v
        movl -12(%rbp), %eax
        movl %eax, (%r8)

        # restore initial register values
        popq %rbp
        popq %r10
        popq %rbx
        ret

    _exit:
        xor %rdi, %rdi
        call exit