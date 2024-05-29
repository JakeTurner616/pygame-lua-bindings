import pygame
from lupa import LuaRuntime

# Initialize Lua
lua = LuaRuntime(unpack_returned_tuples=True)

# Font Module Functions
def init_font_module():
    pygame.font.init()

def quit_font_module():
    pygame.font.quit()

def is_font_initialized():
    return pygame.font.get_init()

def get_default_font():
    return pygame.font.get_default_font()

def get_fonts():
    return pygame.font.get_fonts()

def match_font(name, bold=False, italic=False):
    return pygame.font.match_font(name, bold, italic)

def create_sys_font(name, size, bold=False, italic=False):
    font = pygame.font.SysFont(name, size, bold, italic)
    return font

def create_font(file_path=None, size=12):
    font = pygame.font.Font(file_path, size)
    return font