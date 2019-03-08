;---------------------------------------------------------------
;
; Rudimentary output, part 1
; 
; Display a static number in binary using playfield graphics
;
;---------------------------------------------------------------

        processor 6502

        ; Standard includes
        include vcs.h
        include macro.h

		
        ; Define some color constants
MyBGCol equ $06
MyPFCol equ $46


        org $F000
        
        ; Standard initialization
Start   CLEAN_START 

        ; Set colors
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF

LoadA   ; Load A with the number we want
        ; and show it in a playfield
        lda #%10110111
        sta PF1

        jmp LoadA       ; Do it all over again

        org $FFFC
        .word Start
        .word Start



