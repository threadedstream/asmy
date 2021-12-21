FLAGS=-S -masm=intel
NASM_X64_FLAGS=-f elf64 
NASM_X32_FLAGS=-f elf32
LINKER_X32_FLAGS=-m elf_i386 
LINKER_X64_FLAGS=-g -dynamic-linker /lib64/ld-linux-x86-64.so.2 

webserver.o: main.c
	gcc webserver.c $(FLAGS) -o webserver.o

webserver: main.o
	ld webserver.o -o webserver 

webserver.s: main.c
	gcc $(FLAGS) -o webserver.s webserver.c

socket32.o: webserver.asm
	nasm $(NASM_X32_FLAGS) -o webserver32.o webserver.asm

socket32: socket32.o
	ld $(LINKER_X32_FLAGS) -o webserver32 webserver32.o

socket64.o: webserver.asm
	nasm $(NASM_X64_FLAGS) -o webserver64.o webserver.asm

socket64: socket64.o
	ld $(LINKER_X64_FLAGS) -o webserver -lc webserver64.o

clean:
	rm -rf webserver.s webserver.o 