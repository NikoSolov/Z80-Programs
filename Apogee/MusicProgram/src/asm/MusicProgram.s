;===============================
PAGES:
	jp nc, INIT
	jp MAIN
	PAGE1: db 0h, 0h
	jp nc, COUNT_DEC
	jp COUNTER_DEC
	PAGE2: db 0h, 0h
	jp nc, MUSIC
	jp MUSIC_LOAD

INIT:
	; /// change to MUSIC ///
	ld hl, 0ed03h
	ld (hl), 8
	inc h
	ld (hl), 90h
	ld hl, END_ROM
NEW:
	;LOAD_FROM_CARTRIDGE:
	;	ld (0ee01h), hl
	;	ld a, (0ee00h)
	;	ld (hl),a
	;	dec hl
	;	ld a,h
	;	or l
	;	jp nz, LOAD
	; //////////////////////
	ld a, 00h  ; M22 to set music number
	ld (MUSIC_NUMBER), a
	xor a
	ld (STATUS), a
	ld hl, 0ee02h
	ld (hl), 1H
	dec h
	inc l
	ld (hl), 5H
	ld (hl), 4h

	scf 
	rst 10h

;/////////////////////////////////
MAIN:
	ld b,08h
	ld hl, METRONOM_COUNTER
	scf
	rst 08h
	;-----------
	ld a, (STATUS)
	and 08h
	jp nz, NOT
	ld hl, CH1_COUNTER
	ld b, 04h
COUNT_CHECK:
	cp a
	rst 08h
	inc hl
	ld a, b
	rra
	ld b, a
	or a
	jp nz, COUNT_CHECK

NOT:
	;======================
	ld a, (STATUS)
	and 08h
	jp nz, NOT_NOW
	ld hl, (SET_METRONOM_COUNTER)
	ld (METRONOM_COUNTER), hl
	ld a, (STATUS)
	or 08h
	ld (STATUS), a

NOT_NOW:

	ld hl, CH1_ADDR
	ld b, 04h

MUSIC_CHECK:
	cp a
	rst 10h
	inc hl
	inc hl
	ld a,b
	rra
	ld b,a
	or a
	jp nz, MUSIC_CHECK
	jp MAIN

;===================
COUNTER_DEC:
	ld a, (STATUS)
	and b
	ret z
	ld a, (hl)
	inc hl
	or (hl)
	jp z, ZERO_COUNTER
	ld d, (hl)
	dec hl
	ld e, (hl)
	dec de
	ld (hl),e
	inc hl
	ld (hl),d
	dec hl
	ret
;=====================
COUNT_DEC:
	ld a, (STATUS)
	and b
	ret z
	ld a, (hl)
	or a
	jp z, ZERO_COUNTER
	dec (hl)
	ret
;~~~~~~~~~~~~~~~~~~~
ZERO_COUNTER:
	ld a, (STATUS)
	xor b
	ld (STATUS), a
	ret
;======={/MUSIC\}===========
MUSIC_LOAD:
	ld a, (MUSIC_NUMBER)
	and 1fh
	rla
	rla
	rla
	ld l,a
	ld a, (MUSIC_NUMBER)
	and 0e0h
	rlca
	rlca
	rlca
	ld h,a
	ld de, CH1_ADDR
	ld b,8h
LOADM:
	ld (0ee01h), hl
	ld a, (0ee00h)
	ld (de), a
	inc hl
	inc de
	dec b
	jp nz, LOADM
	ret
;======={/MUSIC\}===========
MUSIC:
	;dnnn.oooo
	ld a, (STATUS)
	and b
	ret nz
	;======SET NOTE=========
	ld e, (hl)
	inc hl
	ld d, (hl)
	dec hl
	ex de, hl
	ld (0ee01h), hl
	ld a, (0ee00h)
	cp 0ffh
	jp nz, NOT_RET
	scf 
	rst 10h
	ret

NOT_RET:
	inc hl
	inc hl
	ex de, hl
	ld (hl),e
	inc hl
	ld (hl),d
	;-----
	dec hl
	; addr of counts
	push hl ; --------------> 0

	;====================
	ld hl, NOTE
	ld a, (0ee00h)
	and 0f0H
	rra
	rra
	rra
	or A
	jp z, NONE
	;////////////////
	sub 2H
	ld e,a
	xor a
	ld d,a
	add hl, de
	; hl - addr
	; de - note
	ld e, (hl)
	inc hl
	ld d, (hl)
	ex de, hl

	;======SET OCTAVE========
	ld a, (0ee00h)
	and 07H
	ld c,A
;=======================
HEX_BIT_RRC:
	ld a, c
	or A
	jp z, RRC_Done
	dec c
	ld a,L
	rra
	ld L,A
	cp a ; carry set 0
	ld a,H
	rra
	ld h,a
	jp nc, NOT_CARRY2
	ld a,l
	or 80H
	ld l,a
NOT_CARRY2:
	jp HEX_BIT_RRC
	; ========================
RRC_Done:
	ex de, hl
	; de - note
	ld hl, 0EC00H
	ld a,b
	and 3h
	ld L,A
	ld (hl),e
	ld (hl),d

	ld a, (STATUS)
	or b
	ld (STATUS), a
	jp SET_DURATION

NONE: 
	ld a, B
	and 03h
	rrca
	rrca
	or 3eh
	ld (0EC03H), a
	ld a, (STATUS)
	or b
	ld (STATUS), a

SET_DURATION:
	ld hl, (0ee01h)
	inc hl
	ld (0ee01h), hl
	ld hl, CH1_COUNTER
	ld a,b
	and 3H
	jp z, NON
	xor 3H
NON:
	ld e,a
	xor a
	ld d,a
	add hl, de
	ld a, (0ee00h)
	ld (hl),a
	pop hl ; <------------- 0
	ret

NOTE: dw 0D270H,0C669H,0BBB0H,0B210H,0A960H,9DD4H,96F7H,8DB9H,858CH,7E43H,77BBH,7001H

END_ROM:
;============ ram part ==============
STATUS: db 00h

METRONOM_COUNTER: dw 0000h

MUSIC_NUMBER: db 00h

CH1_ADDR: dw 0000h
CH2_ADDR: dw 0000h
CH3_ADDR: dw 0000h
SET_METRONOM_COUNTER: dw 0000h

CH1_COUNTER: db 00h
CH2_COUNTER: db 00h
CH3_COUNTER: db 00h
