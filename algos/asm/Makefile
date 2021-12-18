COMPILER=gcc
CLANG_COMPILER=clang
COMPILER_FLAGS_64=-m64 -c
COMPILER_FLAGS_32=-m32 -c
LINKER=ld
LINKER_FLAGS_64=-g -dynamic-linker /lib64/ld-linux-x86-64.so.2
LINKER_FLAGS_32=-m elf_i386 -g -dynamic-linker /lib/ld-linux.so.2


.PHONY: all

all: %_c
	./$<

# C sources
%_c: %.c
	$(CLANG_COMPILER) -fPIC -o $@ $< && ./$@

# 64-bit asm sources
%_64.o: %_64.S
	$(COMPILER) $(COMPILER_FLAGS_64) -o $@ -c $<

%_64: %_64.o
	$(LINKER) $(LINKER_FLAGS_64) -o $@ -lc $<

# 32-bit asm sources
%_32.o: %_32.S
	$(COMPILER) $(COMPILER_FLAGS_32) -o $@ $<

%_32: %_32.o
	$(LINKER) $(LINKER_FLAGS_32) -o $@ -lc $<

# Get rid of garbage
clean:
	rm -rf *_32.o *_32 *_64.o *_64 *_c

.PHONY: clean
