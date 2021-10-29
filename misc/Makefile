ASM_NAME=selection_sort
C_NAME=selection_sort
COMPILER=gcc
COMPILER_FLAGS_64=-m64 -c
COMPILER_FLAGS_32=-m32 -c
LINKER=ld
LINKER_FLAGS_64=-g -dynamic-linker /lib64/ld-linux-x86-64.so.2
LINKER_FLAGS_32=-m elf_i386 -g -dynamic-linker /lib/ld-linux.so.2

# 64-bit version
$(ASM_NAME)_64.o: $(ASM_NAME)_64.S
	$(COMPILER) $(COMPILER_FLAGS_64) $(ASM_NAME)_64.S

$(ASM_NAME)_64: $(ASM_NAME)_64.o
	$(LINKER) $(LINKER_FLAGS_64) -o $(ASM_NAME)_64 -lc $(ASM_NAME)_64.o

# 32-bit version
$(ASM_NAME).o: $(ASM_NAME).S
	$(COMPILER) $(COMPILER_FLAGS_32) $(ASM_NAME).S

$(ASM_NAME): $(ASM_NAME).o
	$(LINKER) $(LINKER_FLAGS_32) -o $(ASM_NAME) -lc $(ASM_NAME).o

# C version
$(C_NAME)_c: $(C_NAME).c
	$(COMPILER) -g -o $(C_NAME) $(C_NAME).c

# Get rid of garbage
clean:
	rm -rf $(ASM_NAME).o $(ASM_NAME) $(ASM_NAME)_64.o $(ASM_NAME)_64 $(C_NAME)

