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
;          ZP1   ~ instructions ~   ZP2  IC1  IC2  AF   AT    RV    LD    ZP3
; Cell No:  0    1    2    3    4    5    6    7    8    9    10    11    12
;
;          MP1  MP2  ZP4  ~~~~~~~~~~~~~~~~~ memory cells ~~~~~~~~~~~~~~~~~~~~
; Cell No: 13   14   15   16   17   18   19   20   21   22    23    24    25
;
; ZP1 : zero partition cell to be used with the "find zero'd cell" algorithm
; ZP2 : zero partition cell to be used with the "find zero'd cell" algorithm
; IC1 : copy of the current instruction
; IC2 : copy of the current instruction
;  AF : flag cell to indicate whether the current instruction has been decoded
;  AT : used for decoding the current instruction
;  RV : used for decoding the current instruction
;  LD : tracks the current loop depth for loop instruction jumps
; ZP3 : zero partition cell to be used with the "find zero'd cell" algorithm
; MP1 : current memory pointer value
; MP2 : current memory pointer value
; ZP4 : zero partition cell to be used with the "find zero'd cell" algorithm
;
]

-----------------------------   ; Subtract 37 from ZP1
--------

[
+++++++++++++++++++++++++++++   ; Add 37 to the cell holding the previously
++++++++                        ; scanned instruction

>+>,                            ; Set a cell to 1 and scan the instruction
                                ; into the next cell

-----------------------------   ; Subtract 37 from the scanned instruction
--------
]
<-                              ; Set the final cell which was set to 1 back
                                ; to 0

>>>>>>>>+>+<<<<<<<<<<[<]>       ; Shift to MP1 and MP2 and set to 1 before
                                ; shifing back to the first instruction
