import os
import pygame
import sys
import traceback
from lupa import LuaRuntime
from pygame_functions.pillow import (load_image_from_pil, get_pixel_color, get_image_data)
from pygame_functions.networking import (http_get, create_socket, connect_socket, send_socket, receive_socket)
from pygame_functions.surface import ( create_surface, surface_blit, surface_blits, surface_convert, surface_convert_alpha, surface_copy, surface_fill, surface_scroll, surface_set_colorkey, surface_get_colorkey, surface_set_alpha, surface_get_alpha, surface_lock, surface_unlock, surface_get_at, surface_set_at, surface_subsurface, surface_get_size, surface_get_width, surface_get_height, surface_get_rect)
from pygame_functions.transform import (flip, scale, scale_by, rotate, rotozoom, scale2x, smoothscale, smoothscale_by, chop, laplacian, average_color, grayscale, threshold)
from pygame_functions.sprite import (
    SpriteWrapper, GroupWrapper, WeakSpriteWrapper, DirtySpriteWrapper, LayeredUpdatesWrapper, spritecollide, collide_rect, collide_circle
)
from pygame_functions.midi import (midi_init, midi_Input, midi_Output, midi_get_init, midi_quit, midi_get_count, midi_get_default_input_id, midi_get_default_output_id, midi_get_device_info, midi_midis2events, midi_time, midi_frequency_to_midi, midi_midi_to_frequency, midi_midi_to_ansi_note, MidiException, midi_Output_note_on, midi_Output_note_off, midi_Output_set_instrument)
from pygame_functions.mouse import (get_mouse_pressed, get_pos, get_rel, set_pos, set_visible, get_visible, get_focused, set_cursor, get_cursor)
from pygame_functions.color import (hex_to_rgb, color)
from pygame_functions.soundarray import (sndarray_array, sndarray_samples, sndarray_make_sound)
from pygame_functions.version import (version, get_sdl_version)
from pygame_functions.math import (clamp, lerp, Vector2, Vector3)
from pygame_functions.color import (color, THECOLORS)
from pygame_functions.constants import (KEY_CONSTANTS, EVENT_CONSTANTS)
from pygame_functions.mixer import (music_play, play_sound, music_load, music_unload, music_rewind, music_stop, music_pause, music_unpause, music_fadeout, music_set_volume, music_get_volume, music_get_busy, music_set_pos, music_get_pos, music_set_endevent, music_get_endevent)
from pygame_functions.drawing import (
    draw_polygon, draw_text, draw_circle, draw_rectangle, clear_canvas
)
from pygame_functions.keys import (
    get_focused, get_pressed, get_mods, set_mods, set_repeat, get_repeat, key_name, key_code,
    start_text_input, stop_text_input, set_text_input_rect
)
from pygame_functions.font import (init_font_module, quit_font_module, is_font_initialized, get_default_font, get_fonts, match_font, create_sys_font, create_font)
from pygame_functions.images import (load_image, draw_image, save_image, get_extended)
from pygame_functions.time import (get_ticks, wait, delay, set_timer, Clock)
from pygame_functions.utils import ( get_error, 
    quit, initialize_pygame, get_pi, get_acos, get_asin, get_atan, get_atan2, get_cos, get_sin,
    get_tan, get_exp, get_log, get_log10, get_pow, get_sqrt, get_ceil, get_floor, get_fabs
)
from pygame_functions.events import (
    set_event_handling_active, pump_events, poll_event, wait_event,
    peek_event, clear_events, get_events, get_event
)
from pygame_functions.display import set_display_mode_lua, init_display, quit_display, get_display_init, set_display_mode, get_display_surface, flip_display, update_display, get_display_driver, get_display_info, get_wm_info, get_desktop_sizes, list_modes, mode_ok, gl_get_attribute, gl_set_attribute, get_display_active, iconify_display, toggle_fullscreen_display, set_gamma_display, Surface, set_gamma_ramp_display, set_display_icon, set_display_caption, get_display_caption, set_display_palette, get_num_displays, get_window_size, get_allow_screensaver, set_allow_screensaver

