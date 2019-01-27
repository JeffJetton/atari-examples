;---------------------------------------------------------------
;
; Using the "player" registers, part IV
;
; Displaying the player image at an arbitrary vertical position   
; 
;---------------------------------------------------------------

        processor 6502

        include "../_includes/vcs.h"
        include "../_includes/macro.h"

; Constants
MyBGCol equ $22
MyP0Col equ $1E
PHeight equ 9       ; Height of player data (including blank line)
StartY  equ 180     ; Starting y position of player


; Variables
YPos    equ $80     ; Storage location for the player's y-position. The value
                    ; contained here represents the position in terms of the
                    ; number of lines measured from bottom.




        org $F000
Start   CLEAN_START

        ; Set up colors and variable
        lda #MyBGCol
        sta COLUBK
        lda #MyP0Col
        sta COLUP0
        lda #StartY
        sta YPos



; Main display kernel starts here ---------------------------------------------

        ; Vertical sync
        lda #2
        sta VBLANK
Frame   sta VSYNC
        sta WSYNC
        sta WSYNC
        sta WSYNC
        txa
        sta VSYNC

        ; Remainder of vertical blanking period
        ldx #37
VertBl  sta WSYNC
        dex
        bne VertBl
        sta VBLANK


        ; Visible area of frame -----------------
        
        ; Rather than dividing our line displays into "chunks",
        ; We'll always write *something* to GRP0 on every line.
        ; On lines where there's no player, we'll write a zero.
        ; But we'll include logic to "turn on" reading from
        ; the lookup table of image data, based on which line
        ; we're on (compared to the desired y position)
        
        ldx #192    ; X is our counter: Number of lines from bottom

VizArea sta WSYNC
        ; How many lines above the bottom of our player (YPos) are we?
        ; To calculate, just subtract YPos from current line num 
        txa
        sec         ; Prepare for subtraction by setting carry flag
        sbc YPos
        
        ; If that number of lines within our player height, use that
        ; number as an offset index for the player image data.
        cmp #PHeight    ; This subtracts player height from A but
                        ; doesn't store the result. Just sets flags.
                        
        ; After the cmp, the carry flag (C) is only set if A is
        ; greater than or equal to PHeight. It will be clear if
        ; A is less than PHeight, in which case we branch directly
        ; to the part that reads in the image data at offset A.
        bcc DrawP0
        
        ; At this point, the bcc was false, so we'll ensure the
        ; offset value used is zero--giving us the first row of
        ; image data (which is a blank row)
        lda #0

DrawP0  ; Okay, we can't use A as offset directly, and X is
        ; tied up with keeping track of lines. So we'll use Y.
        ; Remember that, at this point, A will contain either
        ; zero (if we're not in the range to draw the player)
        ; or the offset index of the data to draw.
        tay
        lda Sprite,y
        sta GRP0


        ; Phew! Okay, move to next line...
        dex
        bne VizArea



        ; Overscan portion
        lda #2
        sta VBLANK
        dec YPos    ; Move the player down one line each frame
FinOvr  ldx #30
OvScan  sta WSYNC
        dex
        bne OvScan

        jmp Frame



        ; Data for drawing our player sprite
Sprite  .byte #0            ; Zero at end to clear out player register
        .byte #%00111100
        .byte #%01100010
        .byte #%11011101
        .byte #%11111111
        .byte #%11101011
        .byte #%11001001     
        .byte #%01111110
        .byte #%00111100


        org $FFFC
        .word Start
        .word Start




