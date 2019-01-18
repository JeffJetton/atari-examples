;---------------------------------------------------------------
;
; Rudimentary output, part 5
; 
; Running multiple shots of the timer by using a subroutine
;
;---------------------------------------------------------------

        processor 6502
        include "vcs.h"
        include "macro.h"


        ; Timer constants (adjust to taste)
Timer   equ T1024T     ; Use the 1024 cycles-per-tick timer
Ticks   equ $FF        ; Interval is 255 ticks
                       

        org $F000
        
Start   CLEAN_START 

        ; Black background
        lda #0
        sta COLUBK

        ; Start count at zero
        tay
        
        
ShowNum ; Load current number into playfield
        sty PF1
        ; Set playfield color to that number too
        sty COLUPF
        
        ; Call the timer subroutine four times
        jsr OneShot
        jsr OneShot
        jsr OneShot
        jsr OneShot
        
        ; Increment Y and loop back up
        iny
        jmp ShowNum
        
        

        
OneShot ; The timer subroutine:
        lda #Ticks
        sta Timer

TimWait lda INTIM
        bne TimWait

        ; Done? Go back from whence we came...
        rts
        


        org $FFFC
        .word Start
        .word Start

