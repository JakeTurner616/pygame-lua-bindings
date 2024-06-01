import pygame


# Initialize mixer
pygame.mixer.init(
    frequency=22050,
    size=-16,
    channels=2,
    buffer=512,
    )

# Wrapper functions for pygame.mixer.music methods
def music_load(filename):
    pygame.mixer.music.load(filename)

def music_unload():
    pygame.mixer.music.unload()

def music_play(loops=0, start=0.0, fade_ms=0):
    pygame.mixer.music.play(loops, start, fade_ms)

def music_rewind():
    pygame.mixer.music.rewind()

def music_stop():
    pygame.mixer.music.stop()

def music_pause():
    pygame.mixer.music.pause()

def music_unpause():
    pygame.mixer.music.unpause()

def music_fadeout(time):
    pygame.mixer.music.fadeout(time)

def music_set_volume(volume):
    pygame.mixer.music.set_volume(volume)

def music_get_volume():
    return pygame.mixer.music.get_volume()

def music_get_busy():
    return pygame.mixer.music.get_busy()

def music_set_pos(pos):
    pygame.mixer.music.set_pos(pos)

def music_get_pos():
    return pygame.mixer.music.get_pos()

def music_set_endevent(type=None):
    pygame.mixer.music.set_endevent(type)

def music_get_endevent():
    return pygame.mixer.music.get_endevent()


def play_sound(file_path):
    try:
        sound = pygame.mixer.Sound(file_path)
        sound.play()
    except Exception as e:
        print(f"Error playing sound: {e}")