vebose = False


# Initialize Lua
lua = LuaRuntime(unpack_returned_tuples=True)

def set_env_variables():
    env_vars = lua.table()
    for key, value in os.environ.items():
        env_vars[key] = value
    lua.globals().env = env_vars

set_env_variables()


# Determine the correct extension for shared libraries based on the OS
if sys.platform.startswith('win'):
    ext = 'dll'
else:
    ext = 'so'

# Set the Lua search path and C library path

lua.execute(f'package.cpath = package.cpath .. ";./lua_modules/?.{ext}"')


# Initialize Pygame
initialize_pygame()
screen = pygame.display.set_mode((800, 600))
pygame.display.set_caption("Pygame Lua Integration")

# Register functions from Lua
registered_functions = {
    "process_events": None,
    "update_position": None,
    "draw": None,
}

def register_function(name, func):
    if name in registered_functions:
        registered_functions[name] = func
        print(f"Registered function '{name}' with function {func}")
    else:
        print(f"Function '{name}' is not recognized for registration.")

lua.globals().register_function = register_function

def get_events_as_lua():
    events = get_events()
    lua_events = lua.table()
    index = 1
    for event in events:
        lua_event = lua.table()
        lua_event['type'] = event['type']
        if 'key' in event:
            lua_event['key'] = event['key']
        if 'mod' in event:
            lua_event['mod'] = event['mod']
        if 'button' in event:
            lua_event['button'] = event['button']
        if 'pos' in event and event['pos'] is not None:
            lua_event['pos'] = lua.table(event['pos'][0], event['pos'][1])
        if 'rel' in event and event['rel'] is not None:
            lua_event['rel'] = lua.table(event['rel'][0], event['rel'][1])
        if 'buttons' in event and event['buttons'] is not None:
            lua_event['buttons'] = lua.table(*event['buttons'])
        lua_events[index] = lua_event
        index += 1
    return lua_events

lua.globals().get_events = get_events_as_lua
lua.globals().get_event = get_event

#Wrapper function to expose Python pillow functions to Lua
lua.globals().load_image_from_pil = load_image_from_pil
lua.globals().get_pixel_color = get_pixel_color
lua.globals().get_image_data = get_image_data

#Wrapper functions to expose Python midi functions to Lua
lua.globals().midi_init = midi_init
lua.globals().midi_quit = midi_quit
lua.globals().midi_get_init = midi_get_init
lua.globals().midi_get_count = midi_get_count
lua.globals().midi_get_default_input_id = midi_get_default_input_id
lua.globals().midi_get_default_output_id = midi_get_default_output_id
lua.globals().midi_get_device_info = midi_get_device_info
lua.globals().midi_midis2events = midi_midis2events
lua.globals().midi_time = midi_time
lua.globals().midi_frequency_to_midi = midi_frequency_to_midi
lua.globals().midi_midi_to_frequency = midi_midi_to_frequency
lua.globals().midi_midi_to_ansi_note = midi_midi_to_ansi_note
lua.globals().midi_Input = midi_Input
lua.globals().midi_Output = midi_Output
lua.globals().MidiException = MidiException
lua.globals().midi_Output_note_on = midi_Output_note_on
lua.globals().midi_Output_note_off = midi_Output_note_off
lua.globals().midi_Output_set_instrument = midi_Output_set_instrument


# Expose networking functions to Lua
lua.globals().http_get = http_get
lua.globals().create_socket = create_socket
lua.globals().connect_socket = connect_socket
lua.globals().send_socket = send_socket
lua.globals().receive_socket = receive_socket

