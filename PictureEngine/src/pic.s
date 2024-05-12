INIT:
    ld hl, 0ef01h
    ld (hl), 00h
    dec l
    ld (hl), 4dh
    ld (hl), 3fh
    ld (hl), 53h
    ld (hl), 53h 
    inc l
    ld (hl), 27h
    ld a, (hl)
WAIT_FOR_END_OF_FRAME:
    ld a, (hl)
    and 20h
    jp z, WAIT_FOR_END_OF_FRAME
    ld hl, 0f008h
    ld (hl), 80h
    ld l, 04h
    ld (hl), 30h
    ld (hl), 00h
    inc l
    ld (hl), 7Fh
    ld (hl), 53h
    ld l, 08h
    ld (hl), 0a4h
    ei
    jp 0f86ch