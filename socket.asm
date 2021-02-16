
; arg0 -> rdi, arg1 -> rsi, arg2 -> rdx, arg3 -> r10 arg4 -> r8
section .data
    sock_info: db "Sockfd: %d", 0xa, 0x0
    client_info: db "Clientfd: %d", 0xa, 0x0
    sock_success: db  "Socket has been successfully initialized",0xa, 0
    sock_fail:    db  "Failed to initialize a socket", 0xa, 0x0
    bind_success: db  "Successfully bound on localhost", 0xa, 0x0
    bind_code: db  "Bind code: %d", 0xa, 0x0
    bind_fail:    db  "Failed to bind on localhost", 0xa, 0x0
    listen_success: db "Waiting for someone to connect...", 0xa, 0x0
    listen_fail: db "Failed to listen", 0xa, 0x0
    exit_message: db "Exiting from an application",0xa,0x0
    accept_success: db "Client connected",0xa, 0x0
    accept_fail: db "Failed to accept a client", 0xa, 0x0
    backlog: dw 5

section .bss
    sockfd: resd 1
    clientfd: resd 1


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
    extern printf
    extern accept
    extern bind

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
        push DWORD 0x100007F; localhost
        push DWORD 0x401F ;port 8000
        push DWORD 0x2 ; AF_INET
        mov  esi, esp
        mov  rdx, 0x10
        mov  edi, [sockfd]
        call bind
        add  rsp, 20 ; freeing up the stack
        mov  rdi, bind_code
        mov  rsi, rax
        mov  rax, 0
        call printf
        jmp  _exit
        ;cmp  rax, -1
        ;jne  _success_bind
        ;fail bind_fail
        ret

    _success_sock:
        print sock_success
        call _bind
        ret

    _success_bind:
        print bind_success
        mov   rax, 0x32
        mov   edi, DWORD sockfd ;socket fd
        mov   esi, DWORD backlog ;backlog value syscall
        call  accept
        cmp   rax, -1 ;Is it failed?
        jne   _success_listen ;Proceed with the execution if not
        fail  listen_fail
        ret

    _success_listen:
        print listen_success
        mov   r8, [backlog] 
        jmp  _accept_loop
        ret        

    _accept_loop:
        mov   rdi, sockfd
        xor   rsi, 0
        xor   rdx, 0
        call  accept
        cmp   rax, QWORD -1
        jne   _process_client  
        fail  accept_fail
        ret

    _process_client:
        ;print accept_success
        mov   [clientfd], rax
        mov   rdi, client_info
        mov   esi, [clientfd]
        mov   rax, 0 
        call  printf
        dec   r8
        cmp   r8, 0x0
        je    _exit
        jmp   _accept_loop
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
        print exit_message
        xor rdi, rdi
        mov rax, 0x3c
        syscall
        mov rsp, rbp ; Restore stack pointer
        pop rbp ;Pop base pointer
        ret



