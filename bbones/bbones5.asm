;--------------------------------------------------------------
;
; Bare-Bones Program #5
;
; Using includes to save ourselves a lot of bother
;
;--------------------------------------------------------------

        processor 6502

        include "../inc/vcs.h"     ; Standard definitions for VCS code
        include "../inc/macro.h"   ; Useful common macros

MyBGCol equ $88

        org $F000

Start   CLEAN_START     ; Macro for efficient initialization
                        ; Actual code comes from macro.h

        ; Main loop
SetTIA  lda #MyBGCol
        sta COLUBK      ; Note that we didn't define COLUBK
                        ; in this file. It's defined in vch.h

        jmp SetTIA


        org $FFFC
        .word Start
        .word Start

