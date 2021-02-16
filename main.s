	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	panic
	.type	panic, @function
panic:
.LFB6:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR -8[rbp], rdi
	mov	rax, QWORD PTR stderr[rip]
	mov	rdx, QWORD PTR -8[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT
	mov	edi, -1
	call	exit@PLT
	.cfi_endproc
.LFE6:
	.size	panic, .-panic
	.section	.rodata
.LC0:
	.string	"127.0.0.1"
.LC1:
	.string	"Could not initialize socket\n"
	.align 8
.LC2:
	.string	"Successfully initialized socket\n"
.LC3:
	.string	"Binding on localhost...\n"
.LC4:
	.string	"Could not bind\n"
	.align 8
.LC5:
	.string	"Successfully bound on localhost\n"
	.align 8
.LC6:
	.string	"Waiting for someone to connect...\n"
.LC7:
	.string	"Failed to listen\n"
.LC8:
	.string	"Failed to accept the client\n"
.LC9:
	.string	"Just connected: %u:%u"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 112
	mov	DWORD PTR -100[rbp], edi
	mov	QWORD PTR -112[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	mov	DWORD PTR -76[rbp], 0
	mov	DWORD PTR -72[rbp], 5
	mov	DWORD PTR -84[rbp], 0
	mov	DWORD PTR -68[rbp], 1
	mov	QWORD PTR -64[rbp], 0
	mov	QWORD PTR -56[rbp], 0
	mov	QWORD PTR -48[rbp], 0
	mov	QWORD PTR -40[rbp], 0
	mov	DWORD PTR -84[rbp], 16
	mov	WORD PTR -64[rbp], 2
	lea	rdi, .LC0[rip]
	call	inet_addr@PLT
	mov	DWORD PTR -60[rbp], eax
	mov	edi, 8000
	call	htons@PLT
	mov	WORD PTR -62[rbp], ax
	mov	edx, 0
	mov	esi, 1
	mov	edi, 2
	call	socket@PLT
	mov	DWORD PTR -76[rbp], eax
	cmp	DWORD PTR -76[rbp], -1
	jne	.L3
	lea	rdi, .LC1[rip]
	call	panic
.L3:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC2[rip]
	call	fwrite@PLT
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 24
	mov	esi, 1
	lea	rdi, .LC3[rip]
	call	fwrite@PLT
	lea	rcx, -64[rbp]
	mov	eax, DWORD PTR -76[rbp]
	mov	edx, 16
	mov	rsi, rcx
	mov	edi, eax
	call	bind@PLT
	cmp	eax, -1
	jne	.L4
	lea	rdi, .LC4[rip]
	call	panic
.L4:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC5[rip]
	call	fwrite@PLT
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 34
	mov	esi, 1
	lea	rdi, .LC6[rip]
	call	fwrite@PLT
	mov	edx, DWORD PTR -72[rbp]
	mov	eax, DWORD PTR -76[rbp]
	mov	esi, edx
	mov	edi, eax
	call	listen@PLT
	cmp	eax, -1
	jne	.L5
	lea	rdi, .LC7[rip]
	call	panic
.L5:
	mov	DWORD PTR -80[rbp], 0
	jmp	.L6
.L8:
	lea	rdx, -84[rbp]
	lea	rcx, -48[rbp]
	mov	eax, DWORD PTR -76[rbp]
	mov	rsi, rcx
	mov	edi, eax
	call	accept@PLT
	mov	edx, DWORD PTR -80[rbp]
	movsx	rdx, edx
	mov	DWORD PTR -32[rbp+rdx*4], eax
	mov	eax, DWORD PTR -80[rbp]
	cdqe
	mov	eax, DWORD PTR -32[rbp+rax*4]
	cmp	eax, -1
	jne	.L7
	lea	rdi, .LC8[rip]
	call	panic
.L7:
	add	DWORD PTR -80[rbp], 1
	movzx	eax, WORD PTR -46[rbp]
	movzx	ecx, ax
	mov	edx, DWORD PTR -44[rbp]
	mov	rax, QWORD PTR stdout[rip]
	lea	rsi, .LC9[rip]
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT
.L6:
	cmp	DWORD PTR -68[rbp], 0
	jne	.L8
	mov	eax, 0
	mov	rsi, QWORD PTR -8[rbp]
	xor	rsi, QWORD PTR fs:40
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
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
