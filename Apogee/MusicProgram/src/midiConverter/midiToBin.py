from mido import MidiFile
import os

# ------ config file --------------
folderName = "music1"
metronomeList = [0x90, 0x130, 0x120, 0x100, 0x180]
# ----------------------------------
playlistFolder = f"../../res/{folderName}/"
playlistFile = f"../../res/Playlist_{folderName}.rom"
listOfMusicFiles = os.listdir(playlistFolder)
numOfMusicFiles = len(listOfMusicFiles)
fileOut = open(playlistFile, "wb")

addr = []
offset = 8 * numOfMusicFiles  # отступ в файле
for fileNum in range(numOfMusicFiles):
    # initialization
    print(listOfMusicFiles[fileNum])
    mid = MidiFile(playlistFolder + listOfMusicFiles[fileNum])
    musicData = [[], [], []]
    # ---- get_min_time_of_note --------
    metro = 100000000000000
    for msg in mid:
        if msg.type == 'note_on' or msg.type == 'note_off':
            if msg.time < metro and msg.time != 0: metro = msg.time
    print("metronome:", metro)
    # --------------------------------------
    for channelNum in range(3):
        time = 0
        note = 0
        print("channel", channelNum)
        # --------- read messages from midi files ---------
        for msg in mid:
            time += msg.time / metro
            # пока нота не изменится, считаем время
            # последней ноты или паузы
            if msg.type == 'note_on' and msg.channel == channelNum:
                # если звучит новая нота
                if time > 0:
                    # если звучала нота раньше не звучала

                    # ------- оформляем паузы ---------
                    while time > 256:
                        musicData[channelNum].append(0x0)
                        musicData[channelNum].append(0xff)
                        time -= 256
                    musicData[channelNum].append(0x0)
                    musicData[channelNum].append(int(time - 1))
                    # print(int(time-1))
                # ---------------------------------
                # сохраняем код ноты
                note = (msg.note % 12 + 1) * 16 + (msg.note // 12) - 2
                musicData[channelNum].append(note)
                time = 0
            elif msg.type == "note_off" and msg.channel == channelNum:
                # Если нота перестала звучать
                # сохраняем код длительности
                musicData[channelNum].append(int(time - 1))
                # print(int(time-1))
                time = 0
        # ---------- Оформление конца музыки -------------------
        while time > 256:
            musicData[channelNum].append(0x0)
            musicData[channelNum].append(0xff)
            time -= 256
        musicData[channelNum].append(0x0)
        musicData[channelNum].append(int(time - 1))
        musicData[channelNum].append(0xff)
        musicData[channelNum].append(0x0)
    # -----------------------------------------------------
    #   print(256 in c)
    # ----------- Сохраняем адреса и ноты в общий массив --
    for channelNum in range(3):
        # отступаем место
        fileOut.seek(offset, 0)
        # записываем канал
        fileOut.write(bytearray(musicData[channelNum]))
        addr.append(offset % 256)
        if offset > 256:
            addr.append(offset // 256)
        else:
            addr.append(0)
        # -----------------------------------------
        # Увеличиваем отступ на один канал музыки
        offset += len(musicData[channelNum])
    # сохраняем метроном !!!
    print(metro,
          metronomeList[fileNum % numOfMusicFiles],
          metronomeList[fileNum % numOfMusicFiles] / metro,
          metronomeList[fileNum % numOfMusicFiles] * metro
          )
    addr.append(metronomeList[fileNum % numOfMusicFiles] % 256)
    addr.append(metronomeList[fileNum % numOfMusicFiles] // 256)


# Запись массив адресов в файл
fileOut.seek(0, 0)
fileOut.write(bytearray(addr))
# ----------------------------
fileOut.close()
print("file closed")
