;---------------------------------------------------------------
;
; Using the "player" registers, part III
;
; Displaying the player by referencing a lookup table in memory
; 
;---------------------------------------------------------------

        processor 6502

        include "../_includes/vcs.h"
        include "../_includes/macro.h"

; Constants
MyBGCol equ $22
MyP0Col equ $1E
PHeight equ 9   ; Height of player data (including blank line)



        org $F000
Start   CLEAN_START

        ; Set up colors for background and player
        lda #MyBGCol
        sta COLUBK
        lda #MyP0Col
        sta COLUP0


; Main display kernel starts here ----------------------------------------------

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
        ; Top 90 lines
        ldx #90
Chunk1  sta WSYNC
        dex
        bne Chunk1



        ; Draw player sprite by cycling (backwards)
        ; through the image data. Set X up so that the last
        ; byte of data is at X=1
        ldx #PHeight    ; Start index at maximum offset

PLoop   sta WSYNC
        lda Sprite-1,x  ; Offset address "Sprite" (defined below) by
                        ; the current value of X. Take whatever's
                        ; in the resulting location and load into A.
                        ; We'll offset from Sprite - 1 so that X=1
                        ; is the first byte (the blank line). The loop
                        ; doesn't actually load anything when X=0,
                        ; so we'll need to make sure we've read
                        ; all the data by then.

        sta GRP0        ; Shove A out to the P0 register.

        dex             ; Bump our X index down by one
        bne PLoop       ; Is X zero? Loop back up if not.



        ; Final lines of visible area
        ldx #(192 - 90 - PHeight)   ; This math is done at compile-time
Chunk2  sta WSYNC
        dex
        bne Chunk2 


        ; Overscan portion
        lda #2
        sta VBLANK
        ldx #30
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




