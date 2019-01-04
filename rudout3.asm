;---------------------------------------------------------------
;
; Rudimentary output, part 3
; 
; Display the result of a math operation (but using RAM!)
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

; Define a "variable" (a named address in RAM)
BasePay equ $80


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

; Set our base pay "variable" to 42 rupees
        lda #42         ; Load A with 42 (decimal)
        sta BasePay     ; Store contents of A in address BasePay
		
; We get a bonus of 4 rupees!
        lda #4          ; Put 5 in A
        adc BasePay     ; Add the contents of BasePay to A
        sta PF1         ; Show the binary result

InfLoop jmp InfLoop

        org $FFFCw
        .word Start
        .word Start

