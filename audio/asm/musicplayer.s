	.file	"musicplayer.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"default"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"ERROR: Can't open \"%s\" PCM device. %s\n"
	.align 8
.LC2:
	.string	"ERROR: Can't set interleaved mode. %s\n"
	.section	.rodata.str1.1
.LC3:
	.string	"ERROR: Can't set format. %s\n"
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"ERROR: Can't set channels number. %s\n"
	.section	.rodata.str1.1
.LC5:
	.string	"ERROR: Can't set rate. %s\n"
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"ERROR: Can't set harware parameters. %s\n"
	.section	.rodata.str1.1
.LC7:
	.string	"PCM name: '%s'\n"
.LC8:
	.string	"PCM state: %s\n"
.LC9:
	.string	"channels: %i "
.LC10:
	.string	"(mono)"
.LC11:
	.string	"(stereo)"
.LC12:
	.string	"rate: %d bps\n"
.LC13:
	.string	"seconds: %d\n"
.LC14:
	.string	"Early end of file."
.LC15:
	.string	"XRUN."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB69:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	.LC0(%rip), %rsi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	leaq	-72(%rbp), %rdi
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	movl	$44100, -76(%rbp)
	call	snd_pcm_open@PLT
	testl	%eax, %eax
	js	.L25
.L2:
	call	snd_pcm_hw_params_sizeof@PLT
	movq	%rsp, %rcx
	addq	$23, %rax
	movq	%rax, %rdx
	andq	$-4096, %rax
	subq	%rax, %rcx
	andq	$-16, %rdx
	movq	%rcx, %rax
	cmpq	%rax, %rsp
	je	.L4
.L26:
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	cmpq	%rax, %rsp
	jne	.L26
.L4:
	andl	$4095, %edx
	subq	%rdx, %rsp
	testq	%rdx, %rdx
	jne	.L27
.L5:
	call	snd_pcm_hw_params_sizeof@PLT
	leaq	15(%rsp), %r14
	xorl	%esi, %esi
	andq	$-16, %r14
	movq	%rax, %rdx
	movq	%r14, %rdi
	call	memset@PLT
	movq	-72(%rbp), %rdi
	movq	%r14, %rsi
	call	snd_pcm_hw_params_any@PLT
	movq	-72(%rbp), %rdi
	movl	$3, %edx
	movq	%r14, %rsi
	call	snd_pcm_hw_params_set_access@PLT
	testl	%eax, %eax
	jns	.L6
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC2(%rip), %rsi
	movl	$1, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	__printf_chk@PLT
.L6:
	movq	-72(%rbp), %rdi
	movl	$2, %edx
	movq	%r14, %rsi
	call	snd_pcm_hw_params_set_format@PLT
	testl	%eax, %eax
	js	.L28
.L7:
	movq	-72(%rbp), %rdi
	movl	$2, %edx
	movq	%r14, %rsi
	call	snd_pcm_hw_params_set_channels@PLT
	testl	%eax, %eax
	js	.L29
.L8:
	movq	-72(%rbp), %rdi
	xorl	%ecx, %ecx
	leaq	-76(%rbp), %rdx
	movq	%r14, %rsi
	call	snd_pcm_hw_params_set_rate_near@PLT
	testl	%eax, %eax
	js	.L30
.L9:
	movq	-72(%rbp), %rdi
	movq	%r14, %rsi
	call	snd_pcm_hw_params@PLT
	testl	%eax, %eax
	js	.L31
.L10:
	movq	-72(%rbp), %rdi
	leaq	-80(%rbp), %r15
	call	snd_pcm_name@PLT
	leaq	.LC7(%rip), %rsi
	movl	$1, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movq	-72(%rbp), %rdi
	call	snd_pcm_state@PLT
	movl	%eax, %edi
	call	snd_pcm_state_name@PLT
	leaq	.LC8(%rip), %rsi
	movl	$1, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movq	%r15, %rsi
	movq	%r14, %rdi
	call	snd_pcm_hw_params_get_channels@PLT
	movl	-80(%rbp), %edx
	movl	$1, %edi
	xorl	%eax, %eax
	leaq	.LC9(%rip), %rsi
	call	__printf_chk@PLT
	movl	-80(%rbp), %eax
	cmpl	$1, %eax
	je	.L32
	cmpl	$2, %eax
	je	.L33
.L12:
	xorl	%edx, %edx
	movq	%r15, %rsi
	movq	%r14, %rdi
	call	snd_pcm_hw_params_get_rate@PLT
	movl	-80(%rbp), %edx
	movl	$1, %edi
	xorl	%eax, %eax
	leaq	.LC12(%rip), %rsi
	call	__printf_chk@PLT
	movl	$3, %edx
	leaq	.LC13(%rip), %rsi
	xorl	%eax, %eax
	movl	$1, %edi
	call	__printf_chk@PLT
	leaq	-64(%rbp), %rsi
	xorl	%edx, %edx
	movq	%r14, %rdi
	call	snd_pcm_hw_params_get_period_size@PLT
	movl	-64(%rbp), %eax
	leal	0(,%rax,4), %r13d
	movslq	%r13d, %r13
	movq	%r13, %rdi
	call	malloc@PLT
	xorl	%edx, %edx
	movq	%r15, %rsi
	movq	%r14, %rdi
	movq	%rax, %r12
	call	snd_pcm_hw_params_get_period_time@PLT
	movl	-80(%rbp), %ecx
	movl	$3000000, %eax
	xorl	%edx, %edx
	divl	%ecx
	movl	%eax, %ebx
	cmpl	$3000000, %ecx
	ja	.L13
	leaq	.LC15(%rip), %r14
	jmp	.L17
	.p2align 4,,10
	.p2align 3
.L16:
	subl	$1, %ebx
	je	.L13
.L17:
	xorl	%edi, %edi
	movq	%r13, %rdx
	movq	%r12, %rsi
	call	read@PLT
	testq	%rax, %rax
	je	.L34
	movq	-64(%rbp), %rdx
	movq	-72(%rbp), %rdi
	movq	%r12, %rsi
	call	snd_pcm_writei@PLT
	cmpl	$-32, %eax
	jne	.L16
	movq	%r14, %rdi
	call	puts@PLT
	movq	-72(%rbp), %rdi
	call	snd_pcm_prepare@PLT
	subl	$1, %ebx
	jne	.L17
.L13:
	movq	-72(%rbp), %rdi
	call	snd_pcm_drain@PLT
	movq	-72(%rbp), %rdi
	call	snd_pcm_close@PLT
	movq	%r12, %rdi
	call	free@PLT
.L15:
	movq	-56(%rbp), %rax
	xorq	%fs:40, %rax
	jne	.L35
	leaq	-40(%rbp), %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L34:
	.cfi_restore_state
	leaq	.LC14(%rip), %rdi
	call	puts@PLT
	jmp	.L15
.L31:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L10
.L30:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC5(%rip), %rsi
	movl	$1, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L9
.L29:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC4(%rip), %rsi
	movl	$1, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L8
.L28:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC3(%rip), %rsi
	movl	$1, %edi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L7
.L25:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC0(%rip), %rdx
	movl	$1, %edi
	leaq	.LC1(%rip), %rsi
	movq	%rax, %rcx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L2
.L32:
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
	jmp	.L12
.L27:
	orq	$0, -8(%rsp,%rdx)
	jmp	.L5
.L33:
	leaq	.LC11(%rip), %rdi
	call	puts@PLT
	jmp	.L12
.L35:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE69:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
