
.section .data

// TODO(threadedstream): make parameters below dynamic, i.e let user decide what those values
// should be

pcm_device:
    .asciz "default"

// TODO(threadedstream): make format strings look more informative
failed_to_open_device_fmt:
    .asciz "Can't open a PCM device\n"

failed_to_set_access:
    .asciz "Can't set interleaved mode\n"

failed_to_set_format:
    .asciz "Can't set format\n"

failed_to_set_channels_number:
    .asciz "Can't set channels number\n"

failed_to_set_rate:
    .asciz "Can't set rate\n"

failed_to_set_hardware_params:
    .asciz "Can't set hardware parameters\n"

failed_to_allocate_memory:
    .asciz "Can't allocate memory for a buffer\n"

correct_usage:
    .asciz "Usage: ./<prog> <rate> <channels> <seconds>\n"

early_end:
    .asciz "Early end of a file\n"

failed_to_write_to_pcm_device:
    .asciz "Can't write to PCM device\n"

starting_playback:
    .asciz "Spinning playback up...\n"

counter_fmt:
    .asciz "Current counter value is %d\n"

releasing_resources:
    .asciz "Releasing resources...\n"


.section .bss
tmp:
    .long 0

pcm:
    .long 0

frames:
    .long 0

// void ** buff
buff:
    .zero 8

buff_size:
    .long 0

loops:
    .long 0

// snd_pcm_t **pcm_handle
pcm_handle:
    .zero 8

// snd_pcm_hw_params_t **params
params:
    .zero 8

rate:
    .long 0

channels:
    .long 0

seconds:
    .long 0



