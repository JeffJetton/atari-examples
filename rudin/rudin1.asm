;---------------------------------------------------------------
;
; Rudimentary input, part 1
; 
; Display the console switch register
;
;---------------------------------------------------------------

        processor 6502
        include "vcs.h"
        include "macro.h"

		
        ; Color constants
MyBGCol equ $72
MyPFCol equ $18


        org $F000
        
Start   CLEAN_START 

        ; Set colors
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF


Main    lda SWCHB       ; Put console state (port B) into A
        sta PF1         ; Store it in playfield
        jmp Main

        org $FFFC
        .word Start
        .word Start
