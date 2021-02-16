//
//  brainfuck.c
//  github.com/jaalsoto/esolang_bf
//
//  An interpreter for the Brainfuck esoteric programming language.
//

#include <stdio.h>
#include <stdlib.h>

int
main (int argc, const char *argv[])
{
    const int ADDRESS_SPACE = 30000;
    FILE *source;
    FILE *output;
    char *instruction_memory;
    uint8_t memory[ADDRESS_SPACE] = {0};
    int ret;
    int depth = 0;
    unsigned int memory_index = 0;
    unsigned int length = 0;
    unsigned int program_counter = 0;
    char input;

    if (argc != 2) {
        printf ("usage: <input file>\n");
        exit (1);
    }

    output = fopen ("memory.dmp", "w");
    if (output == NULL) {
        printf ("failed to open memory.dmp\n");
        exit (1);
    }

    source = fopen (argv[1], "r");
    if (source == NULL) {
        printf ("failed to open %s\n", argv[1]);
        exit (1);
    }

    fseek (source, 0, SEEK_END);
    length = ftell (source);
    rewind (source);

    instruction_memory = malloc (sizeof (char) * length);
    if (instruction_memory == NULL) {
        printf ("memory allocation failure\n");
        exit (1);
    }

    ret = fread (instruction_memory, sizeof (char), length, source);
    if (ret != length) {
        printf ("failed to read %s\n", argv[1]);
        exit (1);
    }

    fclose (source);

    for (program_counter = 0; program_counter < length; program_counter++) {
        switch (instruction_memory[program_counter]) {
            case '[': depth++; break;
            case ']': depth--; break;
            default: break;
        }
        if (depth < 0) {
            printf ("loop instruction syntax error\n");
            exit (1);
        }
    }

    if (depth != 0) {
        printf ("loop instruction syntax error\n");
        exit (1);
    }

    for (program_counter = 0; program_counter < length; program_counter++) {
        switch (instruction_memory[program_counter]) {
            case '>':
                if (memory_index == ADDRESS_SPACE - 1) {
                    printf ("upper out of bounds pointer\n");
                    exit (1);
                }
                memory_index++;
                break;
            case '<':
                if (memory_index == 0) {
                    printf ("lower out of bounds pointer\n");
                    exit (1);
                }
                memory_index--;
                break;
            case '[':
                if (memory[memory_index] == 0) {
                    depth = 1;
                    program_counter++;
                }
                while (depth) {
                    switch (instruction_memory[program_counter]) {
                        case '[': depth++; break;
                        case ']': depth--; break;
                        default: break;
                    }
                    if (depth != 0)
                        program_counter++;
                }
                break;
            case ']':
                if (memory[memory_index] >= 1) {
                    depth = 1;
                    program_counter--;
                }
                while (depth) {
                    switch (instruction_memory[program_counter]) {
                        case '[': depth--; break;
                        case ']': depth++; break;
                        default: break;
                    }
                    if (depth != 0)
                        program_counter--;
                }
                break;
            case '.':
                putc (memory[memory_index],stdout);
                break;
            case ',':
                input = fgetc (stdin);
                fseek (stdin, 0, SEEK_END);
                if (input != EOF)
                    memory[memory_index] = input;
                break;
            case '+':
                if (memory[memory_index] != 255)
                    memory[memory_index]++;
                else
                    memory[memory_index] = 0;
                break;
            case '-':
                if (memory[memory_index] != 0)
                    memory[memory_index]--;
                else
                    memory[memory_index] = 255;
                break;
            default:
                break;
        }
    }

    ret = fwrite (memory, sizeof (uint8_t), ADDRESS_SPACE, output);
    if (ret != ADDRESS_SPACE) {
        printf ("failed to write memory.dmp\n");
        exit (1);
    }

    fclose (output);

    free (instruction_memory);

    return (0);
}

