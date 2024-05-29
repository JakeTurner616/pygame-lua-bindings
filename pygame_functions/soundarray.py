import pygame

# Initialize Pygame mixer
pygame.mixer.init()

# Wrapper functions to expose pygame.sndarray functions to Lua
def sndarray_array(sound):
    """
    Copies Sound samples into an array.
    :param sound: The Sound object.
    :return: An array with the sound samples.
    """
    return pygame.sndarray.array(sound)

def sndarray_samples(sound):
    """
    References Sound samples into an array.
    :param sound: The Sound object.
    :return: An array that references the samples in the Sound object.
    """
    return pygame.sndarray.samples(sound)

def sndarray_make_sound(array):
    """
    Converts an array into a Sound object.
    :param array: The array with sound samples.
    :return: A Sound object created from the array.
    """
    return pygame.sndarray.make_sound(array)

def sndarray_use_arraytype(arraytype):
    """
    Sets the array system to be used for sound arrays.
    :param arraytype: The array system type (e.g., 'numpy').
    """
    pygame.sndarray.use_arraytype(arraytype)

def sndarray_get_arraytype():
    """
    Gets the currently active array type.
    :return: The active array type.
    """
    return pygame.sndarray.get_arraytype()

def sndarray_get_arraytypes():
    """
    Gets the array system types currently supported.
    :return: A tuple of supported array types.
    """
    return pygame.sndarray.get_arraytypes()