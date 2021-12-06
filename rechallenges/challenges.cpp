#include "challenges.h"
#include <iostream>


/*
 https://challenges.re/31/

    __real@3fe0000000000000 DQ 03fe0000000000000r
    __real@3f50624dd2f1a9fc DQ 03f50624dd2f1a9fcr
    __real@3ff0000000000000 DQ 03ff0000000000000r

x$ = 8
f	PROC
	movsdx	xmm2, QWORD PTR __real@3ff0000000000000
	movsdx	xmm5, QWORD PTR __real@3f50624dd2f1a9fc
	movsdx	xmm4, QWORD PTR __real@3fe0000000000000
	movapd	xmm3, xmm0
	npad	4
$LL4@f:
	movapd	xmm1, xmm2
	mulsd	xmm1, xmm2
	subsd	xmm1, xmm3
	cvttsd2si eax, xmm1
	cdq
	xor	eax, edx
	sub	eax, edx
	movd	xmm0, eax
	cvtdq2pd xmm0, xmm0
	comisd	xmm5, xmm0
	ja	SHORT $LN18@f
	movapd	xmm0, xmm3
	divsd	xmm0, xmm2
	addsd	xmm0, xmm2
	movapd	xmm2, xmm0
	mulsd	xmm2, xmm4
	jmp	SHORT $LL4@f
$LN18@f:
	movapd	xmm0, xmm2
	ret	0
f	ENDP

*/

// CONCLUSION: this is an algorithm to compute a square root of a number
double challenge_31_f(double x) {
    double xmm2 = 1.0;
    double xmm5 = 0.001;
    double xmm4 = 0.5;

    double xmm3 = x;

    LL4:
    double xmm1 = (xmm2 * xmm2) - xmm3 ;
    int32_t eax = std::abs((int32_t) xmm1);
    double xmm0 = (double) eax;
    if (xmm5 > xmm0) {
        xmm0 = xmm2;
        return xmm0;
    }

    // 	movapd	xmm0, xmm3
    //	divsd	xmm0, xmm2
    //	addsd	xmm0, xmm2
    xmm0 = (xmm3 / xmm2) + xmm2;
    xmm2 = xmm0;
    xmm2 *= xmm4;
    goto LL4;
}
/////////////////////////////////////////////////////////

/*

https://challenges.re/36/

f1:
	mov	eax, DWORD PTR v1.2084[rip]
	imul	eax, eax, 1664525
	add	eax, 1013904223
	mov	DWORD PTR v1.2084[rip], eax
	and	eax, 8388607
	or	eax, 1073741824
	mov	DWORD PTR [rsp-4], eax
	movss	xmm0, DWORD PTR [rsp-4]
	subss	xmm0, DWORD PTR .LC0[rip]
	ret
f:
	push	rbp
	xor	ebp, ebp
	push	rbx
	xor	ebx, ebx
	sub	rsp, 16
.L6:
	xor	eax, eax
	call	f1
	xor	eax, eax
	movss	DWORD PTR [rsp], xmm0
	call	f1
	movss	xmm1, DWORD PTR [rsp]
	mulss	xmm0, xmm0
	mulss	xmm1, xmm1
	lea	eax, [rbx+1]
	addss	xmm1, xmm0
	movss	xmm0, DWORD PTR .LC1[rip]
	ucomiss	xmm0, xmm1
	cmova	ebx, eax
	add	ebp, 1
	cmp	ebp, 1000000
	jne	.L6
	cvtsi2ss	xmm0, ebx
	unpcklps	xmm0, xmm0
	cvtps2pd	xmm0, xmm0
	mulsd	xmm0, QWORD PTR .LC2[rip]
	divsd	xmm0, QWORD PTR .LC3[rip]
	add	rsp, 16
	pop	rbx
	pop	rbp
	unpcklpd	xmm0, xmm0
	cvtpd2ps	xmm0, xmm0
	ret
v1.2084:
	.long	305419896
.LC0:
	.long	1077936128
.LC1:
	.long	1065353216
.LC2:
	.long	0
	.long	1074790400
.LC3:
	.long	0
	.long	1093567616
*/
double challenge_36_f1() {
    int32_t eax = 305419896;
    eax = eax * 1664525;

    eax = eax + 1013904223;
}




//////////////////////////////////////////////////////////
#define CAST(type, val) reinterpret_cast<type>(val)
#define CAST_TO_INT32P(val) CAST(int32_t*, val)
#define CAST_TO_INT64(val) CAST(int64_t, val)
#define CAST_DER_INT32P(val) *(CAST_TO_INT32P(val))
//////////////////////////////////////////////////////////

/*
 // https://challenges.re/22/

manual transpiling of assembly code into a rough equivalent in C

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

static int64_t rdi;
static int64_t rsi;
static int64_t rdx;
static int64_t rcx;
static int64_t rbp;
static int64_t r8;
static int64_t r9;
static int64_t r10;
static int64_t r11;
static int64_t r12;
static int64_t r13;
static int64_t r14;
static int64_t r15;
static int64_t rax;
static int64_t rbx;



int64_t f2() {
    // rdi - unsorted array
    // rsi - left
    // rdx - right


    // function prolog
    rax = rsi;
    r8 = 0;
    rcx =  rdi + rax*4;

    rax = rdx + 1;
    rbp = CAST_DER_INT32P(rcx);

    // L2
    L2: ;
    rbx = CAST_DER_INT32P(rcx + r8 + 4);
    rsi++;
    if (rbx > rbp) {
        goto L3;
    }
    if (rsi > rdx) {
        goto L3;
    }

    // L4
    L4: ;
    // inc r8, 4
    r8++;
    goto L2;

    // L3
    L3: ;
    r9 = rax;
    r10 = rdi-4+r9*4;

    // L6
    L6: ;
    r9 = r10;
    r10 -= 4;
    r11 = CAST_DER_INT32P(r10+4);
    rax--;

    if (r11 > rbp) {
        goto L6;
    }

    if (rsi >= rax) {
        goto L7;
    }

    r11 ^= rbx;
    CAST_DER_INT32P(rcx+4+r8) = r11;
    r11 ^= CAST_DER_INT32P(r9);
    CAST_DER_INT32P(r9) = r11;
    CAST_DER_INT32P(rcx+4+r8) ^= r11;
    goto L4;

    // L7
    L7: ;
    r11 ^= CAST_DER_INT32P(rcx);
    CAST_DER_INT32P(rcx) = r11;
    r11 ^= CAST_DER_INT32P(r9);
    CAST_DER_INT32P(r9) = r11;
    CAST_DER_INT32P(rcx) ^= r11;
    return rax;

}

int64_t f1() {
    // registers should not accidentally change their values across
    // calls

    // rdi - unsorted array
    // rsi - left
    // rdx - right
    r12 = rdx; // r12 = right
    rbp = rdi; // rbp = unsorted array
    rbx = rsi; // rbx = left
    rax, r13;

    L12: ;
    if (rbx >= r12) { // if (left >= right)
        goto L10;
    }
    rsi = rbx; //
    rdx = r12;
    rdi = rbp;
    rax = f2();

    rdx = rax - 1;
    r13 = rax;
    rsi = rbx;
    rdi = rbp;
    rbx = r13+1;
    f1();
    goto L12;

    L10: ;
    rax = rcx;
    return rax;
}
//////////////////////////////////////////////////////////
