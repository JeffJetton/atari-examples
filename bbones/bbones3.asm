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
        
Init    sty 0,x     ; Store Y's zero into 0 offset by X
                    ; (We can't just sty x... it has to
                    ; be X relative to a base value)
        inx         ; Increment X to next address

                    ; Is x at the end yet?
        cpx #$FF    ; Compare it the value $FF
        bne  Init   ; Branch (if that comparison
                    ; resulted in) Not Equal
        
                    ; If x is equal to $FF, we don't branch
                    ; and drop down to here instead
        sty 0       ; Final zero in that last address

        ; Init section takes 13 bytes and 2,882 cycles


; Set up the graphics, such as they are...

SetTIA  lda #MyBGCol
        sta COLUBK

        jmp SetTIA

        org $FFFC
        .word Start
        .word Start

