# Asmy
## How it all started?
While doing house cleaning work and thinking of all possible projects i may devote time to, the idea of developing web server in x64 assembly
almost instantly flashed through my mind. :)

## Some notes
In the very beginning i had an objective to write http server in assembly, but later i thought that 
C version would fit pretty neatly as well. So, it all turned out to be a dual implementation of http server. 
The server is very limited in functionality, so to enable you to thoroughly study its structure and learn some new things about x86-64 convention 
of writing assembly code. 

## How to run it?

In order to make build process less tedious, i've prepared a Makefile that makes all stuff for you. Here's small set of commands:

Build main.c
```bash
  make all
```

Produce main.s 
```bash
  make main.s
```

Build nasm x64
```bash
  make socket64.o && make socket64
```
