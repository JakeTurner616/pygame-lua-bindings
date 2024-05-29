import pygame

def init_display():
    pygame.display.init()

def quit_display():
    pygame.display.quit()

def get_display_init():
    return pygame.display.get_init()

def set_display_mode(width, height, flags=0, depth=0):
    return pygame.display.set_mode((width, height), flags, depth)

def get_display_surface():
    return pygame.display.get_surface()

def flip_display():
    pygame.display.flip()

def update_display(rects=None):
    if rects:
        pygame.display.update(rects)
    else:
        pygame.display.update()

def get_display_driver():
    return pygame.display.get_driver()

def get_display_info():
    return pygame.display.Info()

def get_wm_info():
    return pygame.display.get_wm_info()

def get_desktop_sizes():
    return pygame.display.get_desktop_sizes()

def list_modes(depth=0, flags=pygame.FULLSCREEN):
    return pygame.display.list_modes(depth, flags)

def mode_ok(width, height, flags=0, depth=0):
    return pygame.display.mode_ok((width, height), flags, depth)

def gl_get_attribute(attr):
    return pygame.display.gl_get_attribute(attr)

def gl_set_attribute(attr, value):
    pygame.display.gl_set_attribute(attr, value)

def get_display_active():
    return pygame.display.get_active()

def iconify_display():
    pygame.display.iconify()

def toggle_fullscreen_display():
    pygame.display.toggle_fullscreen()

def set_gamma_display(value):
    return pygame.display.set_gamma(value)

def set_gamma_ramp_display(r, g, b):
    pygame.display.set_gamma_ramp(r, g, b)

def set_display_icon(surface):
    pygame.display.set_icon(surface)

def set_display_caption(title, icontitle=""):
    pygame.display.set_caption(title, icontitle)

def get_display_caption():
    return pygame.display.get_caption()

def set_display_palette(palette):
    pygame.display.set_palette(palette)

def get_num_displays():
    return pygame.display.get_num_displays()

def get_window_size():
    return pygame.display.get_window_size()

def get_allow_screensaver():
    return pygame.display.get_allow_screensaver()

def set_allow_screensaver(allow):
    pygame.display.set_allow_screensaver(allow)