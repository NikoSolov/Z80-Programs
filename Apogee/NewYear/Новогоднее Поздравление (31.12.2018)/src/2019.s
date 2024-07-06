ld hl, 0030h
ld c, 1fh
call 0f809h
call 0f818h
mov a,c
jp 0005h

data: db 