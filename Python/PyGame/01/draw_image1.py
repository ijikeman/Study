""" draw_image1.py """
import sys
import pygame
from pygame.locals import QUIT

pygame.init()
SURFACE = pygame.display.set_mode((600, 400))
FPSCLOCK = pygame.time.Clock()

def main():
    """ main routine """
    logo = pygame.image.load("./Python/PyGame/01/logo.jpg")

    while True:
        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()

        SURFACE.fill((225, 225, 225))

        # 左上が(20, 50)の位置にロゴを表示
        SURFACE.blit(logo, (20, 50))

        pygame.display.update()
        FPSCLOCK.tick(30)

if __name__ == '__main__':
    main()
