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
	.string	"<h1>Hello, Assembly Hero</h1>"
	.align 8
.LC1:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: Keep-Alive\r\n\r\n %s"
.LC2:
	.string	"0.0.0.0"
.LC3:
	.string	"Could not initialize socket\n"
.LC4:
	.string	"%d\n"
.LC5:
	.string	"setsockopt failed\n"
	.align 8
.LC6:
	.string	"Successfully initialized socket\n"
.LC7:
	.string	"Binding on localhost...\n"
.LC8:
	.string	"Could not bind\n"
	.align 8
.LC9:
	.string	"Successfully bound on localhost\n"
	.align 8
.LC10:
	.string	"Waiting for someone to connect...\n"
.LC11:
	.string	"Failed to listen\n"
.LC12:
	.string	"Failed to accept the client\n"
.LC13:
	.string	"Just connected: %u:%u"
	.align 8
.LC14:
	.string	"Failed to send data to the client"
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
	add	rsp, -128
	mov	DWORD PTR -116[rbp], edi
	mov	QWORD PTR -128[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	mov	DWORD PTR -96[rbp], 0
	mov	DWORD PTR -92[rbp], 5
	mov	DWORD PTR -108[rbp], 0
	mov	DWORD PTR -88[rbp], 0
	lea	rax, .LC0[rip]
	mov	QWORD PTR -80[rbp], rax
	mov	rdx, QWORD PTR -80[rbp]
	mov	rax, QWORD PTR -72[rbp]
	lea	rsi, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	sprintf@PLT
	mov	DWORD PTR -84[rbp], 1
	mov	QWORD PTR -64[rbp], 0
	mov	QWORD PTR -56[rbp], 0
	mov	QWORD PTR -48[rbp], 0
	mov	QWORD PTR -40[rbp], 0
	mov	DWORD PTR -108[rbp], 16
	mov	WORD PTR -64[rbp], 2
	lea	rdi, .LC2[rip]
	call	inet_addr@PLT
	mov	DWORD PTR -60[rbp], eax
	mov	edi, 8000
	call	htons@PLT
	mov	WORD PTR -62[rbp], ax
	mov	edx, 0
	mov	esi, 1
	mov	edi, 2
	call	socket@PLT
	mov	DWORD PTR -96[rbp], eax
	cmp	DWORD PTR -96[rbp], -1
	jne	.L3
	lea	rdi, .LC3[rip]
	call	panic
.L3:
	mov	DWORD PTR -104[rbp], 1
	lea	rdx, -104[rbp]
	mov	eax, DWORD PTR -96[rbp]
	mov	r8d, 4
	mov	rcx, rdx
	mov	edx, 2
	mov	esi, 1
	mov	edi, eax
	call	setsockopt@PLT
	mov	DWORD PTR -88[rbp], eax
	cmp	DWORD PTR -88[rbp], -1
	jne	.L4
	mov	eax, DWORD PTR -88[rbp]
	mov	esi, eax
	lea	rdi, .LC4[rip]
	mov	eax, 0
	call	printf@PLT
	lea	rdi, .LC5[rip]
	call	panic
.L4:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC6[rip]
	call	fwrite@PLT
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 24
	mov	esi, 1
	lea	rdi, .LC7[rip]
	call	fwrite@PLT
	lea	rcx, -64[rbp]
	mov	eax, DWORD PTR -96[rbp]
	mov	edx, 16
	mov	rsi, rcx
	mov	edi, eax
	call	bind@PLT
	cmp	eax, -1
	jne	.L5
	lea	rdi, .LC8[rip]
	call	panic
.L5:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC9[rip]
	call	fwrite@PLT
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 34
	mov	esi, 1
	lea	rdi, .LC10[rip]
	call	fwrite@PLT
	mov	edx, DWORD PTR -92[rbp]
	mov	eax, DWORD PTR -96[rbp]
	mov	esi, edx
	mov	edi, eax
	call	listen@PLT
	cmp	eax, -1
	jne	.L6
	lea	rdi, .LC11[rip]
	call	panic
.L6:
	mov	DWORD PTR -100[rbp], 0
	jmp	.L7
.L10:
	lea	rdx, -108[rbp]
	lea	rcx, -48[rbp]
	mov	eax, DWORD PTR -96[rbp]
	mov	rsi, rcx
	mov	edi, eax
	call	accept@PLT
	mov	edx, DWORD PTR -100[rbp]
	movsx	rdx, edx
	mov	DWORD PTR -32[rbp+rdx*4], eax
	mov	eax, DWORD PTR -100[rbp]
	cdqe
	mov	eax, DWORD PTR -32[rbp+rax*4]
	cmp	eax, -1
	jne	.L8
	lea	rdi, .LC12[rip]
	call	panic
.L8:
	movzx	eax, WORD PTR -46[rbp]
	movzx	ecx, ax
	mov	edx, DWORD PTR -44[rbp]
	mov	rax, QWORD PTR stdout[rip]
	lea	rsi, .LC13[rip]
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT
	mov	rax, QWORD PTR -72[rbp]
	mov	rdi, rax
	call	strlen@PLT
	mov	rdx, rax
	mov	eax, DWORD PTR -100[rbp]
	cdqe
	mov	eax, DWORD PTR -32[rbp+rax*4]
	lea	rcx, -48[rbp]
	mov	rsi, QWORD PTR -72[rbp]
	mov	r9d, 16
	mov	r8, rcx
	mov	ecx, 0
	mov	edi, eax
	call	sendto@PLT
	cmp	rax, -1
	jne	.L9
	lea	rdi, .LC14[rip]
	call	panic
.L9:
	add	DWORD PTR -100[rbp], 1
.L7:
	cmp	DWORD PTR -84[rbp], 0
	jne	.L10
	mov	eax, 0
	mov	rcx, QWORD PTR -8[rbp]
	xor	rcx, QWORD PTR fs:40
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
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
