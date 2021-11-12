
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
    .quad 0

params:
    .quad 0



.section .text
    .globl _start

    _start:
        # opening a device
        mov $pcm_handle, %rdi
        lea (%rdi), %rdi
        mov $pcm_device, %rsi
        mov $0, %edx
        mov $0, %ecx
        call snd_pcm_open
        cmp $0, %eax

        // save return value in pcm
        mov %eax, pcm(%rip)
        mov $failed_to_open_device_fmt, %rax
        cmovl %rax, %rdi
        jl report_failure_exit

        // getting the size of snd_pcm_hw_params struct
        call snd_pcm_hw_params_sizeof

        // params = alloca(size_t size)
        sub %rax, %rsp
        mov %rsp, params(%rip)

        // memset(params, 0, snd_pcm_hw_params_sizeof())
        mov $params, %rdi
        mov $0, %rsi
        mov %eax, %edx
        call memset

        // snd_pcm_hw_params_any(pcm_handle, params);
        mov $pcm_handle, %rdi
        mov $params, %rsi
        call snd_pcm_hw_params_any


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
        xor %rdi, %rdi
        call exit

