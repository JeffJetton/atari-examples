        processor 6502

COLUBK  equ $09         ; This line is new
PF1     equ $0E         ; As is this one

		org $F000

Start   lda #$3C        ; We added a label to this line
                        ; (And changed the hex value)
		sta COLUBK      ; Slight change here

		jmp Start       ; Making use of the label

		org $FFFC
		.word Start     ; More label usage
		.word Start     ; Here too!
