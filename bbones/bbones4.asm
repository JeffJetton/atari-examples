;-------------------------------------------------------
;
; Bare-Bones Program #4
;
; Initialize VCS memory and registers before starting
; (Using methods that are more idiomatic to assembler)
;
;-------------------------------------------------------

        processor 6502

COLUBK  equ $09
MyBGCol equ $D0

        org $F000


; Basic set-up

Start   sei         ; Prevent interrupts
        cld         ; Clear "decimal" mode
        ldx #$FF    ; Set the...
        txs         ; ...stack pointer


; Initialize the "zero-page"

        lda  #0     ; Keep a zero in the A register
                    ; The value in X is still $FF
                    ; from the above ldx instruction
                    
        ; Our loop goes backwards from
        ; $FF down to $00
Init    sta  0,x    ; Put A's zero into address $00 + X
        dex         ; Decrement X
        bne  Init   ; Loop as long as X isn't zero.
                    ; Notice that, unlike last time, we
                    ; didn't do a cmp ("CoMPare") before
                    ; our bne ("Branch if Not Equal")
                    ; operation. Really, all bne does
                    ; is check the "zero flag". So
                    ; you can also translate it to
                    ; "Branch (if the last math operation
                    ; gave a result that is) Not Equal
                    ; (to zero)"
        
        sta  $00    ; A final zero into address $00

        ; Init section now takes 9 bytes and 2,045
        ; cycles. A savings of 5 bytes (36% smaller)
        ; and 1,022 cycles (33% faster). Not bad!


; Main loop

SetTIA  lda #MyBGCol
        sta COLUBK

        jmp SetTIA

        org $FFFC
        .word Start
        .word Start

