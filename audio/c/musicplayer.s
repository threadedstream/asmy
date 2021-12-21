	.file	"musicplayer.cpp"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"Usage: ./<prog> <rate> <channels> <seconds>"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"default"
	.section	.rodata.str1.8
	.align 8
.LC2:
	.string	"ERROR: Can't open \"%s\" PCM device. %s\n"
	.align 8
.LC3:
	.string	"ERROR: Can't set interleaved mode. %s\n"
	.section	.rodata.str1.1
.LC4:
	.string	"ERROR: Can't set format. %s\n"
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"ERROR: Can't set channels number. %s\n"
	.section	.rodata.str1.1
.LC6:
	.string	"ERROR: Can't set rate. %s\n"
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"ERROR: Can't set hardware parameters. %s\n"
	.section	.rodata.str1.1
.LC8:
	.string	"PCM name: '%s'\n"
.LC9:
	.string	"PCM state: %s\n"
.LC10:
	.string	"channels: %i "
.LC11:
	.string	"(mono)"
.LC12:
	.string	"(stereo)"
.LC13:
	.string	"rate: %d bps\n"
.LC14:
	.string	"seconds: %d\n"
.LC15:
	.string	"Early end of file."
.LC16:
	.string	"XRUN."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB51:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	cmpl	$3, %edi
	jle	.L20
	movq	8(%rsi), %rdi
	movq	%rsi, %rbx
	xorl	%esi, %esi
	movl	$10, %edx
	leaq	.LC1(%rip), %r14
	call	strtol@PLT
	movq	16(%rbx), %rdi
	xorl	%esi, %esi
	movl	$10, %edx
	movl	%eax, -76(%rbp)
	call	strtol@PLT
	movq	24(%rbx), %rdi
	xorl	%esi, %esi
	movl	$10, %edx
	movq	%rax, %r13
	movl	%eax, %r12d
	call	strtol@PLT
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	leaq	-72(%rbp), %rdi
	movq	%r14, %rsi
	movl	%eax, -84(%rbp)
	movq	%rax, %rbx
	call	snd_pcm_open@PLT
	testl	%eax, %eax
	js	.L21
.L4:
	call	snd_pcm_hw_params_sizeof@PLT
	addq	$23, %rax
	andq	$-16, %rax
	subq	%rax, %rsp
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
	js	.L22
.L5:
	movq	-72(%rbp), %rdi
	movl	$2, %edx
	movq	%r14, %rsi
	call	snd_pcm_hw_params_set_format@PLT
	testl	%eax, %eax
	js	.L23
.L6:
	movq	-72(%rbp), %rdi
	movl	%r12d, %edx
	movq	%r14, %rsi
	call	snd_pcm_hw_params_set_channels@PLT
	testl	%eax, %eax
	js	.L24
.L7:
	movq	-72(%rbp), %rdi
	xorl	%ecx, %ecx
	leaq	-76(%rbp), %rdx
	movq	%r14, %rsi
	call	snd_pcm_hw_params_set_rate_near@PLT
	testl	%eax, %eax
	js	.L25
.L8:
	movq	-72(%rbp), %rdi
	movq	%r14, %rsi
	call	snd_pcm_hw_params@PLT
	testl	%eax, %eax
	js	.L26
.L9:
	movq	-72(%rbp), %rdi
	leaq	-80(%rbp), %r15
	call	snd_pcm_name@PLT
	leaq	.LC8(%rip), %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	call	printf@PLT
	movq	-72(%rbp), %rdi
	call	snd_pcm_state@PLT
	movl	%eax, %edi
	call	snd_pcm_state_name@PLT
	leaq	.LC9(%rip), %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	call	printf@PLT
	movq	%r15, %rsi
	movq	%r14, %rdi
	call	snd_pcm_hw_params_get_channels@PLT
	movl	-80(%rbp), %esi
	leaq	.LC10(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
	movl	-80(%rbp), %eax
	cmpl	$1, %eax
	je	.L27
	cmpl	$2, %eax
	je	.L28
.L11:
	xorl	%edx, %edx
	imull	$1000000, %ebx, %ebx
	movq	%r15, %rsi
	movq	%r14, %rdi
	call	snd_pcm_hw_params_get_rate@PLT
	movl	-80(%rbp), %esi
	leaq	.LC13(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
	movl	-84(%rbp), %esi
	leaq	.LC14(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
	leaq	-64(%rbp), %rsi
	xorl	%edx, %edx
	movq	%r14, %rdi
	call	snd_pcm_hw_params_get_period_size@PLT
	imull	-64(%rbp), %r13d
	addl	%r13d, %r13d
	movslq	%r13d, %r13
	movq	%r13, %rdi
	call	malloc@PLT
	xorl	%edx, %edx
	movq	%r15, %rsi
	movq	%r14, %rdi
	movq	%rax, %r12
	call	snd_pcm_hw_params_get_period_time@PLT
	movl	%ebx, %eax
	xorl	%edx, %edx
	divl	-80(%rbp)
	movl	%eax, %ebx
	testl	%eax, %eax
	jle	.L12
	leaq	.LC16(%rip), %r14
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L14:
	subl	$1, %ebx
	je	.L12
.L15:
	xorl	%edi, %edi
	movq	%r13, %rdx
	movq	%r12, %rsi
	call	read@PLT
	testq	%rax, %rax
	je	.L29
	movq	-64(%rbp), %rdx
	movq	-72(%rbp), %rdi
	movq	%r12, %rsi
	call	snd_pcm_writei@PLT
	cmpl	$-32, %eax
	jne	.L14
	movq	%r14, %rdi
	call	puts@PLT
	movq	-72(%rbp), %rdi
	call	snd_pcm_prepare@PLT
	subl	$1, %ebx
	jne	.L15
.L12:
	movq	-72(%rbp), %rdi
	call	snd_pcm_drain@PLT
	movq	-72(%rbp), %rdi
	call	snd_pcm_close@PLT
	movq	%r12, %rdi
	call	free@PLT
	xorl	%eax, %eax
.L1:
	movq	-56(%rbp), %rdx
	subq	%fs:40, %rdx
	jne	.L30
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L29:
	.cfi_restore_state
	leaq	.LC15(%rip), %rdi
	call	puts@PLT
	xorl	%eax, %eax
	jmp	.L1
.L26:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC7(%rip), %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	call	printf@PLT
	jmp	.L9
.L25:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC6(%rip), %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	call	printf@PLT
	jmp	.L8
.L24:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC5(%rip), %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	call	printf@PLT
	jmp	.L7
.L23:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC4(%rip), %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	call	printf@PLT
	jmp	.L6
.L22:
	movl	$1, %edi
	call	snd_strerror@PLT
	leaq	.LC3(%rip), %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	call	printf@PLT
	jmp	.L5
.L21:
	movl	$1, %edi
	call	snd_strerror@PLT
	movq	%r14, %rsi
	leaq	.LC2(%rip), %rdi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	printf@PLT
	jmp	.L4
.L27:
	leaq	.LC11(%rip), %rdi
	call	puts@PLT
	jmp	.L11
.L28:
	leaq	.LC12(%rip), %rdi
	call	puts@PLT
	jmp	.L11
.L20:
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	orl	$-1, %eax
	jmp	.L1
.L30:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE51:
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
