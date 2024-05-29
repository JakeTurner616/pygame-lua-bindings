import pygame

def play_sound(file_path):
    try:
        sound = pygame.mixer.Sound(file_path)
        sound.play()
    except Exception as e:
        print(f"Error playing sound: {e}")

def play_music(file_path):
    try:
        pygame.mixer.music.load(file_path)
        pygame.mixer.music.play()
    except Exception as e:
        print(f"Error playing music: {e}")