# Wrapper functions to expose utils functions to Lua
lua.globals().quit = quit
lua.globals().get_error = get_error
lua.globals().initialize_pygame = initialize_pygame
lua.globals().get_pi = get_pi
lua.globals().get_sin = get_sin
lua.globals().get_cos = get_cos
lua.globals().get_tan = get_tan
lua.globals().get_asin = get_asin
lua.globals().get_acos = get_acos
lua.globals().get_atan = get_atan
lua.globals().get_atan2 = get_atan2
lua.globals().get_exp = get_exp
lua.globals().get_log = get_log
lua.globals().get_log10 = get_log10
lua.globals().get_pow = get_pow
lua.globals().get_sqrt = get_sqrt
lua.globals().get_ceil = get_ceil
lua.globals().get_floor = get_floor
lua.globals().get_fabs = get_fabs

# Wrapper functions to expose Python mouse methods to Lua
lua.globals().get_mouse_pressed = get_mouse_pressed
lua.globals().get_mouse_pos = get_pos
lua.globals().get_mouse_rel = get_rel
lua.globals().set_mouse_pos = set_pos
lua.globals().set_mouse_visible = set_visible
lua.globals().get_mouse_visible = get_visible
lua.globals().get_mouse_focused = get_focused
lua.globals().set_mouse_cursor = set_cursor
lua.globals().get_mouse_cursor = get_cursor

# Pygame time functions bindings
lua.globals().get_ticks = get_ticks
lua.globals().wait = wait
lua.globals().delay = delay
lua.globals().set_timer = set_timer
lua.globals().Clock = Clock

# Pygame drawing functions bindings
lua.globals().draw_text = lambda x, y, text, font_name, font_size, hex_color: draw_text(screen, x, y, text, font_name, font_size, hex_color)
lua.globals().draw_circle = lambda hex_color, center, radius, width=0, draw_top_right=False, draw_top_left=False, draw_bottom_left=False, draw_bottom_right=False: draw_circle(screen, hex_color, center, radius, width, draw_top_right, draw_top_left, draw_bottom_left, draw_bottom_right)
lua.globals().draw_rectangle = lambda x, y, width, height, hex_color, line_width=0: draw_rectangle(screen, x, y, width, height, hex_color, line_width)
lua.globals().clear_canvas = lambda: clear_canvas(screen)
lua.globals().draw_polygon = lambda hex_color, points, width=0: draw_polygon(screen, hex_color, points, width)

# Pygame display function bindings
lua.globals().set_display_mode_lua = set_display_mode_lua
lua.globals().flip_display = flip_display
lua.globals().update_display = update_display
lua.globals().get_display_init = get_display_init
lua.globals().set_display_mode = set_display_mode
lua.globals().get_display_surface = get_display_surface
lua.globals().get_display_driver = get_display_driver
lua.globals().get_display_info = get_display_info
lua.globals().get_wm_info = get_wm_info
lua.globals().get_desktop_sizes = get_desktop_sizes
lua.globals().list_modes = list_modes
lua.globals().mode_ok = mode_ok
lua.globals().gl_get_attribute = gl_get_attribute
lua.globals().gl_set_attribute = gl_set_attribute
lua.globals().get_display_active = get_display_active
lua.globals().iconify_display = iconify_display
lua.globals().toggle_fullscreen_display = toggle_fullscreen_display
lua.globals().set_gamma_display = set_gamma_display
lua.globals().Surface = Surface
lua.globals().set_gamma_ramp_display = set_gamma_ramp_display
lua.globals().set_display_icon = set_display_icon
lua.globals().set_display_caption = set_display_caption
lua.globals().get_display_caption = get_display_caption
lua.globals().set_display_palette = set_display_palette
lua.globals().get_num_displays = get_num_displays
lua.globals().get_window_size = get_window_size
lua.globals().get_allow_screensaver = get_allow_screensaver

# Register the transform functions in Lua
lua.globals().flip = flip
lua.globals().scale = scale
lua.globals().scale_by = scale_by
lua.globals().rotate = rotate
lua.globals().rotozoom = rotozoom
lua.globals().scale2x = scale2x
lua.globals().smoothscale = smoothscale
lua.globals().smoothscale_by = smoothscale_by
lua.globals().chop = chop
lua.globals().laplacian = laplacian
lua.globals().average_color = average_color
lua.globals().grayscale = grayscale
lua.globals().threshold = threshold

