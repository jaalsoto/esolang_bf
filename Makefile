brainfuck: brainfuck.c
	gcc -Wall -O1 -o esolang_bf brainfuck.c

clean:
	rm -f esolang_bf memory.dmp
