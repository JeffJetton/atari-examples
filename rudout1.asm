;---------------------------------------------------------------
;
; Rudimentary output, part 1
; 
; Display a static number in binary using playfield graphics
;
;---------------------------------------------------------------

        processor 6502

; Define a bunch of TIA addresses
COLUBK  equ $09         ; Background color register
PF1     equ $0E         ; Playfield register 1
COLUPF  equ $08         ; Playfield color register

		
; Define some color constants (NTSC)
MyBGCol equ $06         ; Medium gray
MyPFCol equ $46         ; Reddish-pink


; Initialize everything
        org $F000
Start   sei             ; Prevents interrupts
        cld             ; Turn off decimal math
        ldx  #$FF
        txs             ; Set stack pointer

        lda  #$00       ; Begin zeroing out TIA & RAM
Init    sta  $00,x
        dex
        bne  Init
        sta  $00


; Set colors and playfield
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF

        ; Load A with the number we want
		; and show it in the playfield
        lda #%10110111  ; <- Experiment by changing this value
        sta PF1

InfLoop jmp InfLoop     ; Do it all over again...

        org $FFFC
        .word Start
        .word Start



