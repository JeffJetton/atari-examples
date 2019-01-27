;---------------------------------------------------------------
;
; Rudimentary input, part 2
; 
; Display joystick input
;
;---------------------------------------------------------------

        processor 6502
        include "../_includes/vcs.h"
        include "../_includes/macro.h"

		
        ; Color constants
BG_Norm equ $72
BG_Fire equ $2A
MyPFCol equ $18


        org $F000
        
Start   CLEAN_START 

        ; Set playfield color
        lda #MyPFCol
        sta COLUPF


Main    lda SWCHA       ; Put joystick directional state (port A) into A
        sta PF1         ; Store it in playfield
        
        lda INPT4       ; Store trigger state for player 0 in A
                        ; Normally the high bit (bit 7) is set, which
                        ; the 6502 flag register considers to be the
                        ; indicator of a negative number.
                        ; When the trigger is pressed, bit 7 clears,
                        ; making the byte "positive"
                        
        bpl TrigOn      ; Branch if it's positive (negative flag clear)
        lda BG_Norm     ; ...otherwise, use normal background color
        sta COLUBK
        jmp Main
        
TrigOn  lda BG_Fire     ; Use the "fire" background color
        sta COLUBK
        jmp Main        ; Loop back up again
        
        

        org $FFFC
        .word Start
        .word Start
