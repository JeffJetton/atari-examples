;---------------------------------------------------------------
;
; Using the "player" registers
;
; Blue player shows joystick input
;
; Orange player shows console switch settings
; 
;---------------------------------------------------------------

        processor 6502
        include vcs.h
        include macro.h

		
; Color contants
MyBGCol equ $00         ; Black for background
MyP0Col equ $9A
MyP1Col equ $2A



        org $F000
Start   CLEAN_START

; Set up colors for background and players
        lda #MyBGCol
        sta COLUBK
        lda #MyP0Col
        sta COLUP0
        lda #MyP1Col
        sta COLUP1

		
; Main display kernel starts here ---------------------------------------------

        ; Vertical sync
        lda #2
        sta VBLANK
Frame   sta VSYNC
        sta WSYNC
        sta WSYNC
        sta WSYNC
        txa             ; X will contain 0 at first iteration.
        sta VSYNC
        
        ; Uncomment this next block if the players overlap:
        ; sta RESP0
        ; nop 0
        ; nop 0
        ; nop 0
        ; nop 0
        ; nop 0
        ; sta RESP1
		
        ; Remainder of vertical blanking period
        ldx #37
VertBl  sta WSYNC
        dex
        bne VertBl
        sta VBLANK



        ; Set up the player register.
        ; Joystick input register goes into player "zero"
        lda SWCHA
        sta GRP0
        ; Console switch settings goes into player "one"
        lda SWCHB
        sta GRP1

       
       
        ; Visible area of frame
        ldx #192
VisArea sta WSYNC
        dex
        bne VisArea
		
        
        
        ; Overscan portion
        lda #2
        sta VBLANK
        ldx #30
OvScan  sta WSYNC
        dex
        bne OvScan
		
        jmp Frame       ; Note that x=0 at this point, ready for next frame
                        ; Also, VBLANK mode is still in effect

        org $FFFC
        .word Start
        .word Start

; Next steps:
; Rough horizontal positioning?
; Drawing a shape (hard-coded with WSYNCS)
; Hard-coded shape using y-pos variable
; Drawing a shape (lookup table & y-pos)



