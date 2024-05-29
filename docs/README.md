# Pygame Lua Integration

This project provides Lua bindings for Pygame, enabling users to interact with Pygame through Lua scripts. The bindings cover display initialization, drawing, event handling, image manipulation, and audio playback.

## Project Structure

my_pygame_lua_project/
│
├── main.py
├── gui.py
├── pygame_functions/
│ ├── init.py
│ ├── drawing.py
│ ├── events.py
│ ├── images.py
│ ├── sounds.py
│ ├── display.py
│ ├── utils.py
└── lua_scripts/
├── example.lua
└── event_handlers.lua
# Pygame Functions

This document provides an overview of the available functions in the Pygame library for Lua.

## Available Functions

### Display Functions

These functions allow you to manage the Pygame display.

- `quit_display()`: Uninitializes the display module.
- `get_display_init()`: Returns True if the display module has been initialized.
- `set_display_mode(width, height, flags=0, depth=0)`: Initializes a window or screen for display.
- `get_display_surface()`: Gets a reference to the currently set display surface.
- `flip_display()`: Updates the full display Surface to the screen.
- `update_display(rects=None)`: Updates portions of the screen for software displays.
- `get_display_driver()`: Gets the name of the Pygame display backend.
- `get_display_info()`: Creates a video display information object.
- `get_wm_info()`: Gets information about the current windowing system.
- `get_desktop_sizes()`: Gets sizes of active desktops.
- `list_modes(depth=0, flags=pygame.FULLSCREEN)`: Gets list of available fullscreen modes.
- `mode_ok(width, height, flags=0, depth=0)`: Picks the best color depth for a display mode.
- `gl_get_attribute(attr)`: Gets the value for an OpenGL flag for the current display.
- `gl_set_attribute(attr, value)`: Requests an OpenGL display attribute for the display mode.
- `get_display_active()`: Returns True when the display is active on the screen.
- `iconify_display()`: Iconifies the display surface.
- `toggle_fullscreen_display()`: Switches between fullscreen and windowed displays.
- `set_gamma_display(value)`: Changes the hardware gamma ramps.
- `set_gamma_ramp_display(r, g, b)`: Changes the hardware gamma ramps with a custom lookup.
- `set_display_icon(surface)`: Changes the system image for the display window.
- `set_display_caption(title, icontitle=None)`: Sets the current window caption.
- `get_display_caption()`: Gets the current window caption.
- `set_display_palette(palette)`: Sets the display color palette for indexed displays.
- `get_num_displays()`: Returns the number of displays.
- `get_window_size()`: Returns the size of the window or screen.
- `get_allow_screensaver()`: Returns whether the screensaver is allowed to run.
- `set_allow_screensaver(allow)`: Sets whether the screensaver may run.

### Drawing Functions

These functions allow you to draw shapes and text on the Pygame screen.

- `draw_text(x, y, text, font_name, font_size, hex_color)`: Draws text on the screen.
- `draw_circle(x, y, radius, hex_color)`: Draws a circle on the screen.
- `draw_rectangle(x, y, width, height, hex_color)`: Draws a rectangle on the screen.
- `draw_line(x1, y1, x2, y2, hex_color)`: Draws a line on the screen.
- `clear_canvas()`: Clears the screen.

### Image Functions

These functions allow you to load and draw images.

- `load_image(file_path)`: Loads an image from the specified file path.
- `draw_image(image, x, y)`: Draws the loaded image on the screen at the specified coordinates.

### Sound Functions

These functions allow you to play sounds and music.

- `play_sound(file_path)`: Plays a sound effect from the specified file path.
- `play_music(file_path)`: Plays music from the specified file path.

### Event Handling

Event handling functions allow you to register and handle various Pygame events.

- `register_event_handler(event_name, handler)`: Registers a handler for the specified event. The event name can be one of the following: `"on_key_down"`, `"on_key_up"`, `"on_mouse_button_down"`, `"on_mouse_button_up"`, `"on_mouse_motion"`.
- `enable_event_handling()`: Enables event handling. You must call this function to start processing events.




