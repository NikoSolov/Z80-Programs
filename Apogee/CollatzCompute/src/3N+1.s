

ld a,10h
ld (value_c), a
ld c, a

Init:
ld hl, value_d
Increment:
inc (hl)
jp nz, Load
dec c
jp z, End
inc hl
jp Increment

Load:
ld a, (value_c)
ld c,a
ld b, 0h
ld hl, value_d
ld de, value_d+10h
ldir

Main:
ld a, (value_d+10h )
and 01h
jp z, shift
jp check

shift:
ld a, (value_c)
ld c,a
ld hl, value_d+20h
scf
ccf

cyc:
dec hl
rr (hl)
dec c
jp nz, cyc
jp Main
;----------------------------------
check:
ld a, (value_d+10h)
cp 01h
jp nz, nplus 
ld a, (value_c)
ld c,a
ld hl, value_d+1fh
dec c

checking:
ld a,(hl)
cp 0h
jp nz, nplus
dec hl
dec c
jp nz, checking
jp Init
;----------------------------------
nplus:
; load mult
ld a, (value_c)
ld c,a
ld b, 0h
ld hl, value_d+10h
ld de, value_d+20h
ldir
; first addition
ld hl, value_d+10h
ld de, value_d+20h
scf
ccf
ld a, (value_c)
ld c,a

adic1:
ld b,(hl)
ld a,(de)
adc a, b
ld (hl),a
inc hl
inc de
dec c
jp nz, adic1

; second addition
ld hl, value_d+10h
ld de, value_d+20h

scf

ld a, (value_c)
ld c,a

adic2:
ld b,(hl)
ld a,(de)
adc a, b
ld (hl),a
inc hl
inc de
dec c
jp nz, adic2
jp c, End

jp Main

End: 
jp End


value_c: db 0fh
org 0B0h
value_d: db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h 
value: db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h 