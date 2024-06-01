import pygame

# Define Lua bindings for mouse functions
def get_mouse_pressed(num_buttons=3):
    """Get the state of the mouse buttons."""
    return pygame.mouse.get_pressed(num_buttons)

def get_pos():
    """Get the mouse cursor position."""
    return pygame.mouse.get_pos()
def get_rel():
    """Get the amount of mouse movement."""
    return pygame.mouse.get_rel()

def set_pos(x, y):
    """Set the mouse cursor position."""
    pygame.mouse.set_pos((x, y))

def set_visible(visible):
    """Hide or show the mouse cursor."""
    return pygame.mouse.set_visible(visible)

def get_visible():
    """Get the current visibility state of the mouse cursor."""
    return pygame.mouse.get_visible()

def get_focused():
    """Check if the display is receiving mouse input."""
    return pygame.mouse.get_focused()

def set_cursor(*args):
    """Set the mouse cursor to a new cursor."""
    pygame.mouse.set_cursor(*args)

def get_cursor():
    """Get the current mouse cursor."""
    return pygame.mouse.get_cursor()