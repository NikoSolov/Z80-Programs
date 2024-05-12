    ; 207x115 - видимая графическая область

    ;Улучшения:
    ;3. Оптимизировать *
    ;3. Управление наискось

    ld hl, 0ee03h
    ld (hl), 90h
    dec l ; 0ee02h
;    ld (hl), 02h
    dec h
    inc l; 0ed03h
;    ld (hl), 5h
;    ld (hl), 4h
    dec l
    dec l
    dec l
    ld (hl), 0fdh
    inc l
    inc h
    inc h; 0ef01h
    ld (hl),00h
    dec l
    ld (hl),4dh
    ld (hl),3Fh
    ld (hl),03h
    ld (hl),053h
    inc l 
    ld (hl), 27h
    ei
    jp INIT
    ;=====================
SET_DMA:
    push hl
    ld hl, 0ef01h
    ld a,(hl)
CYC3:
    ld a,(hl)
    and 20h
    jp z, CYC3
    inc h
    ld l, 4h
    ld (hl), e
    ld (hl), d
    inc l
    ld (hl), 7Fh
    ld (hl), 53h
    pop hl
    ret
;=====================

INIT:
    ld hl, 0000h
    ld (0ee01h), hl
    ld (COORD), hl
    ld a,l
    ld (DRAW_X), a

    ld hl, 1000h
    ld (DMA_ADDR), hl
    ex de, hl
    call SET_DMA
    ; 0. DRAW PIC
    ld hl, (DMA_ADDR)
    ld de, 18ah
    add hl, de
    ex de, hl

    ld bc, 3a47h
    ; de - vram_addr
    ; b - rows, c - columns
DRAW:
    push de
XYC:
    ld a, (0ee00h)
    ld (de), a
    ld a, (0ee01h)
    inc a
    ld (0ee01h), a
    inc de
    dec c
    jp nz, XYC

    ex de, hl
    ld de, 4eh
    pop hl
    add hl, de
    push hl
    ex de, hl

    ld a, (0ee02h)
    inc a
    ld (0ee02h), a
    ld a, (DRAW_X)
    ld (0ee01h), a

    ld c, 47h
    dec b
    jp nz, XYC
;==============================================================================================================

MAIN:
    ld a, (0ed01h)
    cpl
    and 80h
    call nz, DOWN
    ld a, (0ed01h)
    cpl
    and 20h
    call nz, UP
    ld a, (0ed01h)
    cpl
    and 40h
    call nz, RIGHT
    ld a, (0ed01h)
    cpl
    and 10h
    call nz, LEFT
    jp MAIN
;///////////////////////////////////////////////////////////////////
DOWN:
    ld a, (COORD+1)
    cp 0ffh-39h
    ret z
    inc a
    ld (COORD+1), a
    ;--------------------------------
    ld hl, (COORD)
    ld bc, 3900h
    add hl, bc
    ld (0ee01h), hl

    ld hl, (DMA_ADDR)
    ld bc, 18ah ;3ah*4eh
    add hl, bc
    ;hl - addr of vram

    ld b, 46h
reload:
    ld (hl),00h
    push hl
    ld de, 3ah*4eh
    add hl, de
    ld a, (0ee00h)
    ld (hl),a
    ld a, (0ee01h)
    inc a
    ld (0ee01h), a
    pop hl
    inc hl
    dec b
    jp nz, reload

    ;========================
    ld hl, (DMA_ADDR)
    ld bc, 4eh ;<----- 
    add hl, bc
    ld (DMA_ADDR), hl
    ex de, hl 
    call SET_DMA

    ret
;========================
;///////////////////////////////////////////////////////////////////
UP:
    ld a, (COORD+1)
    or a
    ret z
    ld a, (COORD+1)
    dec a
    ld (COORD+1), a
    ;-----------------------
    ld hl, (COORD)
    ld (0ee01h), hl
    ld hl, (DMA_ADDR)
    ld bc, 13ch
    add hl, bc

    ;------------------------
    ld b, 46h
reload2:
    ld a, (0ee00h)
    ld (hl),a
    push hl
    ld de, 3ah*4eh
    add hl, de
    ld (hl),00h
    ld a, (0ee01h)
    inc a
    ld (0ee01h), a
    pop hl
    inc hl
    dec b
    jp nz, reload2
    ;========================
    ld hl, (DMA_ADDR)
    ld a,l
    sub 4eh
    ld l,a
    jp nc, N_C
    dec h
N_C:
    ld (DMA_ADDR), hl
    ex de, hl 
    call SET_DMA

    ret
;========================
; hl - addr of rom
; de - addr of vram
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;///////////////////////////////////////////////////////////////////
RIGHT:
    ld a, (COORD)
    cp 0ffh-45h
    ret z
    inc a
    ld (COORD), a
    ;========================
    ld hl, (COORD)
    ld bc, 45h
    add hl, bc
    ld (0ee01h), hl

    ld hl, (DMA_ADDR)
    ld bc, 18ah
    add hl, bc

    ; hl - addr of vram
    ld b, 3ah

reload3:
    ld (hl), 00h
    push hl
    ld de, 46h
    add hl, de
    ld a, (0ee00h)
    ld (hl),a
    ld a, (0ee02h)
    inc a
    ld (0ee02h), a
    pop hl
    ld de, 4eh
    add hl, de
    dec b
    jp nz, reload3

    ld hl, (DMA_ADDR)
    inc hl
    ld (DMA_ADDR), hl
    ex de, hl 
    call SET_DMA

    ret
;========================
LEFT:
    ld a, (COORD)
    or a
    ret z
    ld a, (COORD)
    dec a
    ld (COORD), a
    ;========================
    ld hl, (COORD)
    ld (0ee01h), hl

    ld hl, (DMA_ADDR)
    ld bc, 189h
    add hl, bc

    ld b, 3ah

reload4:
    ld a, (0ee00h)
    ld (hl),a
    push hl
    ld de, 46h
    add hl, de
    ld (hl), 00h
    ld a, (0ee02h)
    inc a
    ld (0ee02h), a
    pop hl
    ld de, 4eh
    add hl, de
    dec b
    jp nz, reload4
    ;========================
    ld hl, (DMA_ADDR)
    dec hl
    ld (DMA_ADDR), hl
    ex de, hl 
    call SET_DMA
    ret
;===========================================
;=====================================

DRAW_X: db 00
DMA_ADDR: dw 0000h
pic_addr: dw 0000h
COORD: dw 0000h