.section .text
    .globl _start

    _start:
        // for some reason, program segfaults when pushing %r14 onto the stack
        pushq %rbp
        mov %rsp, %rbp
        pushq %r15
        pushq %r14
	    pushq %r13
	    pushq %r12
	    pushq %rbx
	    // rsp = rsp - 48; is 16 byte aligned? Yes! But we should account
	    // for the first call, which will decrement rsp by 8.
        movl 8(%rbp), %eax # hopefully, it's accessing argc
        cmpl $4, %eax
        lea correct_usage(%rip), %rax
        cmovs %rax, %rdi
        jl report_failure_exit

        # actual: rate = atoi(argv[1])
        # optimized to:  rate = strtol(argv[1], 0, 10)
        movq 24(%rbp), %rdi
        xorl %esi, %esi
        movl $10, %edx
        call strtol
        mov %rax, rate(%rip)

        # actual: channels = atoi(argv[2])
        # optimized to: channels = strtol(argv[2], 0, 10)
        movq 32(%rbp), %rdi
        xorl %esi, %esi
        movl $10, %edx
        call strtol
        mov %rax, channels(%rip)

        # actual: seconds = atoi(argv[3])
        # optimized to: seconds = strtol(argv[3], 0, 10)
        movq 40(%rbp), %rdi
        xorl %esi, %esi
        movl $10, %edx
        call strtol
        mov %rax, seconds(%rip)

        // opening a device
        lea pcm_handle(%rip), %rdi
        lea pcm_device(%rip), %rsi
        xor %edx, %edx
        xor %ecx, %ecx
        call snd_pcm_open
        //  used to be cmp $0, %eax; jl report_failure_exit
        //  looked that one up in assembly output produced by gcc
        //  command used to generate assembly listing: gcc -m64 -O2 -S musicplayer.c
        testl %eax, %eax

        // save return value in pcm
        // UPD: have no clue why to do this anyway
        mov %eax, pcm(%rip)
        mov $failed_to_open_device_fmt, %rax
        cmovs %rax, %rdi
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
        orq $0, -8(%rsp, %rax) // noop;

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

        // snd_pcm_hw_params_set_access(pcm_handle, params, SND_PCM_ACCESS_RW_INTERLEAVED)
        mov pcm_handle(%rip), %rdi
        mov %r14, %rsi // %r14 acts as params
        mov $0x3, %edx // SND_PCM_ACCESS_RW_INTERLEAVED
        call snd_pcm_hw_params_set_access

        // if (eax < 0)
        testl %eax, %eax
        mov $failed_to_set_access, %rax
        cmovs %rax, %rdi
        js report_failure_exit

        // snd_pcm_hw_params_set_format(pcm_handle, params, SND_PCM_FORMAT_S16_LE)
        mov pcm_handle(%rip), %rdi
        mov %r14, %rsi
        mov $0x2, %edx // SND_PCM_FORMAT_S16_LE
        call snd_pcm_hw_params_set_format

        // if (eax < 0)
        testl %eax, %eax
        mov $failed_to_set_format, %rax
        cmovs %rax, %rdi
        js report_failure_exit

        // snd_pcm_hw_params_set_channels(pcm_handle, params, channels)
        mov pcm_handle(%rip), %rdi
        mov %r14, %rsi
        mov channels(%rip), %edx
        call snd_pcm_hw_params_set_channels

        // if (eax < 0)
        testl %eax, %eax
        mov $failed_to_set_channels_number, %rax
        cmovs %rax, %rdi
        js report_failure_exit

        // snd_pcm_hw_params_set_rate_near(pcm_handle, params, &rate, 0)
        mov pcm_handle(%rip), %rdi
        mov %r14, %rsi
        mov $rate, %rdx
        xor %ecx, %ecx
        call snd_pcm_hw_params_set_rate_near

        // if (eax < 0)
        testl %eax, %eax
        mov $failed_to_set_rate, %rax
        cmovs %rax, %rdi
        js report_failure_exit

        // snd_pcm_hw_params(pcm_handle, params)
        mov pcm_handle(%rip), %rdi
        mov %r14, %rsi
        call snd_pcm_hw_params

        // if (eax < 0)
        testl %eax, %eax
        mov $failed_to_set_hardware_params, %rax
        cmovs %rax, %rdi
        js report_failure_exit

        // TODO(threadedstream): too lazy to translate this whole thing to assembly
        // printf("PCM name: '%s'\n", snd_pcm_name(pcm_handle));

        // printf("PCM state: %s\n", snd_pcm_state_name(snd_pcm_state(pcm_handle)));

        // snd_pcm_hw_params_get_channels(params, &tmp);
        // printf("channels: %i ", tmp);

        // if (tmp == 1)
        //      printf("(mono)\n");
        // else if (tmp == 2)
        //      printf("(stereo)\n");

        // snd_pcm_hw_params_get_rate(params, &tmp, 0);
        // printf("rate: %d bps\n", tmp);

        // printf("seconds: %d\n", seconds);

        // snd_pcm_hw_params_get_period_size(params, &frames, 0);
        mov %r14, %rdi
        lea frames(%rip), %rsi
        xor %edx, %edx
        call snd_pcm_hw_params_get_period_size

        // buff_size = frames * channels * 2;
        mov frames(%rip), %rax
        // collapsed to: buff_size = frames * 4 => frame << 2
        shl $0x2 , %rax
        mov %rax, buff_size(%rip)

        // buff = (char *) malloc(buff_size);
        mov %rax, %rdi
        call malloc

        // buff != nullptr?
        test %rax, %rax
        mov %rax, buff(%rip)
        mov $failed_to_allocate_memory, %rax
        cmovs %rax, %rdi
        js report_failure_exit

        // snd_pcm_hw_params_get_period_time(params, &tmp, NULL);
        mov %r14, %rdi
        lea tmp(%rip), %rsi
        xor %rdx, %rdx
        call snd_pcm_hw_params_get_period_time

        // for (loops = (seconds * 1000000) / tmp; loops > 0; loops--)
        // seconds * 1000000
        mov $1000000, %rax
        lea seconds(%rip), %rdx
        movl (%rdx), %edx
        imull %edx

        lea tmp(%rip), %rcx
        movl (%rcx), %ecx
        cltd
        idivl %ecx

        mov %rax, %rbx
        # is 20 some magical constant? Definitely should check that out.
        addq $20, %rbx

    // here it comes
    loop:
        test %rbx, %rbx
        jz release_resources

        // read(0, buff, buff_size)
        xor %rdi, %rdi // STDIN
        mov buff(%rip), %rsi
        mov buff_size(%rip), %rdx
        call read

        // eax == 0?
        testl %eax, %eax
        mov $early_end, %rax
        cmovz %rax, %rdi
        jz report_failure_exit

        // snd_pcm_writei(pcm_handle, buff, frames)
        mov pcm_handle(%rip), %rdi
        mov buff(%rip), %rsi
        lea frames(%rip), %rdx
        movl (%rdx), %edx
        call snd_pcm_writei

        // eax == -EPIPE?
        cmp $-32, %eax
        je prepare_playback
        testl %eax, %eax
        mov $failed_to_write_to_pcm_device, %rax
        cmovs %rax, %rdi
        js report_failure_exit

    cmp_and_loop:
        decl %ebx
        jmp loop

    prepare_playback:
        // snd_pcm_prepare(pcm_handle)
        mov $starting_playback, %rdi
        call puts
        mov pcm_handle(%rip), %rdi
        call snd_pcm_prepare
        jmp cmp_and_loop


    release_resources:
        // snd_pcm_drain(pcm_handle)
        mov $releasing_resources, %rdi
        call puts
        mov pcm_handle(%rip), %rdi
        call snd_pcm_drain

        // snd_pcm_close(pcm_handle)
        mov pcm_handle(%rip), %rdi
        call snd_pcm_close

        mov buff(%rip), %rdi
        call free

        jmp _exit

//       mov $params, %rdi
//        lea (%rdi), %rdi
//        call snd_pcm_hw_params_alloca

    setup_params:
        endbr64
        mov 24(%rbp), %rdi
        call atoi
        mov %rax, rate(%rip)
        mov 32(%rbp), %rdi
        call atoi
        mov %rax, channels(%rip)
        mov 40(%rbp), %rdi
        call atoi
        mov %rax, seconds(%rip)
        ret

    report_failure_exit:
        xor %rax, %rax
        call printf
        jmp _exit

    success:
        jmp _exit

    _exit:
	    popq %rbx
	    popq %r12
	    popq %r13
        popq %r14
        popq %r15
        popq %rbp
        add $624, %rsp
        xor %rdi, %rdi

        call exit

