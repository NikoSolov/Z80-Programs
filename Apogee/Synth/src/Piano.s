C1	=	1A8BH
C1_SH	=	1A0EH
D1	=	17A6H
D1_SH	=	1652H
E1	=	1511H
F1	=	13E3H
F1_SH	=	12C5H
G1	=	11B7H
G1_SH	=	10B9H
A1	=	0FC8H
A1_SH	=	0EE6H
H1	=	0E10H

C2	=	0D46H
C2_SH	=	0C87H
D2	=	0BD3H
D2_SH	=	0B29H
E2	=	0A89H
F2	=	09F1H
F2_SH	=	0962H
G2	=	08DCH
G2_SH	=	085CH
A2	=	07E4H
A2_SH	=	0773H
H2	=	0708H

C3	=	06A3H
C3_SH	=	0643H
D3	=	05E9H
D3_SH	=	0594H
E3	=	0544H
F3	=	04F9H
F3_SH	=	04B1H
G3	=	046EH
G3_SH	=	042EH
A3	=	040AH
A3_SH	=	03C9H
H3	=	0384H
;////////////////////////////////////////////////////
    ld C, 1FH
    call 0F809H
    ld hl, NOTES
    call 0F818H
    ld hl, NOTES
    call 0F818H
    ld hl, NOTES
    call 0F818H
    ld C, 0CH
    call 0F809H


    ld A, 3EH
    ld (0ec03h), a
    ld C, 0CH
    call 0F809H
    ld hl, 0H
;////////////////////////////////////////////////////
MAIN:
    call 0f81bh
    cp 0X3B
    jp z, NOTE_C1

    call 0f81bh
    cp 0X31
    jp z, NOTE_C1_SH

    call 0f81bh
    cp 0X32
    jp z, NOTE_D1

    call 0f81bh
    cp 0X33
    jp z, NOTE_D1_SH

    call 0f81bh
    cp 0X34
    jp z, NOTE_E1

    call 0f81bh
    cp 0X35
    jp z, NOTE_F1

    call 0f81bh
    cp 0X36
    jp z, NOTE_F1_SH

    call 0f81bh
    cp 0X37
    jp z, NOTE_G1

    call 0f81bh
    cp 0X38
    jp z, NOTE_G1_SH

    call 0f81bh
    cp 0X39
    jp z, NOTE_A1

    call 0f81bh
    cp 0X30
    jp z, NOTE_A1_SH

    call 0f81bh
    cp 0X2D
    jp z, NOTE_H1
    ;//////////////////////////////////////////////
    call 0f81bh
    cp 0X4A
    jp z, NOTE_C2

    call 0f81bh
    cp 0X43
    jp z, NOTE_C2_SH

    call 0f81bh
    cp 0X55
    jp z, NOTE_D2

    call 0f81bh
    cp 0X4B
    jp z, NOTE_D2_SH

    call 0f81bh
    cp 0X45
    jp z, NOTE_E2

    call 0f81bh
    cp 0X4E
    jp z, NOTE_F2

    call 0f81bh
    cp 0X47
    jp z, NOTE_F2_SH

    call 0f81bh
    cp 0X5B
    jp z, NOTE_G2

    call 0f81bh
    cp 0X5D
    jp z, NOTE_G2_SH

    call 0f81bh
    cp 0X5A
    jp z, NOTE_A2

    call 0f81bh
    cp 0X48
    jp z, NOTE_A2_SH

    call 0f81bh
    cp 0X3A
    jp z, NOTE_H2

    ;//////////////////////////////////////////////
    call 0f81bh
    cp 0X46
    jp z, NOTE_C3

    call 0f81bh
    cp 0X59
    jp z, NOTE_C3_SH

    call 0f81bh
    cp 0X57
    jp z, NOTE_D3

    call 0f81bh
    cp 0X41
    jp z, NOTE_D3_SH

    call 0f81bh
    cp 0X50
    jp z, NOTE_E3

    call 0f81bh
    cp 0X52
    jp z, NOTE_F3

    call 0f81bh
    cp 0X4F
    jp z, NOTE_F3_SH

    call 0f81bh
    cp 0X4C
    jp z, NOTE_G3

    call 0f81bh
    cp 0X44
    jp z, NOTE_G3_SH

    call 0f81bh
    cp 0X56
    jp z, NOTE_A3

    call 0f81bh
    cp 0X5C
    jp z, NOTE_A3_SH

    call 0f81bh
    cp 0X2E
    jp z, NOTE_H3


    ;//////////////////////////////////////////////
    cp 0XFF
    jp z, NONE

    jp MAIN
