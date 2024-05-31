import numpy as np
import pygame
import luadata

# Initialize Pygame and mixer
pygame.mixer.init()

# Wrapper functions to expose pygame.sndarray functions to Lua
def sndarray_array(sound):
    try:
        array = pygame.sndarray.array(sound)
        if array.shape:  # Check if the array is not empty
            print(f"sndarray_array: array shape: {array.shape}")
            length = array.shape[0]
            lua_array = luadata.serialize([int(array[i]) for i in range(length)])
            lua_array.length = length
            return lua_array
        else:
            # sndarray_array returned an empty array
            return luadata.serialize([])
    except Exception as e:
        print(f"Error in sndarray_array: {e}")
        return luadata.serialize([])

def sndarray_samples(sound):
    try:
        array = pygame.sndarray.samples(sound)
        if array.shape:  # Check if the array is not empty
            print(f"sndarray_samples: array shape: {array.shape}")
            length = array.shape[0]
            lua_array = luadata.serialize([int(array[i]) for i in range(length)])
            lua_array.length = length
            return lua_array
        else:
            # sndarray_samples returned an empty array
            return luadata.serialize([])
    except Exception as e:
        print(f"Error in sndarray_samples: {e}")
        return luadata.serialize([])

def sndarray_make_sound(lua_array):
    python_array = luadata.unserialize(lua_array)
    sound_array = np.array(python_array, dtype=np.int16)
    sound_array = np.column_stack((sound_array, sound_array))  # Duplicate mono data across channels
    return pygame.sndarray.make_sound(sound_array)