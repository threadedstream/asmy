#include <stdio.h>



/*
assembly-to-C transpiling

 f2:
        movsx   rax, esi
        push    rbp
        xor     r8d, r8d
        lea     rcx, [rdi+rax*4]
        lea     eax, [rdx+1]
        push    rbx
        mov     ebp, DWORD PTR [rcx]
.L2:
        mov     ebx, DWORD PTR [rcx+4+r8]
        inc     esi
        cmp     ebx, ebp
        jg      .L3
        cmp     esi, edx
        jg      .L3
.L4:
        add     r8, 4
        jmp     .L2
.L3:
        movsx   r9, eax
        lea     r10, [rdi-4+r9*4]
.L6:
        mov     r9, r10
        sub     r10, 4
        mov     r11d, DWORD PTR [r10+4]
        dec     eax
        cmp     r11d, ebp
        jg      .L6
        cmp     esi, eax
        jge     .L7
        xor     r11d, ebx
        mov     DWORD PTR [rcx+4+r8], r11d
        xor     r11d, DWORD PTR [r9]
        mov     DWORD PTR [r9], r11d
        xor     DWORD PTR [rcx+4+r8], r11d
        jmp     .L4
.L7:
        xor     r11d, DWORD PTR [rcx]
        mov     DWORD PTR [rcx], r11d
        xor     r11d, DWORD PTR [r9]
        mov     DWORD PTR [r9], r11d
        xor     DWORD PTR [rcx], r11d
        pop     rbx
        pop     rbp
        ret

f1:
        push    r13
        push    r12
        mov     r12d, edx
        push    rbp
        mov     rbp, rdi
        push    rbx
        mov     ebx, esi
        push    rcx
.L12:
        cmp     ebx, r12d
        jge     .L10
        mov     esi, ebx
        mov     edx, r12d
        mov     rdi, rbp
        call    f2
        lea     edx, [rax-1]
        mov     r13d, eax
        mov     esi, ebx
        mov     rdi, rbp
        lea     ebx, [r13+1]
        call    f1
        jmp     .L12
.L10:
        pop     rax
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        ret
 */

void f2(int *rdi, int esi, int edx, int *rcx) {
    int ebx = 0;
    int rax = esi;
    int r8d = 0;
    int *rcx = &(*(rdi+(rax*4)));
    rax = edx + 1;
    int ebp = *rcx;

    L2:
    ebx = *(rcx + 4 + r8d);
    esi++;
    if (ebx > ebp) {
        goto L3;
    }
    if (esi > edx) {
        goto L3;
    }

    L4:
    r8d += 4;
    goto L2;


    L3:
    int r9 = eax;
    int r10 = &(*(rdi-4+r9*4));


}

int main(int argc, const char* argv[]) {

    return 0;
}