# Pygame surface functions bindings
# Register the functions in Lua
lua.globals().create_surface = create_surface
lua.globals().surface_blit = surface_blit
lua.globals().surface_blits = surface_blits
lua.globals().surface_convert = surface_convert
lua.globals().surface_convert_alpha = surface_convert_alpha
lua.globals().surface_copy = surface_copy
lua.globals().surface_fill = surface_fill
lua.globals().surface_scroll = surface_scroll
lua.globals().surface_set_colorkey = surface_set_colorkey
lua.globals().surface_get_colorkey = surface_get_colorkey
lua.globals().surface_set_alpha = surface_set_alpha
lua.globals().surface_get_alpha = surface_get_alpha
lua.globals().surface_lock = surface_lock
lua.globals().surface_unlock = surface_unlock
lua.globals().surface_get_at = surface_get_at
lua.globals().surface_set_at = surface_set_at
lua.globals().surface_subsurface = surface_subsurface
lua.globals().surface_get_size = surface_get_size
lua.globals().surface_get_width = surface_get_width
lua.globals().surface_get_height = surface_get_height
lua.globals().surface_get_rect = surface_get_rect

# Pygame image functions bindings
lua.globals().get_extended = get_extended
lua.globals().load_image = load_image
lua.globals().draw_image = lambda image, x, y: draw_image(screen, image, x, y)
lua.globals().save_image = save_image

# Event handling bindings
lua.globals().set_event_handling_active = set_event_handling_active
lua.globals().pump_events = pump_events
lua.globals().poll_event = poll_event
lua.globals().wait_event = wait_event
lua.globals().peek_event = peek_event
lua.globals().clear_events = clear_events

# Key functions to Lua globals
lua.globals().get_focused = get_focused
lua.globals().get_pressed = get_pressed
lua.globals().get_mods = get_mods
lua.globals().set_mods = set_mods
lua.globals().set_repeat = set_repeat
lua.globals().get_repeat = get_repeat
lua.globals().key_name = key_name
lua.globals().key_code = key_code
lua.globals().start_text_input = start_text_input
lua.globals().stop_text_input = stop_text_input
lua.globals().set_text_input_rect = set_text_input_rect

# Register the functions in Lua
lua.globals().init_font_module = init_font_module
lua.globals().quit_font_module = quit_font_module
lua.globals().is_font_initialized = is_font_initialized
lua.globals().get_default_font = get_default_font
lua.globals().get_fonts = get_fonts
lua.globals().match_font = match_font
lua.globals().create_sys_font = create_sys_font
lua.globals().create_font = create_font


# Register the math functions in Lua
lua.globals().Vector2 = Vector2
lua.globals().Vector3 = Vector3

# Register utility functions
lua.globals().clamp = clamp
lua.globals().lerp = lerp

# Register the mixer functions in Lua
lua.globals().music_load = music_load
lua.globals().music_unload = music_unload
lua.globals().music_rewind = music_rewind
lua.globals().music_stop = music_stop
lua.globals().music_pause = music_pause
lua.globals().music_unpause = music_unpause
lua.globals().music_fadeout = music_fadeout
lua.globals().music_set_volume = music_set_volume
lua.globals().music_get_volume = music_get_volume
lua.globals().music_get_busy = music_get_busy
lua.globals().music_set_pos = music_set_pos
lua.globals().music_get_pos = music_get_pos
lua.globals().music_set_endevent = music_set_endevent
lua.globals().music_get_endevent = music_get_endevent
lua.globals().play_sound = play_sound
lua.globals().music_play = music_play

# Register the constants in Lua
for key, value in KEY_CONSTANTS.items():
    lua.globals()[key] = value

for key, value in EVENT_CONSTANTS.items():
    lua.globals()[key] = value


# Color functions
lua.globals().color = color
lua.globals().THECOLORS = THECOLORS
lua.globals().hex_to_rgb = hex_to_rgb



