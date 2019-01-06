; In dasm (and most other assemblers) comments look like this
; They start with a semicolon and continue to the end of the line

        processor 6502

; Create a new symbol (COLUBK) that "equates" to value $09
COLUBK  equ $09


        org $F000

Start   lda #$3C        ; Load a new color value into register A
                        ; Note that we've marked the location of this
                        ; instruction with the label "Start".

        sta COLUBK      ; Store A in whatever address COLUBK refers to

        jmp Start       ; Jump to whatever address Start refers to


        org $FFFC
        .word Start     ; Begin at the "Start" location when reset
        .word Start     ; Use that same address for interrupts
