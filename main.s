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
	.string	"Could not initialize socket"
	.align 8
.LC1:
	.string	"Successfully initialized socket\n"
.LC2:
	.string	"Binding on localhost...\n"
.LC3:
	.string	"Could not bind"
	.align 8
.LC4:
	.string	"Successfully bound on localhost\n"
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
	sub	rsp, 64
	mov	DWORD PTR -52[rbp], edi
	mov	QWORD PTR -64[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	mov	DWORD PTR -36[rbp], 0
	mov	QWORD PTR -32[rbp], 0
	mov	QWORD PTR -24[rbp], 0
	mov	WORD PTR -32[rbp], 2
	mov	edx, 0
	mov	esi, 1
	mov	edi, 2
	call	socket@PLT
	mov	DWORD PTR -36[rbp], eax
	cmp	DWORD PTR -36[rbp], -1
	jne	.L3
	lea	rdi, .LC0[rip]
	call	panic
.L3:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC1[rip]
	call	fwrite@PLT
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 24
	mov	esi, 1
	lea	rdi, .LC2[rip]
	call	fwrite@PLT
	lea	rcx, -32[rbp]
	mov	eax, DWORD PTR -36[rbp]
	mov	edx, 16
	mov	rsi, rcx
	mov	edi, eax
	call	bind@PLT
	cmp	eax, -1
	jne	.L4
	lea	rdi, .LC3[rip]
	call	panic
.L4:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC4[rip]
	call	fwrite@PLT
	mov	eax, 0
	mov	rdx, QWORD PTR -8[rbp]
	xor	rdx, QWORD PTR fs:40
	je	.L6
	call	__stack_chk_fail@PLT
.L6:
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
