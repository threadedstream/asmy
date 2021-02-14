
; arg0 -> rdi, arg1 -> rsi, arg2 -> rdx, arg3 -> r10 arg4 -> r8
section .data
    success: db  "Socket has been successfully initialized",0xa, 0
    failure: db  "Failed to initialize a socket", 0xa, 0x0

section .bss
    sockfd: resb 1

section .text
    global _start

    _start:
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
        call _checkstat
        pop rdi
        pop rsi
        pop rdx
        ret

    _checkstat:
        cmp  rax, -1
        je   _fail
        call _success
        ret

    _fail:
        xor rdi, rdi
        mov rdi, failure
        call _printfailure
        ret

    _success:
        xor rdi, rdi
        mov rdi, success
        call _printsuccess
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

    _printsuccess:
        push rdi
        call _strlen
        pop  rdi
        mov rsi, success
        mov rax, 0x1
        mov rdi, 0x1
        syscall
        ret

    _printfailure:
        push rdi
        call _strlen
        pop  rdi
        mov rsi, failure
        mov rax, 0x1
        mov rdi, 0x1
        syscall
        ret

    _exit:
        xor rdi, rdi
        mov rax, 0x3c
        syscall
        ret



