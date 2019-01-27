;-------------------------------------------------------
;
; Bare-Bones Program #3
;
; Initialize VCS memory and registers before starting
; (In a style similar to how a high-level language
; might do it)
;
;-------------------------------------------------------

        processor 6502

COLUBK  equ $09
MyBGCol equ $2A
   

        org $F000

; Basic set up

Start   sei         ; Prevent interrupts
        cld         ; Clear "binary-coded decimal" mode
        ldx #$FF    ; Take the highest address in RAM...
        txs         ; ...and put it in the stack pointer


; Initialize the "zero-page" (inefficient, for now)
        
        ldx #0      ; Use X for the index of our current
                    ; address. Start at zero.
        ldy #0      ; Put a zero in Y. This is the zero
                    ; we'll use to clear out addresses.
        
Init    sty  0,x    ; Store Y's zero into 0 offset by X
                    ; (We can't just sty x... it has to
                    ; be X relative to a base value)
        inx         ; Increment X
        
        txa         ; Put current value of X into A
        cmp #$FF    ; And compare it our end value
        bne  Init   ; Branch (if that comparison
                    ; resulted in) Not Equal
        
        sty 0      ; Final zero in the last address
        
        ; Init section takes 14 bytes and 3,067 cycles


; Set up the graphics, such as they are...

SetTIA  lda #MyBGCol
        sta COLUBK

        jmp SetTIA

        org $FFFC
        .word Start
        .word Start

