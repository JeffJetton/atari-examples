        processor 6502

        org  $F000

        lda #$CE
        sta $09

        jmp $F000

        org $FFFC
        .word $F000
        .word $F000
