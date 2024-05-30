import pygame
import sys
import traceback
from lupa import LuaRuntime
from pygame_functions.color import (hex_to_rgb, color)
from pygame_functions.soundarray import (sndarray_array, sndarray_samples, sndarray_make_sound, sndarray_use_arraytype, sndarray_get_arraytype, sndarray_get_arraytypes)
from pygame_functions.version import (version, get_sdl_version)
from pygame_functions.math import (clamp, lerp, Vector2, Vector3)
from pygame_functions.color import (color, THECOLORS)
from pygame_functions.constants import (KEY_CONSTANTS, EVENT_CONSTANTS)
from pygame_functions.drawing import (
    draw_polygon, draw_text, draw_circle, draw_rectangle, clear_canvas
)
from pygame_functions.keys import (
    get_focused, get_pressed, get_mods, set_mods, set_repeat, get_repeat, key_name, key_code,
    start_text_input, stop_text_input, set_text_input_rect
)
from pygame_functions.font import (init_font_module, quit_font_module, is_font_initialized, get_default_font, get_fonts, match_font, create_sys_font, create_font)
from pygame_functions.images import (load_image, draw_image, save_image)
from pygame_functions.time import (get_ticks, wait, delay, set_timer, Clock)
from pygame_functions.utils import (
    initialize_pygame, get_pi, get_acos, get_asin, get_atan, get_atan2, get_cos, get_sin,
    get_tan, get_exp, get_log, get_log10, get_pow, get_sqrt, get_ceil, get_floor, get_fabs
)
from pygame_functions.events import (
    set_event_handling_active, pump_events, poll_event, wait_event,
    peek_event, clear_events, get_events, get_event
)
from pygame_functions.sounds import play_music
from pygame_functions.display import flip_display

# Initialize Lua
lua = LuaRuntime(unpack_returned_tuples=True)

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
    else:
        print(f"Function {name} is not recognized for registration.")

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

# Wrapper functions to expose Python functions to Lua
lua.globals().pi = get_pi()
lua.globals().sin = get_sin
lua.globals().cos = get_cos
lua.globals().tan = get_tan
lua.globals().asin = get_asin
lua.globals().acos = get_acos
lua.globals().atan = get_atan
lua.globals().atan2 = get_atan2
lua.globals().exp = get_exp
lua.globals().log = get_log
lua.globals().log10 = get_log10
lua.globals().pow = get_pow
lua.globals().sqrt = get_sqrt
lua.globals().ceil = get_ceil
lua.globals().floor = get_floor
lua.globals().fabs = get_fabs

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
lua.globals().flip_display = flip_display
lua.globals().draw_polygon = lambda hex_color, points, width=0: draw_polygon(screen, hex_color, points, width)

# Pygame image functions bindings
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

# Register the constants in Lua
for key, value in KEY_CONSTANTS.items():
    lua.globals()[key] = value

for key, value in EVENT_CONSTANTS.items():
    lua.globals()[key] = value


# Color functions
lua.globals().color = color
lua.globals().THECOLORS = THECOLORS
lua.globals().hex_to_rgb = hex_to_rgb


# Version functions
lua.globals().version = version
lua.globals().get_sdl_version = get_sdl_version

# Sound functions
lua.globals().sndarray_array = sndarray_array
lua.globals().sndarray_samples = sndarray_samples
lua.globals().sndarray_make_sound = sndarray_make_sound
lua.globals().sndarray_use_arraytype = sndarray_use_arraytype
lua.globals().sndarray_get_arraytype = sndarray_get_arraytype
lua.globals().sndarray_get_arraytypes = sndarray_get_arraytypes

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
            handler(event_data)

# Main loop to handle Pygame events and execute drawing commands
def main_loop():
    set_event_handling_active(True)
    clock = pygame.time.Clock()
    while main_loop_running:
        handle_events()
        if registered_functions["process_events"]:
            registered_functions["process_events"]()
        if registered_functions["update_position"]:
            registered_functions["update_position"]()
        if registered_functions["draw"]:
            registered_functions["draw"]()
        flip_display()
        # Cap the frame rate to 12 fps
        clock.tick(14)

    pygame.quit()
    sys.exit()

# Register functions and run Lua script
lua.globals().start_main_loop = start_main_loop
lua.globals().stop_main_loop = stop_main_loop
lua.globals().is_main_loop_running = is_main_loop_running

run_lua_script("lua_scripts/test_script.lua")

# Start the main loop
main_loop()