[
->[[>]>+>+<<<[<]>-]             ; Make two copies of the current instruction
                                ; into IC1 and IC2 leaving two cells set to
                                ; 0 in the instruction memory

>[>]>>>+                        ; Set AF to 1 to indicate that the current
                                ; instruction hasn't been decoded this cycle

==============================================================================
INCREMENT
==============================================================================

[                               ; This loop body will always be entered

>>+>                            ; Set RV to 1
++++++++++[<<++++>>-]<<+++      ; Set AT to 43

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the increment instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

-<<->>>>>>                      ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP2

[[>>+<<-]+>>-]>                 ; Use MP2 to traverse the memory cells until
                                ; the cell currently "under the pointer" has
                                ; been reached

+                               ; Increment the cell

<+[-<<]                         ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<<             ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

==============================================================================
DECREMENT
==============================================================================

[                               ; This loop body will only be entered if the
                                ; instruction has not been decoded yet

>>+>                            ; Set RV to 1
++++++++++[<<++++>>-]<<+++++    ; Set AT to 45

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the decrement instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

-<<->>>>>>                      ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP2

[[>>+<<-]+>>-]>                 ; Use MP2 to traverse the memory cells until
                                ; the cell currently "under the pointer" has
                                ; been reached

-                               ; Decrement the cell

<+[-<<]                         ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<<             ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

==============================================================================
SHIFT RIGHT
==============================================================================

[                               ; This loop body will only be entered if the
                                ; instruction has not been decoded yet

>>+>                            ; Set RV to 1
++++++++++[<<++++++>>-]<<++     ; Set AT to 62

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the shift right instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

-<<->>>>>                       ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP1

+>+                             ; Increment MP1 and MP2

<<<<                            ; Shift to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT  
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

==============================================================================
SHIFT LEFT
==============================================================================

[                               ; This loop body will only be entered if the
                                ; instruction has not been decoded yet

>>+>                            ; Set RV to 1
++++++++++[<<++++++>>-]<<       ; Set AT to 60

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the shift left instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

-<<->>>>>                       ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP1

->-                             ; Decrement MP1 and MP2

<<<<                            ; Shift to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT  
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

==============================================================================
OUTPUT
==============================================================================

[                               ; This loop body will only be entered if the
                                ; instruction has not been decoded yet

>>+>                            ; Set RV to 1
++++++++++[<<+++++>>-]<<----    ; Set AT to 46

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the output instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

-<<->>>>>>                      ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP2  

[[>>+<<-]+>>-]>                 ; Use MP2 to traverse the memory cells until
                                ; the cell currently "under the pointer" has
                                ; been reached

.                               ; Print the cell

<+[-<<]                         ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<<             ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

==============================================================================
INPUT
==============================================================================

[                               ; This loop body will only be entered if the
                                ; instruction has not been decoded yet

>>+>                            ; Set RV to 1
++++++++++[<<++++>>-]<<++++     ; Set AT to value of 44

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the input instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

-<<->>>>>>                      ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP2  

[[>>+<<-]+>>-]>                 ; Use MP2 to traverse the memory cells until
                                ; the cell currently "under the pointer" has
                                ; been reached

,                               ; Scan into the cell

<+[-<<]                         ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<<             ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

==============================================================================
LOOP START
==============================================================================

[                               ; This loop body will only be entered if the
                                ; instruction has not been decoded yet

>>+>                            ; Set RV to 1 
++++++++++[<<+++++++++>>-]<<+   ; Set AT to 91

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the loop start instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

>+<                             ; Set LD to 1

-<<->>>>>>                      ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP2

[[>>+<<-]+>>-]>                 ; Use MP2 to traverse the memory cells until
                                ; the cell currently "under the pointer" has
                                ; been reached

[                               ; This loop body is only entered if the cell
                                ; "under the pointer" has a nonzero value

<+[-<<]                         ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<              ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to LD

-                               ; Set LD to 0

>>>[[>>+<<-]+>>-]               ; Traverse back through the memory cells to
                                ; the cell before the cell which is "under
                                ; the pointer"
]
>[>]<<                          ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto cell before
                                ; the cell "under the pointer"

+[-<<]                          ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<              ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to LD

[                               ; This loop body is only entered if LD has
                                ; a nonzero value
        
<<<<<<<[<]+[>]>-[<<[<]>+[>]>-]  ; Place the current instruction back into
                                ; instruction memory

<<[<]+>>->[[>]>+>+<<<[<]>-]     ; Make two copies of the next instruction
                                ; into IC1 and IC2 leaving two cells set to
                                ; 0 in the instruction memory

>[>]>>>+                        ; Set AF to 1 to indicate that the current
                                ; instruction hasn't been decoded this cycle

[
>>+>                            ; Set RV to 1
>++++++++++[<<<+++++++++>>>-]   ; Set AT to 91
<<<+

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[
-<<-                            ; Set RV and AF to 0 since the instruction
                                ; has been decoded

>>>+<                           ; Increment LD and shift to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

[
>>+>                            ; Set RV to 1
>++++++++++[<<<+++++++++>>>-]   ; Set AT to 93
<<<+++

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero
[
-<<-                            ; Set RV and AF to 0 since the instruction
                                ; has been decoded

>>>-<                           ; Decrement LD and shift to RV
]
]
<<<<<<[>]>>>>>><<<[-]>>>        ; Whether or not the instruction was decoded
                                ; as a loop start or end or neither will
                                ; impact where the memory pointer is at this
                                ; stage ; Synchronize onto LD ; Set AF to 0
]
<                               ; Shift to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

==============================================================================
LOOP END
==============================================================================

[                               ; This loop body will only be entered if the
                                ; instruction has not been decoded yet
                                  
>>+>                            ; Set RV to 1 
++++++++++[<<+++++++++>>-]<<+   ; Set AT to 93
++

                                ; IC2 currently holds a copy of the current
                                ; instruction and AT holds the ascii code of
                                ; the loop end instruction

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[                               ; This loop body is only entered if RV has a
                                ; nonzero value meaning IC2 and AT are equal

><                              ; Leave LD as 0

-<<->>>>>>                      ; Set RV and AF to 0 since the instruction
                                ; has been decoded and shift to MP2

[[>>+<<-]+>>-]>                 ; Use MP2 to traverse the memory cells until
                                ; the cell currently "under the pointer" has
                                ; been reached

[                               ; This loop body is only entered if the cell
                                ; "under the pointer" has a nonzero value

<+[-<<]                         ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<              ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to LD

+                               ; Set LD to 1

>>>[[>>+<<-]+>>-]               ; Traverse back through the memory cells to
                                ; the cell before the cell which is "under
                                ; the pointer"
]
>[>]<<                          ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto cell before
                                ; the cell "under the pointer"

+[-<<]                          ; Shift back to ZP3

>[<+>>+<-]<[>+<-]<              ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to LD

[                               ; This loop body is only entered if LD has
                                ; a nonzero value
        
<<<<<<<[<]+[>]>-[<<[<]>+[>]>-]  ; Place the current instruction back into
                                ; instruction memory

<<[<]+<<->[[>]>+>+<<<[<]>-]     ; Make two copies of previous instruction
                                ; into IC1 and IC2 leaving two cells set to
                                ; 0 in the instruction memory

>[>]>>>+                        ; Set AF to 1 to indicate that the current
                                ; instruction hasn't been decoded this cycle

[
>>+>                            ; Set RV to 1
>++++++++++[<<<+++++++++>>>-]   ; Set AT to 91
<<<+

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero

[
-<<-                            ; Set RV and AF to 0 since the instruction
                                ; has been decoded

>>>-<                           ; Decrement LD and shift to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP3 and MP1 to restore MP2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

[
>>+>                            ; Set RV to 1
>++++++++++[<<<+++++++++>>>-]   ; Set AT to 93
<<<+++

<<[>>-<<-]>>[>-<[-]]>           ; If IC2 and AT have equal cell values then
                                ; RV will keep it's value of 1 otherwise it
                                ; will be updated to zero
[
-<<-                            ; Set RV and AF to 0 since the instruction
                                ; has been decoded

>>>+<                           ; Increment LD and shift to RV
]
]
<<<<<<[>]>>>>>><<<[-]>>>        ; Whether or not the instruction was decoded
                                ; as a loop start or end or neither will
                                ; impact where the memory pointer is at this
                                ; stage ; Synchronize onto LD ; Set AF to 0
]
<                               ; Shift to RV
]
<<<<[<+>>+<-]<[>+<-]>>>>        ; Use ZP2 and IC1 to restore IC2 and shift
                                ; to AT
]
<<[<]>>>                        ; Whether or not the above body was entered
                                ; will impact where the memory pointer is at
                                ; this stage ; Synchronize onto AF

[-]                             ; Set AF to 0 in case the instruction was
                                ; not decoded as a Brainfuck instruction

<[-]<<<[<]+[>]>-[<<[<]>+[>]>-   ; Place the current instruction back into
]<                              ; instruction memory ; Clear IC1 and IC2

<[<]+>>                         ; Restore the cell before the instruction to
                                ; 1 and shift to the cell preceding the next
                                ; instruction
]

