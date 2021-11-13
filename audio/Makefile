COMPILER=gcc
LINKER=ld
COMPILER_FLAGS_64=-m64 -c
COMPILER_FLAGS_GEN_ASM=-m64 -O2 -S
LINKER_FLAGS_64=-g -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lasound

%: %.c
	$(COMPILER)	$(COMPILER_FLAGS_GEN_ASM) $@.c

#%: %.c
#	$(COMPILER) -fPIC -o $@_exe $@.c -lasound

%: %.S
	$(COMPILER) $(COMPILER_FLAGS_64) $@.S -o $@.o && $(LINKER) $(LINKER_FLAGS_64) -o $@_exe -lc $@.o

clean:
	rm -rf *.o *_exe