;////////////////////////////////////////////////////

;////////////////////////////////////////////////////
NOTE_C1:
    ld de, C1
    ld hl, 0
    jp CON

NOTE_C1_SH:
    ld de, C1_SH
    ld hl, 2H
    jp CON

NOTE_D1:
    ld de, D1
    ld hl, 5H
    jp CON

NOTE_D1_SH:
    ld de, D1_SH
    ld hl, 7H
    jp CON

NOTE_E1:
    ld de, E1
    ld hl, 0AH
    jp CON

NOTE_F1:
    ld de, F1
    ld hl, 0CH
    jp CON

NOTE_F1_SH:
    ld de, F1_SH
    ld hl, 0EH
    jp CON

NOTE_G1:
    ld de, G1
    ld hl, 11H
    jp CON

NOTE_G1_SH:
    ld de, G1_SH
    ld hl, 13H
    jp CON

NOTE_A1:
    ld de, A1
    ld hl, 16H
    jp CON

NOTE_A1_SH:
    ld de, A1_SH
    ld hl, 18H
    jp CON

NOTE_H1:
    ld de, H1
    ld hl, 1BH
    jp CON


;////////////////////////////////////////////////////
;////////////////////////////////////////////////////
NOTE_C2:
    ld de, C2
    ld hl, 0200H
    jp CON

NOTE_C2_SH:
    ld de, C2_SH
    ld hl, 0202H
    jp CON

NOTE_D2:
    ld de, D2
    ld hl, 0205H
    jp CON

NOTE_D2_SH:
    ld de, D2_SH
    ld hl, 0207H
    jp CON

NOTE_E2:
    ld de, E2
    ld hl, 020AH
    jp CON

NOTE_F2:
    ld de, F2
    ld hl, 020CH
    jp CON

NOTE_F2_SH:
    ld de, F2_SH
    ld hl, 020EH
    jp CON

NOTE_G2:
    ld de, G2
    ld hl, 0211H
    jp CON

NOTE_G2_SH:
    ld de, G2_SH
    ld hl, 0213H
    jp CON

NOTE_A2:
    ld de, A2
    ld hl, 0216H
    jp CON

NOTE_A2_SH:
    ld de, A2_SH
    ld hl, 0218H
    jp CON

NOTE_H2:
    ld de, H2
    ld hl, 021BH
    jp CON


;////////////////////////////////////////////////////
NOTE_C3:
    ld de, C3
    ld hl, 0400H
    jp CON

NOTE_C3_SH:
    ld de, C3_SH
    ld hl, 0402H
    jp CON

NOTE_D3:
    ld de, D3
    ld hl, 0405H
    jp CON

NOTE_D3_SH:
    ld de, D3_SH
    ld hl, 0407H
    jp CON

NOTE_E3:
    ld de, E3
    ld hl, 040AH
    jp CON

NOTE_F3:
    ld de, F3
    ld hl, 040CH
    jp CON

NOTE_F3_SH:
    ld de, F3_SH
    ld hl, 040EH
    jp CON

NOTE_G3:
    ld de, G3
    ld hl, 0411H
    jp CON

NOTE_G3_SH:
    ld de, G3_SH
    ld hl, 0413H
    jp CON

NOTE_A3:
    ld de, A3
    ld hl, 0416H
    jp CON

NOTE_A3_SH:
    ld de, A3_SH
    ld hl, 0418H
    jp CON

NOTE_H3:
    ld de, H3
    ld hl, 041BH
    jp CON


;////////////////////////////////////////////////////


NONE:
    ld A, 3EH
    ld (0ec03h), a
    jp MAIN

CON:
    ld A, E
    ld (0ec00h), a
    ld A, D
    ld (0ec00h), a
    call CHANGE
    jp MAIN

CHANGE:
    ld C, 80H
    call 0F809H
    ld C, 0CH
    call 0F809H

RIGHT:
    ld A,L
    or A
    jp z, DOWN
    ld C, 18H
    call 0F809H
    dec L
    jp RIGHT

DOWN:
    ld A,H
    or A
    jp z, CON1
    ld C, 1AH
    call 0F809H
    dec H
    jp DOWN

CON1:
    ld C, 81H
    call 0F809H
    ld C, 08H
    call 0F809H
    ret

NOTES: DB 0X80,"C", 0X80,"C#", 0X80,"D", 0X80,"D#", 0X80,"E", 0X80,"F", 0X80,"F#", 0X80,"G", 0X80,"G#", 0X80,"A", 0X80,"A#", 0X80,"H", 0X80, 0X0A, 0X0D,0X0A, 0X0D,00
