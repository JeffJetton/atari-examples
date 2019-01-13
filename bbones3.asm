        processor 6502

COLUBK  equ $09
MyBGCol equ $2A

        org $F000


Start   sei         ; Prevent interrupts
        cld         ; Clear decimal mode
        ldx  #$FF   ; Take the highest address in RAM...
        txs         ; ...and put it in the stack pointer

        lda  #0     ; Begin initialization
Init    sta  0,x    ; Put A's zero into address $00 + X
        dex         ; Decrement X
        bne  Init   ; Loop as long as X isn't zero
        sta  $00    ; A final zero into address $00


; Set up the graphics, such as they are...

SetTIA  lda #MyBGCol
        sta COLUBK

        jmp SetTIA

        org $FFFC
        .word Start
        .word Start

