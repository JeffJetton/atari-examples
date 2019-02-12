;---------------------------------------------------------------
;
; Horizontal positioning of player graphics, part I
;
; Basic, timing-based coarse positioning
; 
;---------------------------------------------------------------

        processor 6502

        include "../_includes/vcs.h"
        include "../_includes/macro.h"

; Constants
MyBGCol equ $8E
MyP0Col equ $50
PHeight equ 9       ; Height of player data (including blank line)
StartY  equ 100     ; Starting y position of player
StartX  equ 10      ; Starting x position of player, as measured in the
                    ; number of processor cycles since the last WSYNC


; Variables
YPos    equ $80     ; Player y-position (vertical location)
XPos    equ $81     ; Player x-position (horizontal location)


        org $F000
Start   CLEAN_START

        ; Set up colors and variables
        lda #MyBGCol
        sta COLUBK
        lda #MyP0Col
        sta COLUP0
        lda #StartY
        sta YPos
        lda #StartX
        sta XPos



; Main display kernel starts here ---------------------------------------------

        ; Use the standard vsync macro
Frame   VERTICAL_SYNC

        ; RESP0 is "reset player 0". It causes the player's horizontal position
        ; to be set at whatever location the beam is on at the exact moment the
        ; instruction is executed.
        ldx XPos
        lda #2
        sta WSYNC
HLoop   dex
        bne HLoop
        sta RESP0
        
        ; Remainder of vertical blanking period
        sta WSYNC
        ldx #35
VertBl  sta WSYNC
        dex
        bne VertBl
        lda #0
        sta VBLANK

        ; Visible area of frame -----------------
        ldx #192
VizArea sta WSYNC

        ; Draw player data?
        txa
        sec
        sbc YPos
        cmp #PHeight
        bcc DrawP0
        lda #0
DrawP0  tay
        lda Sprite,y
        sta GRP0

        ; Next scanline...
        dex
        bne VizArea

        ; Overscan portion
        sta WSYNC
        lda #2
        sta VBLANK
        ldx #29
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




