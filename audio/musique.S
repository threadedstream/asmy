
.section .data

// TODO(threadedstream): make parameters below dynamic, i.e let user decide what those values
// should be
rate:
    .long 44100

channels:
    .long 2

seconds:
    .long 3

pcm_device:
    .asciz "default"


// TODO(threadedstream): make format strings look more informative
failed_to_open_device_fmt:
    .asciz "Can't open a PCM device"

.section .bss
pcm:
    .long 0

tmp:
    .long 0

dir:
    .long 0

buff:
    .byte 0

buff_size:
    .long 0

loops:
    .long 0

pcm_handle:
    .zero 8

params:
    .zero 8



.section .text
    .globl _start

    _start:
        push %r14
        // opening a device
        lea pcm_handle(%rip), %rdi
        lea pcm_device(%rip), %rsi
        xor %edx, %edx
        xor %ecx, %ecx
        call snd_pcm_open
        //  used to be cmp $0, %eax; jl report_failure_exit
        //  look that one up in assembly output produces by gcc
        //  command used to generate assembly listing: gcc -m64 -O2 -S musicplayer.c
        testl %eax, %eax

        // save return value in pcm
        mov %eax, pcm(%rip)
        mov $failed_to_open_device_fmt, %rax
        cmovl %rax, %rdi
        js report_failure_exit

        // getting the size of snd_pcm_hw_params struct
        call snd_pcm_hw_params_sizeof
        // used to be: mov %eax, %r8d
        addq $23, %rax
        andq $-16, %rax // rax = 624

        // params = alloca(size_t size)

        // original assembly output contained this:
        // 	movq	%rsp, %rcx   -> assuming rsp = 0x7fffffffdd10; rcx = rsp
        //  addq	$23, %rax    -> rax = 608 + 23 = 631; is it aligned according to abi? 631 % 16 = 7 -> lol, nope.
        //  movq	%rax, %rdx   -> rdx = rax
        //  andq	$-4096, %rax -> rax = rax & 0xfffffffffffff000 = 0
        //  subq	%rax, %rcx   -> rcx = rcx - rax = 0x7fffffffdd10 - 0 = 0x7fffffffdd10
        //  andq	$-16, %rdx   -> rdx = rdx & 0xfffffffffffffff0 = 624, note that ANDing any value with -16 will make this value a multiple of 16
        //                          also take into account that operation chooses the closest multiple right before that same initial value in case if
        //                          value if not aligned, and nops (leaves the value as it is) otherwise.
        //  movq	%rcx, %rax   -> rax = rcx = 0x7fffffffdd10
        //  cmpq	%rax, %rsp   -> rax == rsp?
        //  je	.L4              -> yep, branch to .L4

        // .L4:
        //   andl	$4095, %edx  -> edx = edx & 4095 = 624 & 0x0000000000000fff = 624; oh, 4095 is just an inverted version of -4096, what a surprise! (no)
        //   subq	%rdx, %rsp   -> rsp = rsp - rdx = 0x7fffffffdd10 - 624 = 0x7fffffffdaa0
        //   testq	%rdx, %rdx   -> rdx == 0?
        //   jne .L27            -> nope, branch to .L27

        // .L27:
        // 	    orq	$0, -8(%rsp,%rdx) -> rsp = (rsp + rdx - 8) | 0x0 = (0x7fffffffdaa0 + 624 - 8) | 0 = 0x7fffffffdd08; UPD: it's just a noop shit
        //      jmp	.L5 -> unconditionally branch to l5

        // .L5:
        //     call	snd_pcm_hw_params_sizeof@PLT -> rax = 608
        //     leaq  15(%rsp), %r14              -> r14 = rsp + 15 = 0x7fffffffdd08 + 15 = 0x7fffffffdd17; aligned according to ABI? nope, 0x7fffffffdd17 % 16 = 7
        //     xorl	%esi, %esi                   -> esi = 0; 2-nd parameter to memset
        //     andq $-16, %r14                   -> r14 = r14 & 0xfffffffffffffff0 = 0x7fffffffdd17 & 0xfffffffffffffff0 = 0x7fffffffdd10; it's mathematically aligned
        //     movq	%rax, %rdx                   -> rdx = rax = 608; 3-rd parameter to memset
        //     movq %r14, %rdi                   -> rdi = r14 = 0x7fffffffdd10 // 1-st parameter to memset -- actual address
        //     call	memset@PLT                   -> memset(0x7fffffffdd10, 0, 608)

        sub %rax, %rsp
        orq $0, -8(%rsp, %rax)

        leaq 15(%rsp), %r14 // rax = rsp + 15
        andq $-16, %r14
        movq %r14, %rdi
        call snd_pcm_hw_params_sizeof
        leaq 0(%rax), %rdx
        xorq %rsi, %rsi
        call memset@PLT

        // snd_pcm_hw_params_any(pcm_handle, params);
        mov pcm_handle(%rip), %rdi
        mov %r14, %rsi
        call snd_pcm_hw_params_any
        jmp _exit




//       mov $params, %rdi
//        lea (%rdi), %rdi
//        call snd_pcm_hw_params_alloca


    report_failure_exit:
        xor %rax, %rax
        call printf
        jmp _exit

    success:
        jmp _exit

    _exit:
        pop %r14
        add $624, %rsp
        xor %rdi, %rdi

        call exit

