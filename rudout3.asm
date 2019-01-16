;---------------------------------------------------------------
;
; Rudimentary output, part 3
; 
; Display the result of a math operation (using RAM this time!)
;
;---------------------------------------------------------------

        processor 6502
        include "vcs.h"
        include "macro.h"

		
; Color constants (NTSC)
MyBGCol equ $06     ; Medium gray
MyPFCol equ $46     ; Reddish-pink

; Define a memory location in RAM
BasePay equ $80


        org $F000
        
        ; Standard initialization
Start   CLEAN_START 

        ; Set colors and playfield
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF

        ; Set our base pay "variable" to 42 rupees
        lda #42         ; Load A with 42 (decimal)
        sta BasePay     ; Store contents of A in address BasePay
		
        ; We get a bonus of 64 rupees!
Bonus   lda #64         ; Put 64 in A
        clc             ; ALWAYS clear carry before an add!
        adc BasePay     ; Add the contents of BasePay to A
        sta PF1         ; Show the binary result

        jmp Bonus

        org $FFFC
        .word Start
        .word Start
