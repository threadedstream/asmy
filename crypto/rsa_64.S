# rsa algorithm written in 64-bit gnu assembly
# The following list represents the registers acting as parameters to the functions.
# Note that order is quite important
# rdi, rsi, rdx, rcx, r8, r9

.section .data
message:
    .long 24

prime_table:
    .long 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 73, 79, 83, 89, 97, 101, 103, 107, 109

prime_table_end:
    .equ prime_table_size, prime_table_end - prime_table

fmt:
    .asciz "vout: %d, uout: %d\n"

.section .text
    .global _start

    _start:
        push %rbp
        mov %rsp, %rbp
        sub $12, %rsp
        xor %rdi, %rdi
        xor %rsi, %rsi

        # int32_t p = 73, q = 79;
        movl $19, %edi
        movl $5616, %esi

        # int32_t e = 0, n = 0, d = 0;
        movl $0, -4(%rbp)
        movl $0, -8(%rbp)
        movl $0, -12(%rbp)

        lea -4(%rbp), %rdx
        lea -8(%rbp), %rcx
        lea -12(%rbp), %r8

        call extended_eucl_iter

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
        sub $36, %rsp
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

        add $36, %rsp
        # restore initial register values
        popq %rbp
        popq %r10
        popq %rbx

        xor %rax, %rax
        ret

    # int32_t choose_neatly_fitting_prime(int32_t n)
    # n in %rdi
    choose_neatly_fitting_prime:
        xor %rax, %rax
        xor %r8, %r8
        # const int32_t prime_table_len = sizeof(prime_table) / sizeof(prime_table[0]);
        mov $prime_table_size, %eax
        movl $4, %r8d
        cltd
        idivl %r8d

        mov $prime_table, %rsi

        movl %eax, %ecx

        # using r8 as an indexing into array
        xorl %r8d, %r8d
        decl %ecx

    choose_neatly_fit_pr_loop:
        cmpl %edi, (%rsi, %r8, 4)
        jb choose_neatly_fit_pr_ret
        incl %r8d
        loop choose_neatly_fit_pr_loop

        # return -1 upon failure
        movl $-1, %eax
        ret

    choose_neatly_fit_pr_ret:
        # return prime_table[i]
        movl (%rsi, %r8, 4), %eax
        ret

    # void generate_keys(int32_t p, int32_t q, int32_t* e, int32_t *n, int32_t *d)
    # p in %edi, q in %esi, e in %rdx, n in %rcx, d in %r8
    generate_keys:
        pushq %rbx
        pushq %r10
        pushq %rbp
        mov %rsp, %rbp

        xor %rax, %rax

        movl %edi, %ebx
        movl %esi, %r10d

        # const int32_t np = p * q
        movl %ebx, %eax
        mull %r10d
        movl %eax, -4(%rbp)

        # const phi_n = (p - 1) * (q - 1)
        decl %ebx
        decl %r10d
        movl %r10d, %eax
        mull %ebx
        mov %eax, -8(%rbp)

        # int32_t ep = choose_neatly_fitting_prime(phi_n);
        movl -8(%rbp), %edi
        # save e, n, and d
        pushq %rdx
        pushq %rcx
        pushq %r8
        call choose_neatly_fitting_prime
        cmpl $-1, %eax
        je generate_keys_failure
        movl %eax, -24(%rbp)

        # v = 0
        movl $0, -12(%rbp)
        # dp = 0
        movl $0, -16(%rbp)
        # r = 0
        movl $0, -20(%rbp)


        # extended_eucl_iter(ep, phi_n,&r, &v, &dp);
        movl -24(%rbp), %edi
        movl -8(%rbp), %esi
        lea -20(%rbp), %rdx
        lea -12(%rbp), %rcx
        lea -16(%rbp), %r8
        call extended_eucl_iter

        # dp = dp % phi_n;
        mov -16(%rbp), %rax
        movl (%rax), %eax
        cltd
        idivl -8(%rbp)
        cmpl $0, %edx
        jb generate_keys_grow_dp
        movl %edx, -16(%rbp)
        jmp generate_keys_success

    generate_keys_grow_dp:
        # dp += phi_n
        addl -8(%rbp), %edx
        movl %edx, -16(%rbp)
        jmp generate_keys_success

    generate_keys_success:
        # restore e, n, and d
        popq %r8
        popq %rcx
        popq %rdx

        # mov ep, np, and dp to temporary registers prior to
        # moving contents to e, n, and d
        movl -24(%rbp), %ebx
        movl -4(%rbp), %r10d
        xor %r9, %r9
        movl -16(%rbp), %r9d

        # *e = ep
        movl %ebx, (%rdx)
        # *n = np
        movl %r10d, (%rcx)
        # *d = dp
        movl %r9d, (%r8)

        # restore callee-saved registers
        popq %rbx
        popq %r10
        popq %rbp

        # return
        ret

    generate_keys_failure:
        # restore e, n, and d
        popq %r8
        popq %rcx
        popq %rdx

        # assign value of -1 (0xffffffff) to them
        movl $-1, (%rdx)
        movl $-1, (%rcx)
        movl $-1, (%r8)

        # restore callee-saved registers
        popq %rbx
        popq %r10
        popq %rbp

        # return
        ret

    _exit:
        add $12, %rsp
        popq %rbp
        xor %rdi, %rdi
        call exit