import pygame

# Define the transformation functions
def flip(surface, flip_x, flip_y):
    return pygame.transform.flip(surface, flip_x, flip_y)

def scale(surface, width, height):
    return pygame.transform.scale(surface, (width, height))

def scale_by(surface, factor_x, factor_y):
    return pygame.transform.scale_by(surface, (factor_x, factor_y))

def rotate(surface, angle):
    return pygame.transform.rotate(surface, angle)

def rotozoom(surface, angle, scale):
    return pygame.transform.rotozoom(surface, angle, scale)

def scale2x(surface):
    return pygame.transform.scale2x(surface)

def smoothscale(surface, width, height):
    return pygame.transform.smoothscale(surface, (width, height))

def smoothscale_by(surface, factor_x, factor_y):
    return pygame.transform.smoothscale_by(surface, (factor_x, factor_y))

def chop(surface, x, y, width, height):
    rect = pygame.Rect(x, y, width, height)
    return pygame.transform.chop(surface, rect)

def laplacian(surface):
    return pygame.transform.laplacian(surface)

def average_color(surface, x=None, y=None, width=None, height=None, consider_alpha=False):
    rect = None
    if x is not None and y is not None and width is not None and height is not None:
        rect = pygame.Rect(x, y, width, height)
    return pygame.transform.average_color(surface, rect, consider_alpha)

def grayscale(surface):
    return pygame.transform.grayscale(surface)

def threshold(dest_surface, surface, r, g, b, a, tr, tg, tb, ta):
    threshold = pygame.Color(tr, tg, tb, ta)
    search_color = pygame.Color(r, g, b, a)
    return pygame.transform.threshold(dest_surface, surface, search_color, threshold)