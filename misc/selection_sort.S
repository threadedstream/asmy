# Borrowed (stolen) from https://developer.ibm.com/articles/l-gas-nasm/

.section .data
array:
.byte 89, 10, 67, 1, 4, 27, 12, 34, 86, 3
array_end:
    .equ ARRAY_SIZE, array_end - array
array_fmt:
    .asciz " %d"

usort_str:
    .asciz "unsorted array:"
sort_str:
    .asciz "sorted array:"
newline:
    .asciz "\n"

.extern puts
.extern printf

.section .text
    .globl _start

    _start:
         pushl $usort_str
         call puts
         addl $4, %esp
         pushl $ARRAY_SIZE
         pushl $array
         pushl $array_fmt
         call print_array10
         addl $12, %esp
         pushl $ARRAY_SIZE
         pushl $array
         call sort_routine20
         # Adjust the stack pointer
         addl $8, %esp
         pushl $sort_str
         call puts
         addl $4, %esp
         pushl $ARRAY_SIZE
         pushl $array
         pushl $array_fmt
         call print_array10
         addl $12, %esp
         jmp _exit

    print_array10:
        pushl %ebp
        movl %esp, %ebp
        subl $4, %esp
        movl 8(%ebp), %edx
        movl 12(%ebp), %ebx
        movl 16(%ebp), %ecx
        movl $0, %esi

    push_loop:
        movl %ecx, -4(%ebp)
        movl 8(%ebp), %edx
        xorl %eax, %eax
        movb (%ebx, %esi, 1), %al
        pushl %eax
        pushl %edx
        call printf
        addl $8, %esp
        movl -4(%ebp), %ecx
        incl %esi
        loop push_loop
        pushl $newline
        call printf
        addl $4, %esp
        movl %ebp, %esp
        popl %ebp
        ret

    sort_routine20:
        pushl %ebp
        movl %esp, %ebp
        # Allocate a word of space in stack
        subl $4, %esp
        # Get the address of the array
        movl 8(%ebp), %ebx
        # Store array size
        movl 12(%ebp), %ecx
        decl %ecx
        # Prepare for outer loop here
        xorl %esi, %esi

    outer_loop:
        # This stores the min index
        movl %esi, -4(%ebp)
        movl %esi, %edi
        incl %edi

    inner_loop:
        cmpl $ARRAY_SIZE, %edi
        jge swap_vars
        xorb %al, %al
        movl -4(%ebp), %edx
        movb (%ebx, %edx, 1), %al
        cmpb %al, (%ebx, %edi, 1)
        jge check_next
        movl %edi, -4(%ebp)

    check_next:
        incl %edi
        jmp inner_loop

    swap_vars:
        movl -4(%ebp), %edi
        movb (%ebx, %edi, 1), %dl
        movb (%ebx, %esi, 1), %al
        movb %dl, (%ebx, %esi, 1)
        movb %al, (%ebx, %edi, 1)
        incl %esi
        loop outer_loop
        movl %ebp, %esp
        popl %ebp
        ret

    _exit:
        movl $1, %eax
        movl $0, %ebx
        int $0x80
