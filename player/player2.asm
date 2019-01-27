;---------------------------------------------------------------
;
; Using the "player" registers, part II
;
; Displaying a player sprite image using hardcoded instructions
; 
;---------------------------------------------------------------

        processor 6502

        include "../_includes/vcs.h"
        include "../_includes/macro.h"

; Color constants
MyBGCol equ $C2
MyP0Col equ $1E



        org $F000
Start   CLEAN_START

        ; Set up colors for background and player
        lda #MyBGCol
        sta COLUBK
        lda #MyP0Col
        sta COLUP0

		
        
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
        ; Draw first 90 lines with no player info set
        ; (just background)
        ldx #90
Chunk1  sta WSYNC
        dex
        bne Chunk1
        
        
        ; Draw player sprite, one line at a time...
        sta WSYNC
        lda #%00111100
        sta GRP0
        sta WSYNC
        lda #%01111110
        sta GRP0
        sta WSYNC
        lda #%11001001
        sta GRP0
        sta WSYNC
        lda #%11101011
        sta GRP0
        sta WSYNC
        lda #%11111111
        sta GRP0
        sta WSYNC
        lda #%11011101
        sta GRP0
        sta WSYNC
        lda #%01100010
        sta GRP0
        sta WSYNC
        lda #%00111100
        sta GRP0
        ; Don't forget to clear out the last line!
        sta WSYNC
        stx GRP0
        
        
        ; Final lines of visible area:
        ; 
        ;   Visible lines:    192
        ;   Chunk1            -90
        ;   Player sprite      -8
        ;   "Clear out" line   -1
        ;   ---------------------
        ;   Remaining lines =  93
        ; 
        ldx #93
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
        
        

        org $FFFC
        .word Start
        .word Start




