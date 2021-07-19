//
//  brainfuck.c
//  github.com/jaalsoto/esolang_bf
//
//  An interpreter for the Brainfuck esoteric programming language.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ADDR_MAX 30000

int
main (int argc, char *argv[])
{
    FILE *in, *out;
    unsigned char *code, cells[ADDR_MAX];
    int ret, depth, idx, pc, max, rem;
    size_t len;
    char input;

    if (argc != 2) {
        fprintf (stderr, "usage: <input>\n");
        exit (1);
    }

    memset (cells, 0, sizeof (cells));

    depth = idx = max = 0;

    /*
     *  Load Brainfuck program into memory.
     */

    out = fopen ("memory", "w");
    if (out == NULL) {
        fprintf (stderr, "unable to open memory file\n");
        exit (1);
    }

    in = fopen (argv[1], "r");
    if (in == NULL) {
        fprintf (stderr, "unable to open %s\n", argv[1]);
        exit (1);
    }

    fseek (in, 0, SEEK_END);
    len = ftell (in);
    rewind (in);

    code = malloc (len);
    if (code == NULL) {
        fprintf (stderr, "unable to allocate memory\n");
        exit (1);
    }

    ret = fread (code, 1, len, in);
    if (ret != len) {
        fprintf (stderr, "error reading %s\n", argv[1]);
        exit (1);
    }

    fclose (in);

    /*
     *  Verify the syntax of the loop instructions are valid.
     */

    for (pc = 0; pc < len; pc++) {
        switch (code[pc]) {
        case '[':
            depth++;
            break;
        case ']':
            depth--;
            break;
        }
        if (depth < 0) {
            fprintf (stderr, "loop instruction syntax error\n");
            exit (1);
        }
    }
    if (depth != 0) {
        fprintf (stderr, "loop instruction syntax error\n");
        exit (1);
    }

    /*
     *  Start the instruction cycle.
     */

    for (pc = 0; pc < len; pc++) {
        switch (code[pc]) {

        case '>':
            if (idx == ADDR_MAX - 1) {
                fprintf (stderr, "upper out of bounds pointer\n");
                exit (1);
            }
            idx++;
            if (idx > max)
                max = idx;
            break;
        case '<':
            if (idx == 0) {
                fprintf (stderr, "lower out of bounds pointer\n");
                exit (1);
            }
            idx--;
            break;

        /*
         *  If the loop body needs to be skipped, traverse forward through
         *  instructions tracking the loop depth. When relative loop depth
         *  reaches 0, exit.
         */

        case '[':
            if (cells[idx] == 0) {
                depth = 1;
                pc++;
            }
            while (depth) {
                switch (code[pc]) {
                case '[':
                    depth++;
                    break;
                case ']':
                    depth--;
                    break;
                }
                if (depth != 0)
                    pc++;
            }
            break;

        /*
         *  If another iteration of the loop body is required, traverse back
         *  through instructions tracking the loop depth. When relative loop
         *  depth reaches 0, exit.
         */

        case ']':
            if (cells[idx] >= 1) {
                depth = 1;
                pc--;
            }
            while (depth) {
                switch (code[pc]) {
                case '[':
                    depth--;
                    break;
                case ']':
                    depth++;
                    break;
                }
                if (depth != 0)
                    pc--;
            }
            break;

        case '.':
            putc (cells[idx], stdout);
            break;
        case ',':
            input = fgetc (stdin);
            fflush (stdin);
            if (input != EOF)
                cells[idx] = input;
            break;
        case '+':
            cells[idx]++;
            break;
        case '-':
            cells[idx]--;
            break;
        }
    }

    /*
     *  Print the values of the memory cells used.
     */
    
    rem = max % 16;
    max += (16 - rem);

    ret = fwrite (cells, 1, max, out);
    if (ret != max) {
        fprintf (stderr, "error writing memory file\n");
        exit (1);
    }

    free (code);
    fclose (out);

    return (0);
}

