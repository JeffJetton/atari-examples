;-------------------------------------------------------
;
; Bare-Bones Program #3
;
; Initialize VCS memory and registers before starting
;
;-------------------------------------------------------

        processor 6502

COLUBK  equ $09
MyBGCol equ $2A
   

        org $F000

; Basic set-up

Start   sei         ; Prevent interrupts
        cld         ; Clear "decimal" mode
        ldx #$FF    ; Take the highest address in RAM...
        txs         ; ...and put it in the stack pointer


; Initialize the "zero-page" (inefficient, for now)
        
        ldx #0      ; Use X for our index. Start at zero
        
Init    lda #0      ; Put a zero in the "clipboard"
        sta  0,x    ; ...and store it at address $00 + X
                    ; You can't just sta x !
        inx         ; Increment X
        
        txa         ; Put current value of X into A
        cmp #$FF    ; And compare it our end value
        bne  Init   ; Branch (if that comparison
                    ; resulted in) Not Equal
        
        lda #0      ; One final zero...
        sta $FF     ; ...to store in the last address


; Set up the graphics, such as they are...

SetTIA  lda #MyBGCol
        sta COLUBK

        jmp SetTIA

        org $FFFC
        .word Start
        .word Start

