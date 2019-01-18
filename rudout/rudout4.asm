;---------------------------------------------------------------
;
; Rudimentary output, part 4
; 
; Using the timer to cycle through binary numbers
;
;---------------------------------------------------------------

        processor 6502
        include "vcs.h"
        include "macro.h"


        ; Timer constants (adjust to taste)
Timer   equ T1024T     ; Use the 1024 cycles-per-tick timer
Ticks   equ $FF        ; Interval is 255 ticks
                       ;
                       ; 255 * 1024 = 261,120 cycles!
                       ; That's as slow as we can time in one
                       ; single timer shot, yet it's still
                       ; under 1/4 of a second

        org $F000
        
Start   CLEAN_START 

        ; Black background
        lda #0
        sta COLUBK

        ; We'll track our displayed number in Y
        ; Start it out at zero
        ldy #0
        
        
ShowNum ; Load current number into playfield
        sty PF1
        ; Set playfield color to that number too
        sty COLUPF
        
        ; Init timer
        lda #Ticks
        sta Timer
        
        ; Timer done?
TimWait lda INTIM
        bne TimWait     ; Nope? Keep checking
        
        ; Finally done! Increment Y and loop
        iny
        jmp ShowNum


        org $FFFC
        .word Start
        .word Start
