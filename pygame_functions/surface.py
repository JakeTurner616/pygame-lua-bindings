import pygame

# Helper functions to wrap Pygame Surface methods
def create_surface(width, height, flags=0, depth=0):
    surface = pygame.Surface((width, height), flags) if depth == 0 else pygame.Surface((width, height), flags, depth)
    print(f"Created surface with size: ({width}, {height})")
    return surface

def surface_blit(surface, source, x, y):
    if surface is None or source is None:
        print(f"surface_blit error: surface or source is None")
        return None
    print(f"Blitting source onto surface at position: ({x}, {y})")
    return surface.blit(source, (x, y))

def surface_blits(surface, blit_sequence):
    if surface is None:
        print(f"surface_blits error: surface is None")
        return None
    return surface.blits(blit_sequence)

def surface_convert(surface, display_surface=None):
    return surface.convert(display_surface)

def surface_convert_alpha(surface):
    return surface.convert_alpha()

def surface_copy(surface):
    return surface.copy()

def surface_fill(surface, color, rect=None, special_flags=0):
    if hasattr(color, 'values'):
        color = tuple(color.values())
    if rect and hasattr(rect, 'values'):
        rect = pygame.Rect(tuple(rect.values()))
    print(f"surface_fill called with color: {color}, rect: {rect}, special_flags: {special_flags}")
    return surface.fill(color, rect, special_flags)

def surface_scroll(surface, dx=0, dy=0):
    return surface.scroll(dx, dy)

def surface_set_colorkey(surface, color, flags=0):
    surface.set_colorkey(color, flags)

def surface_get_colorkey(surface):
    return surface.get_colorkey()

def surface_set_alpha(surface, value, flags=0):
    surface.set_alpha(value, flags)

def surface_get_alpha(surface):
    return surface.get_alpha()

def surface_lock(surface):
    surface.lock()

def surface_unlock(surface):
    surface.unlock()

def surface_get_at(surface, x, y):
    return surface.get_at((x, y))

def surface_set_at(surface, x, y, color):
    surface.set_at((x, y), color)

def surface_subsurface(surface, x, y, width, height):
    return surface.subsurface(pygame.Rect(x, y, width, height))

def surface_get_size(surface):
    return surface.get_size()

def surface_get_width(surface):
    return surface.get_width()

def surface_get_height(surface):
    return surface.get_height()

def surface_get_rect(surface):
    return surface.get_rect()