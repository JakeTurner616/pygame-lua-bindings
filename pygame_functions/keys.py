# /pygame_functions/keys.py
import pygame
from lupa import LuaRuntime

# Initialize Lua runtime with unpacking of returned tuples
lua = LuaRuntime(unpack_returned_tuples=True)

# Define the wrapper functions for pygame.key methods
def get_focused():
    return pygame.key.get_focused()

def get_pressed():
    pressed_keys = pygame.key.get_pressed()
    lua_table = lua.table()
    for i, pressed in enumerate(pressed_keys):
        lua_table[i+1] = pressed  # Lua tables are 1-indexed
    return lua_table


def get_mods():
    return pygame.key.get_mods()

def set_mods(mods):
    pygame.key.set_mods(mods)

def set_repeat(delay=None, interval=None):
    if delay is None:
        pygame.key.set_repeat()
    elif interval is None:
        pygame.key.set_repeat(delay)
    else:
        pygame.key.set_repeat(delay, interval)

def get_repeat():
    return pygame.key.get_repeat()

def key_name(key, use_compat=True):
    return pygame.key.name(key, use_compat)

def key_code(name):
    return pygame.key.key_code(name)

def start_text_input():
    pygame.key.start_text_input()

def stop_text_input():
    pygame.key.stop_text_input()

def set_text_input_rect(rect):
    pygame.key.set_text_input_rect(rect)