[
;
; brainfuck.bf
; github.com/jaalsoto/esolang_bf
;
; An interpreter for the Brainfuck esoteric programming language written
; in Brainfuck.
;
; The memory structure of the interpreter is as follows:
;
; Z1   ~~~~~ instruction memory ~~~~~   Z2   S1   S2   I1   I2   RV   LD
;
; Z3   M1   M2   Z4   ~~~~~ memory cells ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; Legend:
;
; Z1, Z2, Z3, Z4 : cells always set to 0
; S1, S2         : cells always set to 1
; I1, I2         : copies of the current instruction
; RV             : used for decoding the current instruction
; LD             : tracks the current loop depth
; M1, M2         : copies of the current memory pointer value
;
]

; Load instructions until "%" is found
-------------------------------------
[
+++++++++++++++++++++++++++++++++++++
>+>,
-------------------------------------
]

; Initialize S1 and S2 and M1 and M2
<->+>+>>>>>>+>+<<<<<<<<<<[<]>

; Start instruction cycle
[
    ; Copy current instruction into I1 and I2
    ->
    [
        [>]>>>
        +>+
        <<<<<[<]
        >-
    ]
    >[>]>>>>

    ; Set I2 to 0 and RV to 1 if an increment instruction
    >+<-------------------------------------------[>-]<[<]>>>>>

    ; Enter body if an increment instruction
    [
        ; Shift to cell currently under the pointer
        >>>>
        [
            [>>+<<-]+>>-
        ]

        ; Increment the cell currently under the pointer
        >+
        
        ; Exit the memory cells
        <+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<<-
    ]
    <

    ; Set I2 to 0 and RV to 1 if an input instruction
    >+<-[>-]<[<]>>>>>

    ; Enter body if an input instruction
    [
        ; Shift to cell currently under the pointer
        >>>>
        [
            [>>+<<-]+>>-
        ]

        ; Read into the cell currently under the pointer
        >,
        
        ; Exit the memory cells
        <+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<<-
    ]
    <

    ; Set I2 to 0 and RV to 1 if a decrement instruction
    >+<-[>-]<[<]>>>>>

    ; Enter body if a decrement instruction
    [
        ; Shift to cell currently under the pointer
        >>>>
        [
            [>>+<<-]+>>-
        ]

        ; Decrement the cell currently under the pointer
        >-
        
        ; Exit the memory cells
        <+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<<-
    ]
    <

    ; Set I2 to 0 and RV to 1 if an output instruction
    >+<-[>-]<[<]>>>>>

    ; Enter body if an output instruction
    [
        ; Shift to cell currently under the pointer
        >>>>
        [
            [>>+<<-]+>>-
        ]

        ; Print the cell currently under the pointer
        >.
        
        ; Exit the memory cells
        <+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<<-
    ]
    <

    ; Set I2 to 0 and RV to 1 if a left shift instruction
    >+<--------------[>-]<[<]>>>>>

    ; Enter body if a left shift instruction
    [
        ; Decrement both M1 and M2
        >>>->-<<<<-
    ]
    <

    ; Set I2 to 0 and RV to 1 if a right shift instruction
    >+<--[>-]<[<]>>>>>

    ; Enter body if a right shift instruction    
    [
        ; Increment both M1 and M2
        >>>+>+<<<<-
    ]
    <

    ; Set I2 to 0 and RV to 1 if a loop start instruction
    >+<-----------------------------[>-]<[<]>>>>>

    ; Enter body if a loop start instruction
    [
        ; Shift to cell currently under the pointer
        >>>>
        [
            [>>+<<-]+>>-
        ]

        >>+<[>-]<[<]>>

        ; Enter body if cell currently under the pointer is 0
        [
            ; Set LD to 1
            <<+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<+<->

            ; Loop if LD is greater than 0
            [
                ; Load next instruction into I1 and I2
                <<<-<<<<[<]+[>]>>>
                [
                    <<<<[<]>+[>]>>>-
                ]
                <<<<[<]+>>->
                [
                    [>]>>>+>+<<<<<[<]>-
                ]
                >[>]>>>>

                ; Set I2 to 0 and increment LD if a loop start instruction
                -------------------------------------------------------------
                ------------------------------
                >+<[>-]<[<]>>>>>[>+<-]+<
                
                ; Set I2 to 0 and decrement LD if a loop end instruction
                --[>-]<[<]>>>>>[>-<-]<[-]>>
            ]
            >>>
            [
                [>>+<<-]+>>-
            ]
            >>-
        ]

        ; Exit the memory cells
        <<+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<<-[-] 
    ]
    <

    ; Set I2 to 0 and RV to 1 if a loop end instruction
    >+<--[>-]<[<]>>>>>

    ; Enter body if a loop end instruction
    [
        ; Shift to cell currently under the pointer
        >>>>
        [
            [>>+<<-]+>>-
        ]
        >

        ; Enter body if cell currently under the pointer is not 0
        [
            ; Set LD to 1
            <+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<+<->

            ; Loop if LD is greater than 0
            [
                ; Load previous instruction into I1 and I2
                <<<-<<<<[<]+[>]>>>
                [
                    <<<<[<]>+[>]>>>-
                ]
                <<<<[<]+<<->
                [
                    [>]>>>+>+<<<<<[<]>-
                ]
                >[>]>>>>

                ; Set I2 to 0 and decrement LD if a loop start instruction
                -------------------------------------------------------------
                ------------------------------
                >+<[>-]<[<]>>>>>[>-<-]+<
                
                ; Set I2 to 0 and increment LD if a loop end instruction
                --[>-]<[<]>>>>>[>+<-]<[-]>>
            ]
            >>>
            [
                [>>+<<-]+>>-
            ]
        ]

        ; Exit the memory cells
        >[>]<<+[-<<]>[>+>+<<-]>>[<<+>>-]<<<<<-[-]
    ]
    <

    ; Load next instruction for next instruction cycle
    [-]<-<<<<[<]+[>]>>>
    [
        <<<<[<]>+[>]>>>-
    ]
    <<<<[<]+>>
]

