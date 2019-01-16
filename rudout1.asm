;---------------------------------------------------------------
;
; Rudimentary output, part 1
; 
; Display a static number in binary using playfield graphics
;
;---------------------------------------------------------------

        processor 6502

        ; Standard includes
        include "vcs.h"
        include "macro.h"

		
; Define some color constants (NTSC)
MyBGCol equ $06         ; Medium gray
MyPFCol equ $46         ; Reddish-pink


        org $F000
        
        ; Standard initialization
Start   CLEAN_START 

        ; Set colors and playfield
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF

LoadA   ; Load A with the number we want
        ; and show it in a playfield
        lda #%10110111  ; <- Experiment by changing this value
        sta PF1

        jmp LoadA       ; Do it all over again

        org $FFFC
        .word Start
        .word Start



