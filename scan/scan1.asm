;---------------------------------------------------------------
;
; Our first attempt to deal with scanlines and create a
; genuine stable frame
; 
; Display the playfield on just one horizontal line
; (Instead of all the way down the screen)
; NTSC/PAL autodetect should now work!
;
;---------------------------------------------------------------

        processor 6502
        include ../_includes/vcs.h
        include ../_includes/macro.h


        ; Define our colors
MyBGCol equ $72
MyPFCol equ $18


        org $F000
        
Start   CLEAN_START

        ; Set colors
        lda #MyBGCol
        sta COLUBK
        lda #MyPFCol
        sta COLUPF
		
        ; Configure playfield to mirror rather than copy
        lda #%00000001  ; Controlled by the rightmost bit
        sta CTRLPF
		

Frame
        ; Begin a frame by telling the TIA to send a "vertical sync"
        ; signal to the TV, which instructs the TV to move the beam
        ; back up to the top of the screen.
        ; The VSYNC signal is sort of a special version of the
        ; signal the TIA already puts at the end of every line.
        ; We just need to tell the TIA to switch over to the
        ; mode where it outputs this variant signal instead of the 
        ; regular one. Do this by setting the second-from-left bit
        ; of the VSYNC register address to 1
        lda #%00000010
        sta VSYNC

        ; We are required to send the VSYNC signal for the
        ; equivalent of three scanlines worth of time.
        ; Anything stored in WSYNC will trigger a wait until
        ; the end of the current scanline. We'll do three of 'em.
        sta WSYNC
        sta WSYNC
        sta WSYNC

        ; We've now correctly told the TV that it's time to
        ; move back up to the top. So turn VSYNC mode off...
        lda #0
        sta VSYNC
		
        
; NTSC frames last a total of 262 scanlines worth of time.
; For PAL systems, it's 312. We've already used up three for
; the VSYNC portion. We'll divide the remaining 259 (or 309)
; into three chunks:
		
        ; First, wait for 100 scanlines worth of time.
        ; During this period, the playfield registers are not set,
        ; so only the background will show.
        ldx #100
Chunk1  sta WSYNC       ; Wait for horizontal sync at end of line
        dex
        bne Chunk1
		
        ; At this point, the TV's beam will be scanning somewhere
        ; near the middle-ish part of the screen.
		
        ; Now set some playfield bits
        lda #%10101010
        sta PF0
        sta PF1
        sta PF2
		
        ; Continue displaying the playfield for 8 lines
        ldx #8
Chunk2  sta WSYNC
        dex
        bne Chunk2
		
        ; Zero out the playfield registers
        ; Note that X still contains zero at this point
        txa             ; Transfer X to A
        sta PF0
        sta PF1
        sta PF2
		
        ; Wait around while the last 151 (NTSC) or
        ; 201 (PAL) scanlines are drawn
        ldx #151
        ;ldx #201       ; Uncomment for PAL
Chunk3  sta WSYNC
        dex
        bne Chunk3

        jmp Frame       ; We're ready to start the next frame


        org $FFFC
        .word Start
        .word Start
		







