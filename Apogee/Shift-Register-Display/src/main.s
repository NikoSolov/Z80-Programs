lxi h, 0ee03h
mvi m, 0b10000000

;port c d0 - data; d1 - clock; d2 - latch

lxi d, 1234h

main
mov a,e
ani 0fh

call setCode

mov a,e
ani 0f0h
rar
rar
rar
rar

call setCode

mov a,d
ani 0fh

call setCode

mov a,d
ani 0f0h
rar
rar
rar
rar

call setCode

lxi h, 0ee03h
mvi m, 0b00000101
mvi m, 0b00000100
inx d
jmp main

setCode:
mov c,a
mvi b, 00

lxi h, num_code
dad b
mov a,m

lxi h, 0ee03h
mvi b, 8h
shiftOut
ral
jnc zero
mvi m, 0b00000001
jmp clock
zero
mvi m, 0b00000000
clock
mvi m, 0b00000011
mvi m, 0b00000010
cmp a
dcr b
jnz shiftOut
ret

num_code: db 0b00000011, 0b10011111,0b00100101,0b00001101,0b10011001,0b01001001,0b01000001,0b00011111, 0b00000001,0b00001001, 0b00010001, 0b11000001, 0b01100011, 0b10000101, 0b01100001, 0b01110001