FLAGS=-S -masm=intel
NASM_X64_FLAGS=-f elf64 
NASM_X32_FLAGS=-f elf32
LINKER_X32_FLAGS=-m elf_i386 
LINKER_X64_FLAGS=-g -dynamic-linker /lib64/ld-linux-x86-64.so.2 
all:
	gcc main.c -o main

main.o: main.c
	gcc main.c $(FLAGS) -o main.o

main: main.o
	ld main.o -o main 

main.s: main.c
	gcc $(FLAGS) -o main.s main.c

socket32.o: socket.asm
	nasm $(NASM_X32_FLAGS) -o socket32.o socket.asm

socket32: socket32.o
	ld $(LINKER_X32_FLAGS) -o socket32 socket32.o

socket64.o: socket.asm
	nasm $(NASM_X64_FLAGS) -o socket64.o socket.asm

socket64: socket64.o
	ld $(LINKER_X64_FLAGS) -o socket -lc socket64.o

clean:
	rm -rf main.s main.o 