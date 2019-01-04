;---------------------------------------------------------------
;
; Rudimentary output, part 2
; 
; Display the result of a math operation
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

; What's 2 + 3?
DoMath  lda #2          ; Load A with 2
        adc #3          ; Add 3 to whatever's in A
        sta PF1         ; Show the result (in binary)

        jmp DoMath

        org $FFFC
        .word Start
        .word Start