# Sprite Functions
lua.globals().Sprite = SpriteWrapper
lua.globals().Group = GroupWrapper
lua.globals().WeakSprite = WeakSpriteWrapper
lua.globals().DirtySprite = DirtySpriteWrapper
lua.globals().LayeredUpdates = LayeredUpdatesWrapper
lua.globals().spritecollide = spritecollide
lua.globals().collide_rect = collide_rect
lua.globals().collide_circle = collide_circle

# Version functions
lua.globals().version = version
lua.globals().get_sdl_version = get_sdl_version

# Soundarray functions
lua.globals().sndarray_array = sndarray_array
lua.globals().sndarray_samples = sndarray_samples
lua.globals().sndarray_make_sound = sndarray_make_sound

# Event handler storage
event_handlers = {}

def register_event_handler(event_name, handler):
    """
    Register a handler function for a specific event.
    :param event_name: Name of the event to handle (e.g., 'on_key_down').
    :param handler: The function to call when the event occurs.
    """
    print(f"Registering handler for {event_name}")
    event_handlers[event_name] = handler
    print(f"Handler for {event_name}: {handler}")

lua.globals().register_event_handler = register_event_handler

# Variables to control the main loop
main_loop_running = True

def start_main_loop():
    global main_loop_running
    main_loop_running = True

def stop_main_loop():
    global main_loop_running
    main_loop_running = False

def is_main_loop_running():
    return main_loop_running

lua.globals().start_main_loop = start_main_loop
lua.globals().stop_main_loop = stop_main_loop
lua.globals().is_main_loop_running = is_main_loop_running

# Function to run a Lua script
def run_lua_script(script_path):
    try:
        with open(script_path) as f:
            lua_code = f.read()
        lua.execute(lua_code)
    except Exception as e:
        tb_str = traceback.format_exc()
        print(f"ERROR: Lua interpreter failed:\n{tb_str}")
        try:
            lua_traceback = lua.execute("return debug.traceback()")
            print(f"Lua traceback:\n{lua_traceback}")
        except Exception as lua_e:
            print(f"Failed to capture Lua traceback: {lua_e}")

# Simplified event processing
def handle_events():
    for event in pygame.event.get():
        event_type = pygame.event.event_name(event.type).lower()
        handler = event_handlers.get(f'on_{event_type}')
        if handler:
            event_data = {}
            if event.type in (pygame.MOUSEBUTTONDOWN, pygame.MOUSEBUTTONUP):
                event_data = {
                    'button': event.button,
                    'pos': lua.table(event.pos[0], event.pos[1]),
                }
            elif event.type == pygame.MOUSEMOTION:
                event_data = {
                    'pos': lua.table(event.pos[0], event.pos[1]),
                    'rel': lua.table(event.rel[0], event.rel[1]),
                    'buttons': lua.table(*event.buttons),
                }
            elif event.type in (pygame.KEYDOWN, pygame.KEYUP):
                event_data = {
                    'key': event.key,
                    'mod': event.mod,
                }
            print(f"Handling event '{event_type}' with data {event_data}")
            handler(event_data)
# Main loop to handle Pygame events and execute drawing commands
def main_loop():
    set_event_handling_active(True)
    clock = pygame.time.Clock()
    while main_loop_running:
        handle_events()
        if registered_functions["process_events"]:
            if vebose:
                print("Calling 'process_events' function")
            registered_functions["process_events"]()
        if registered_functions["update_position"]:
            if vebose:
                print("Calling 'update_position' function")
            registered_functions["update_position"]()
        if registered_functions["draw"]:
            if vebose:
                print("Calling 'draw' function")
            registered_functions["draw"]()
        flip_display()
        # Cap the frame rate to 30 fps
        clock.tick(30)

    pygame.quit()
    sys.exit()

# Register functions and run Lua script
lua.globals().start_main_loop = start_main_loop
lua.globals().stop_main_loop = stop_main_loop
lua.globals().is_main_loop_running = is_main_loop_running

run_lua_script("lua_scripts/test_script.lua")

# Start the main loop
main_loop()