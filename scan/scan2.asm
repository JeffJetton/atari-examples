;---------------------------------------------------------------
; 
; A "more correct" way to deal with scanlines. Takes the
; vertical blank and overscan periods into account.
; 
;---------------------------------------------------------------

        processor 6502
        include ../_includes/vcs.h
        include ../_includes/macro.h


        ; Define colors
MyBGCol equ $B0
MyPFCol equ $BC


        org $F000

Start   CLEAN_START


        ; Set colors and playfield config
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF
        lda #1
        sta CTRLPF


Frame
        ; We don't want the viewer to see the beam as it
        ; traces its way back up from the bottom-right to
        ; the top left. So we should really be setting up
        ; each new frame by turning off the beam. As with
        ; VSYNC, we just write 1 in the next-to-last bit
        ; to enable "vertical blanking" mode in VBLANK
        lda #2          ; Same as $%00000010 of course
        sta VBLANK      ; Turn on blanking

        ; Now we turn on VSYNC for three lines, as before
        sta VSYNC       ; Register A still has the 2 in it
        sta WSYNC
        sta WSYNC
        sta WSYNC
        lda #0
        sta VSYNC

        ; At this point we've told the TV to move the beam back up
        ; but this move is done over a certain period of time--
        ; it's not instantaneous. Obviously, we don't want to beam
        ; to be displayed while the move is occuring, so we can't
        ; turn it back on just yet. The standard method on the
        ; VCS is to wait another 37 scanlines worth of time...
        ldx #37
Blank   sta WSYNC
        dex
        bne Blank

        ; NOW we can turn blanking off (i.e., turn the display on)
        lda #0
        sta VBLANK

        ; Note that the entire vertical blanking period--the phase
        ; during which the beam is off during the beginning of
        ; each frame--is a total of 40 scanlines of time.


; The standard "visible" portion of the frame is 192 scanlines
; for NTSC (242 for PAL).

        ; Wait for, oh. let's say 40 scanlines of visible screen
        ; before displaying anything (other than the background)
        ldx #40
Chunk1  sta WSYNC
        dex
        bne Chunk1


        ; Playfield for 8 lines, as before
        lda #%10011101
        sta PF0
        sta PF1
        sta PF2

        lda #8
        tax
Chunk2  sta WSYNC
        dex
        bne Chunk2

        ; Zero out the playfield registers
        txa
        sta PF0
        sta PF1
        sta PF2

        ; Bottom chunk of frame fills out the remaining
        ; visible scanlines (192 - 40 - 8 = 144)
        lda #144
        ;lda #194       ; Uncomment for PAL
        tax
Chunk3  sta WSYNC
        dex
        bne Chunk3

        ; We wrap up by turning the beam OFF again and doing
        ; a final 30 scanlines of "overscan". This leaves
        ; some empty space at the bottom of the image, to
        ; accomodate differences in where the CRT TVs of the
        ; VCS-era would stop displaying.
        lda #2
        sta VBLANK
        ldx #30
OverSc  sta WSYNC
        dex
        bne OverSc
	

        jmp Frame   
        

        org $FFFC
        .word Start
        .word Start







