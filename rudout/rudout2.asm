;---------------------------------------------------------------
;
; Rudimentary output, part 2
; 
; Display the result of a math operation
;
;---------------------------------------------------------------

        processor 6502

        ; Standard includes
        include "vcs.h"
        include "macro.h"

		
        ; Color constants
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

        ; What's 2 + 3?
DoMath  lda #2      ; Load A with 2
        clc         ; Alway clear carry flag before adding
        adc #3      ; Add 3 to whatever's in A
        sta PF1     ; Show the result (in binary)

        jmp DoMath

        org $FFFC
        .word Start
        .word Start



