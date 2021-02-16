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
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n;Connection: Keep-Alive\r\n\r\n %s"
.LC2:
	.string	"127.0.0.1"
.LC3:
	.string	"%ld\n"
.LC4:
	.string	"Could not initialize socket\n"
	.align 8
.LC5:
	.string	"Successfully initialized socket\n"
.LC6:
	.string	"Binding on localhost...\n"
.LC7:
	.string	"Could not bind\n"
	.align 8
.LC8:
	.string	"Successfully bound on localhost\n"
	.align 8
.LC9:
	.string	"Waiting for someone to connect...\n"
.LC10:
	.string	"Failed to listen\n"
.LC11:
	.string	"Failed to accept the client\n"
.LC12:
	.string	"Just connected: %u:%u"
	.align 8
.LC13:
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
	mov	DWORD PTR -92[rbp], 0
	mov	DWORD PTR -88[rbp], 5
	mov	DWORD PTR -100[rbp], 0
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
	mov	DWORD PTR -100[rbp], 16
	mov	WORD PTR -64[rbp], 2
	lea	rdi, .LC2[rip]
	call	inet_addr@PLT
	mov	DWORD PTR -60[rbp], eax
	mov	edi, 8000
	call	htons@PLT
	mov	WORD PTR -62[rbp], ax
	mov	esi, 16
	lea	rdi, .LC3[rip]
	mov	eax, 0
	call	printf@PLT
	mov	edx, 0
	mov	esi, 1
	mov	edi, 2
	call	socket@PLT
	mov	DWORD PTR -92[rbp], eax
	cmp	DWORD PTR -92[rbp], -1
	jne	.L3
	lea	rdi, .LC4[rip]
	call	panic
.L3:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC5[rip]
	call	fwrite@PLT
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 24
	mov	esi, 1
	lea	rdi, .LC6[rip]
	call	fwrite@PLT
	lea	rcx, -64[rbp]
	mov	eax, DWORD PTR -92[rbp]
	mov	edx, 16
	mov	rsi, rcx
	mov	edi, eax
	call	bind@PLT
	cmp	eax, -1
	jne	.L4
	lea	rdi, .LC7[rip]
	call	panic
.L4:
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 32
	mov	esi, 1
	lea	rdi, .LC8[rip]
	call	fwrite@PLT
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 34
	mov	esi, 1
	lea	rdi, .LC9[rip]
	call	fwrite@PLT
	mov	edx, DWORD PTR -88[rbp]
	mov	eax, DWORD PTR -92[rbp]
	mov	esi, edx
	mov	edi, eax
	call	listen@PLT
	cmp	eax, -1
	jne	.L5
	lea	rdi, .LC10[rip]
	call	panic
.L5:
	mov	DWORD PTR -96[rbp], 0
	jmp	.L6
.L9:
	lea	rdx, -100[rbp]
	lea	rcx, -48[rbp]
	mov	eax, DWORD PTR -92[rbp]
	mov	rsi, rcx
	mov	edi, eax
	call	accept@PLT
	mov	edx, DWORD PTR -96[rbp]
	movsx	rdx, edx
	mov	DWORD PTR -32[rbp+rdx*4], eax
	mov	eax, DWORD PTR -96[rbp]
	cdqe
	mov	eax, DWORD PTR -32[rbp+rax*4]
	cmp	eax, -1
	jne	.L7
	lea	rdi, .LC11[rip]
	call	panic
.L7:
	movzx	eax, WORD PTR -46[rbp]
	movzx	ecx, ax
	mov	edx, DWORD PTR -44[rbp]
	mov	rax, QWORD PTR stdout[rip]
	lea	rsi, .LC12[rip]
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT
	mov	rax, QWORD PTR -72[rbp]
	mov	rdi, rax
	call	strlen@PLT
	mov	rdx, rax
	mov	eax, DWORD PTR -96[rbp]
	cdqe
	mov	eax, DWORD PTR -32[rbp+rax*4]
	mov	rsi, QWORD PTR -72[rbp]
	mov	ecx, 0
	mov	edi, eax
	call	send@PLT
	cmp	rax, -1
	jne	.L8
	lea	rdi, .LC13[rip]
	call	panic
.L8:
	add	DWORD PTR -96[rbp], 1
.L6:
	cmp	DWORD PTR -84[rbp], 0
	jne	.L9
	mov	eax, 0
	mov	rcx, QWORD PTR -8[rbp]
	xor	rcx, QWORD PTR fs:40
	je	.L11
	call	__stack_chk_fail@PLT
.L11:
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
