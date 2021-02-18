
; arg0 -> rdi, arg1 -> rsi, arg2 -> rdx, arg3 -> r10, arg4 -> r8, arg5 -> r9
section .data
    ;fails 
    sock_fail:    db  "Failed to initialize a socket", 0xa, 0x0
    bind_fail:    db  "Failed to bind on localhost", 0xa, 0x0
    accept_fail: db "Failed to accept a client", 0xa, 0x0
    listen_fail: db "Failed to listen", 0xa, 0x0
    fail_send: db "Failed to send message to the client", 0xa,0x0
    fail_close_socket: db "Failed to close accept socket", 0xa, 0x0
    setsockopt_fail: db "setsockopt failed", 0xa, 0x0
    read_fail: db "Failed to read data from the client", 0xa, 0x0

    ;success
    sock_success: db  "Socket has been successfully initialized",0xa, 0
    bind_success: db  "Successfully bound on localhost", 0xa, 0x0
    accept_success: db "Client connected",0xa, 0x0
    listen_success: db "Waiting for someone to connect...", 0xa, 0x0

    ;misc
    sock_info: db "Sockfd: %d", 0xa, 0x0
    client_info: db "Clientfd: %d", 0xa, 0x0
    bind_code: db  "Bind code: %d", 0xa, 0x0
    exit_message: db "Exiting from an application",0xa,0x0
    response: db "HTTP/1.1 200 OK",0xd, 0xa,"Content-Type: text/html",0xd, 0xa, "Connection: Close;",0xd,0xa,0xd,0xa,"<h1>Hello, Assembly Hero!</h1>", 0x0
    request_msg: db "Request from client: %s\n"
    start_write: db "write start!",0xa,0x0
    end_write: db "write end!", 0xa, 0x0

    ;numerical definitions
    backlog: dw 0x5
    client_size: dd 0x10

section .bss
    sockfd:         resd 1
    clientfd:       resd 1
    client_addr:    resq 2
    request:        resb 512

%define SIGINT 2


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
    extern strlen
    extern signal

    global _start

    _start:
        add  rsp, 12
        mov  rdi, 0x2 ;AF_INET
        mov  rsi, 0x1 ;SOCK_STREAM
        mov  rdx, 0x0 ;socket() decides what protocol is most suitable
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

    _setsockopt:
        push DWORD 0x1
        lea  r10, [rsp]
        mov  edi, DWORD [sockfd]
        mov  esi, DWORD 0x1
        mov  edx, DWORD 0x2
        mov  r8d, DWORD 0x4
        mov  rax, 0x36
        syscall
        add rsp, 4 ;freeing up stack
        cmp rax, 0
        je  _bind
        fail setsockopt_fail
        ret

    _bind:  
        push DWORD 0x0 
        push DWORD 0x0 ;0.0.0.0 
        push WORD  0x401F ;port 8000
        push WORD  0x2 ;AF_INET
        mov rsi, rsp
        mov rax, 0x31
        mov rdx, 0x10
        mov rdi, [sockfd]
        syscall
        add  rsp, 12
        cmp  rax, 0
        je  _success_bind
        fail bind_fail
        ret

    _success_sock:
        mov   [sockfd], rax
        print sock_success
        call  _setsockopt
        ret

    _success_bind:
        print bind_success
        mov   rax, 0x32
        mov   edi, DWORD [sockfd] ;socket fd
        mov   esi, DWORD backlog ;backlog value 
        syscall
        cmp  rax, 0;Is it failed?
        je   _success_listen ;Proceed with the execution if not
        fail listen_fail
        ret

    _success_listen:
        print listen_success
        mov   r15d, DWORD [backlog] 
        jmp  _accept_loop
        ret        

    _accept_loop:
        mov   rax, 0x2b ;accept's syscall number
        mov   rdi, QWORD [sockfd] ;file descriptor of the socket
        mov   rsi, client_addr ;address of client_address structure
        lea   rdx, [client_size] ;size of client_address structure
        syscall
        cmp   rax, 0
        jge   _read_request  
        fail  accept_fail
        ret


    _read_request:
        mov   [clientfd], rax ;*clientfd = rax
        mov   rax, 0x00 ;read syscall
        mov   rdi, [clientfd]
        mov   rsi, request
        mov   rdx, 0x100
        shl   rdx, 1
        syscall
        cmp   rax, -1
        jg    _print_request  
        fail  read_fail
        ret

    _print_request:
        mov  rdi, request_msg
        mov  rsi, request
        mov  rax, 0
        call printf
        xor  rax, rax
        xor  rdi, rdi
        xor  rsi, rsi
        jmp  _write_data
        ret

    _write_data:
        print start_write
        xor   rdi, rdi
        mov   rdi, response
        call  strlen
        xor   rdi, rdi
        mov   rdx, rax
        mov   rax, 0x2c
        mov   rdi, [clientfd]
        mov   rsi, response
        mov   r10d, DWORD 0x4
        mov   r8,  client_addr
        mov   r9d, 0x10
        syscall
        print end_write
        cmp   rax, 0
        jge   _accept_loop
        fail  fail_send
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

    _close_socket:
        mov rdi, [sockfd]
        mov rax, 0x03
        syscall
        ret

    _exit:
        print exit_message
        call  _close_socket
        xor rdi, rdi
        mov rax, 0x3c
        syscall
        ret
