import sys
import pygame

from pygame.locals import QUIT

pygame.init() # 初期化

SURFACE = pygame.display.set_mode((400, 300)) # ウィンドウサイズを指定
pygame.display.set_caption("Just Window")

def main():
    """ main routine """
    while True:
        SURFACE.fill((255, 255, 255)) # Windowを呼び出す

        for event in pygame.event.get(): # Eventキューからイベントを呼び出す
          if event.type == QUIT: # イベントがQUITなら終了する
             pygame.quit()
             sys.exit()

        pygame.display.update() # 再描画
    
if __name__ == '__main__':
    main()
