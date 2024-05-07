; PROGRAMM FOR АПОГЕЙ БК-01Ц
; PROGRAMM STORES IN CARTRDGE WITH PAGES
; PAGES:
; 1) MAIN_PROGRAMMS: 
; 2) SONGS
; 3) ANIMATIONS?
; EE00, EE01, EE02 - DATA, ADDRl, ADDRh
; EE03 - SETUP COMPONENT
; ED03<=(5,4) - SET REGISTER IN EE02<=(PAGE_NUMBER) 
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; XOR A -> A=0
; CMP A -> SET FLAGS: ZERO,PARITY=1; SIGN,CARRY=0
; STC   -> SET CARRY=1
; CMC   -> CHANGE CARRY 1->0 0->1
;============  LOAD ALL PROGRAMM ===================
START_LOAD:
; -- set 8255 --
    LD hl, $0EE03
    LD (hl), $90
; -- load rest from cartridge (FROM END TO 0000) --
    LD HL, END_ROM-1  ; SET HL = ADDR END OF PROGRAMM

LOAD:
    LD ($EE01), hl     ; SET ADDR OF CARTRIDGE
    LD A, ($EE00)      ; GET BYTE FROM CARTRIDGE
    LD (HL), A         ; LOAD BYTE TO MEMORY
    DEC HL           ; DECREMENT ADDR 
    LD A, H         ; CHECK FOR CARTRIDGE ADDR->
    OR L           ; -> SET 0000
    JP NZ, LOAD        ; IF IT IS NOT, GET IN CYCLE
; =================================================
INIT:
    ; ---------------- CLEAN RAM --------------
    LD HL, END_ROM-1    ; HL = ADDR END OF PROGRAMM
    ICHL:               ; CYCLE OF ERASE
        INC HL               ; INCREASE HL
    ERASE:              ;
    XOR A               ; A=0
    LD (HL), A            ; SET BYTE OF MEM TO 0
    LD A, H            ; 
    CP 0EBH            ; CHECK H == E0
    JP NZ, ICHL            ; IF H != E0: GO ICHL
    LD A, L            ;
    CP 0FFH            ; CHECK L == FF
    JP NZ, ICHL            ; IF L != FF: GO ICHL
                        ; ELSE: GO NEXT
    ; -----------------------------------------
    ; -- set 8253 --
    LD HL, 0ED03H
    LD (HL), 8AH
    ; ---------------
    ; -- SET VALUES --
    LD A,00H           ; SET MUSIC_NUMBER (SHOULD EDIT)
    ; STA MUSIC_NUMBER    ;
    LD (MUSIC_NUMBER), A
    XOR A               ; A=0
    ;STA STATUS          ; SET STATUS?
    LD (STATUS), A
    ; ----------------
    ; -- SET PAGE FROM MUSIC (1) --
    LD A, $1
    CALL SET_PAGE
    ; -----------------------------
    CALL MUSIC_LOAD
;============== MAINLOOP ===========================
MAIN:
    ; -- CHECK METRONOM SETS 0
    ;LHLD METRONOM       ; GET METRONOM
    LD HL, (METRONOM)
    LD A, H             ;
    OR L               ; 
    JP NZ, DEC_METRO       ; IF METRONOM != 0: 
;-------------------------------------------------------
MUSIC_CHECK:        ; ELSE: MUSIC_CHECK 
    LD HL, CH1_ADDR

CHANNELS_CHECK:
    LD A, (HL)
    OR A
    ;JZ CHANGE_NOTE
    DEC (HL)
    DEC B
    JP NZ, CHANNELS_CHECK
    ; AFTER CHECKING SET_METRONOM
    ;LHLD SET_METRONOM_COUNTER   ;
    LD HL, (SET_METRONOM_COUNTER)
    ;SHLD METRONOM               ; SET METRONOM
    LD (METRONOM), HL
    JP END_OF_MUSIC            ; JUMP TO NEXT PROGRAMM
;---------------------------------------------------------
DEC_METRO:          ;
    DEC HL               ; DECREASE METRONOM
    LD (METRONOM), HL       ; AND STORE BACK
END_OF_MUSIC:       ; END OF MUSIC PROGRAMM
; ----------------------------------------------------------
; == SPACE FOR ANOTHER PROGRAMM ==
; ------------------------------------------------------------
    JP MAIN            ; BACK TO BEGIN OG MAINLOOP
;===================================================
; -------- FUNC: SET PAGE OF MEMORY (A - PAGE_NUMBER)----------
SET_PAGE:
    PUSH HL
    LD HL, 0EE02H
    LD (HL), A
    DEC H           ; HL = 0ED02H
    INC L           ; HL = 0ED03H
    LD (HL), 5H
    LD (HL), 4H
    POP HL
    RET
; -------------------------------------------
; --- FUNC: LOAD MUSIC INFO BY MUSIC_NUMBER --
MUSIC_LOAD:
    ; MUSIC_NUM => HEADER ADDRESS
    ; XXXX.XXXX => 0000.0XXX XXXX.X000
    ; HHHL.LLLL => 0000.0HHH LLLL.L000
    LD HL, 0H
    LD B, 3            ; ROTATE 3 TIMES
    ;LDA MUSIC_NUMBER    ; GET MUSIC_NUMBER
    LD A, (MUSIC_NUMBER)
    LD L, A

SHIFT_CYCLE:
    CP A               ; SET CARRY = 0
    LD A,L
    RLA
    LD L,A
    LD A, H
    RLA
    LD H,A
    DEC B
    JP NZ, SHIFT_CYCLE
    ; LOAD IN VARIABLES
                        ; HL - ADDR OF HEADER
    LD DE, CH1_ADDR     ; DE - ADDR OF VARIABLES
    LD B,8H            ; B  - COUNT OF BYTES
    ; CYCLE OF LOAD
loadM:
    ;SHLD 0EE01H         ; SET CARTRIDGE ADDR
    LD (0EE01H), HL
    ;LDA 0EE00H          ; GET BYTE 
    LD A, (0EE00H)
    ;STAX D              ; STORE BYTE IN VARIABLE              
    LD (DE), A
    INC HL               ; INCREASE HL |
    INC DE               ; INCREASE DE |
    DEC B               ; DECREASE B  |
    JP NZ, loadM           ; IF B!=0: GO loadM
    RET
    ; --------------------------------------







;=========== costants ==============
note: 
    DW $0D270,$0C669,$0BBB0,$0B210,$0A960,$9DD4,$96F7,$8DB9,$858C,$7E43,$77BB,$7001

END_ROM:
;============ valuerables ==============
STATUS: 
    DB $00

METRONOM: 
    DW $0000

MUSIC_NUMBER: 
    DB $00

CH1_ADDR: 
    DW $0000
CH2_ADDR: 
    DW $0000
CH3_ADDR: 
    DW $0000
SET_METRONOM_COUNTER: 
    DW $0000

CH1_COUNTER: 
    DB $00
CH2_COUNTER: 
    DB $00
CH3_COUNTER: 
    DB $00