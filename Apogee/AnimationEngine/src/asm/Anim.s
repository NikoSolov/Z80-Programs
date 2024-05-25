    ld hl, 5000h
    ld bc, 137fh
clean:
    ld (hl), 00h
    dec bc
    inc hl
    ld a, b
    or c
    jp nz, clean

    ld hl, 0ee03h
    ld (hl), 90h
    dec l           ; 0ee02h
    ld (hl), 01h
    dec h
    inc l           ; 0ed03h
    ld (hl), 5h
    ld (hl), 4h
    ld hl, 0ef01h
    ld (hl),00h
    dec l
    ld (hl),4dh
    ld (hl),3Fh
    ld (hl),03h
    ld (hl),053h
    inc l 
    ld (hl), 27h
    ei
    ld a, (hl)
Cyc2:
    ld a, (hl)
    and 20h
    jp z, Cyc2
    inc h
    ld l, 4h
    ld (hl), 00h
    ld (hl), 50h
    inc l
    ld (hl), 7Fh
    ld (hl), 53h

init:
    ld hl, 518ah
    ld (pos), hl
    ld hl, 0000h
    ld (0ee01h), hl

main:
    ld a, (0ee00h)
    ld b, a
    cp 0ffh
    jp z, init
    cp 0feh
    jp z, pass
    ld a,b
    ld c,80h
    and c
    jp nz, set_pos
    ld a,c
    rra
    ld c,a
    ld a,b
    and C
    jp nz, set_jmp

    ld hl, (pos)
    ld a, (0ee00h)

draw:
    ld (hl),a
    inc hl 
    ld (pos), hl

pass:
    ld hl, (0ee01h)
    inc hl
    ld (0ee01h), hl

    jp main

set_jmp:
    ld a,b
    xor c
    ld b,a

    ld d,00h

    ld hl, (0ee01h)
    inc hl
    ld (0ee01h), hl

    ld a, (0ee00h)
    ld e,a

    ld hl, (pos)
    add hl, de
    ld (pos), hl
    ld a,b
    jp draw

set_pos:
    ld a,b
    xor c
    ld b,a

    ld hl, (0ee01h)
    inc hl
    ld (0ee01h), hl

    ld a, (0ee00h)
    ld d, a

    ld hl, (0ee01h)
    inc hl
    ld (0ee01h), hl

    ld a, (0ee00h)
    ld e,a

    ld hl, 518ah
    add hl, de
    ld (pos), hl
    ld a,b

    jp draw

wait:
    ld hl, 0001h
cyc:
    dec hl
    ld a, l
    or h
    jp nz, cyc
    ld hl, (0ee01h)
    inc hl
    ld (0ee01h), hl
    jp main

pos: dw 0000h