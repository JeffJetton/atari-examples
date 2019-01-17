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

; Define two memory locations
Num1    equ $80
Num2    equ $81


        org $F000
        
        ; Standard initialization
Start   CLEAN_START 

        ; Set colors and playfield
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF

        ; Load first number into memory
        lda #4          ; Load A with 2
        sta Num1        ; Store contents of A in address Num1
        
        ; Load second number into memory
        lda #5
        sta Num2
		
        ; We can add 4 & 5 by referencing memory:
        lda Num1        ; Put Num1 in A
        clc             ; ALWAYS clear carry before an add!
        adc Num2        ; Add Num2 to A
        sta PF1         ; Show the binary result

Endless nop
        jmp Endless

        org $FFFC
        .word Start
        .word Start
