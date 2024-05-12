import wave
w = wave.open('pikachu_cries/pikachu_cry_1.wav', 'r')
f = open("sample.BIN", "wb")
print(hex(w.getnframes()//8))
for i in range(w.getnframes()):
    for j in range(8):
        frame = w.readframes(1)
        print (frame)
