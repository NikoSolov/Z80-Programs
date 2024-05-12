import pygame
buffer = [[0] * 70 for i in range(58)]
root=pygame.display.set_mode((210*scale,116*scale))
clock=pygame.time.Clock()
screen=pygame.Surface(size)
game=True
byte_arr = []
posX=0
posY=0
#---------  User Values -----------

scale=7
show=True
save=True
pic=pygame.image.load("Sprite.png")    

n=1
cube=pygame.Surface((50,50), pygame.SRCALPHA)
cube.fill((255,255,255))
#----------------------------------
while game:
    for event in pygame.event.get():
        if event.type==pygame.QUIT: game=False
    keys = pygame.key.get_pressed()
#----------------  User Space  ----------------
    if keys[pygame.K_ESCAPE]: game=False
    screen.fill((0,0,0))
    pic=pygame.image.load("sans/sans{}.png".format(n))
#    screen.blit(pygame.transform.rotate(cube, n), (210//2-25,116//2-25))
    screen.blit(pic, (0,0))




#----------------------------------------------
    if save==True:
        for y in range(size[1]//2):
            for x in range(size[0]//3):
                s=0
                for i in range(6):
                    if screen.get_at((i%3+x*3,i//3+y*2))!=(0,0,0):
                        s+=2**(i%3)*(i//3==0)+8*2**(i%3)*(i//3==1)
                if s!=buffer[y][x]:
                    if y-posY==0 and x-posX<3 and x-posX>0:
                        for i in range(1,x-posX):
                            byte_arr.append(buffer[y][posX+i])
                        byte_arr.append(s)
                    elif (y-posY)*78+(x-posX)<256 and (y-posY)*78+(x-posX)>0:
                        byte_arr.append(s+64)
                        byte_arr.append((y-posY)*78+(x-posX)-1)
                    else:
                        byte_arr.append(s+128)
                        byte_arr.append((y*78+x)//256)
                        byte_arr.append((y*78+x)%256)

                    buffer[y][x]=s
                    posX=x
                    posY=y                
        byte_arr.append(254)
    if show==True:
        root.blit(pygame.transform.scale(screen, (size[0]*scale,size[1]*scale)), (0,0))    
        pygame.display.update()    
        clock.tick(60)    
pygame.quit()
print("Done")
#//////////////////////////////////////////////////
if save==True:
    byte_arr.append(255)
    f = open("HNYSans.bin", "wb")
    f.write(bytearray(byte_arr))
    f.close()
    print("file closed")

