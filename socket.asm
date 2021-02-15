
; arg0 -> rdi, arg1 -> rsi, arg2 -> rdx, arg3 -> r10 arg4 -> r8
section .data
    sock_success: db  "Socket has been successfully initialized",0xa, 0
    sock_fail:    db  "Failed to initialize a socket", 0xa, 0x0
    bind_success: db  "Successfully bound on localhost", 0xa, 0x0
    bind_fail:    db  "Failed to bind on localhost", 0xa, 0x0

section .bss
    sockfd: resd 1

%macro print 1
    push rdi

    mov  rdi, %1
    call _print

    pop rdi

%endmacro

%macro fail 1
    print %1

    jmp   _exit

%endmacro

section .text
    global _start

    _start:
        push rbp
        mov  rbp, rsp
        mov rdi, 0x2 ;AF_INET
        mov rsi, 0x1 ;SOCK_STREAM
        mov rdx, 0x0 ;socket() decides what protocol is most suitable
        call _initsock ;initializing socket
        call _exit

    _initsock:
        push rdx 
        push rsi
        push rdi
        mov  rax, 0x29
        syscall
        pop rdi
        pop rsi
        pop rdx
        cmp  rax, -1
        jne  _success_sock
        fail sock_fail
        ret

    _bind:  
        push DWORD 0x0
        push DWORD 0x0
        push DWORD 0x7F000001
        push DWORD 0x50
        push DWORD 0x2
        mov  esi, esp
        mov  edi,DWORD [sockfd]
        mov  rdx, 0x10
        mov  rax, 0x31
        syscall
        add  rsp, 20 ; freeing up the stack
        cmp  rax, -1
        jne  _success_bind
        fail bind_fail
        ret

    _success_sock:
        print sock_success
        call _bind
        ret

    _success_bind:
        print bind_success
        jmp   _exit
        ret

    _print:
        push rdi
        call _strlen
        pop  rdi
        mov rsi, rdi
        mov rax, 0x1
        mov rdi, 0x1
        syscall
        ret

    _strlen:
        xor rcx, rcx
        not rcx
        xor al, al
        cld
        repnz scasb
        not rcx
        dec rcx
        mov rdx, rcx
        ret

    _exit:
        xor rdi, rdi
        mov rax, 0x3c
        syscall
        mov rsp, rbp ; Restore stack pointer
        pop rbp ;Pop base pointer
        ret



