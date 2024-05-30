# Pygame Lua Integration

## Overview

This project provides Lua bindings for Pygame. This project attempts to map the most useful pygame functions in lua, along with other useful utilities for graphics programming from within lua using pygame.

# Table of Contents

## Framework:

- [Color Functions](#color-functions)
- [Display Functions](#display-functions)
- [Drawing Functions](#drawing-functions)
- [Event Handling Functions](#event-handling-functions)
- [Font Module Functions](#font-module-functions)
- [Image Functions](#image-functions)
- [Math Functions](#math-functions)
- [Time Functions](#time-functions)
- [Pygame Version Functions](#version-functions)

## Events:

- [Pygame Key Constants](#key-constants)
- [Pygame Event Constants](#event-constants)

## Extra Utils:

- [Pygame Utils](#pygame-utils)

# Color Functions

## hex_to_rgb(hex_color)

Convert a hexadecimal color or common color name to an RGB tuple.

### Parameters:
- `hex_color`: The color in hexadecimal format, either as a string or integer, or a common color name.

### Returns:
A tuple representing the RGB color.

### Maps to:
- `pygame.Color`: This function is used internally to create a color object.

## color(r, g, b, a=255)

Create a color with the specified RGB and alpha values.

### Parameters:
- `r`: The red component of the color (0-255).
- `g`: The green component of the color (0-255).
- `b`: The blue component of the color (0-255).
- `a`: The alpha component of the color (0-255). Default is 255 (opaque).

### Returns:
A color object.

### Maps to:
- `pygame.Color`: This function is used internally to create a color object.

## THECOLORS()

Returns a Lua table of color names and their RGB values.

### Returns:
A Lua table containing color names as keys and their corresponding RGB tuples as values.

### Maps to:
- `pygame.color.THECOLORS`: This function returns a dictionary of color names and their RGB values.


# Display Functions

# Pygame Display Functions

## init_display()

Initialize the Pygame display module.

### Maps to:
- `pygame.display.init()`: This function initializes the Pygame display module.

## quit_display()

Quit the Pygame display module.

### Maps to:
- `pygame.display.quit()`: This function quits the Pygame display module.

## get_display_init()

Check if the display module is initialized.

### Returns:
- `bool`: True if the display module is initialized, False otherwise.

### Maps to:
- `pygame.display.get_init()`: This function checks if the Pygame display module is initialized.

## set_display_mode(width, height, flags=0, depth=0)

Set the display mode for the Pygame window.

### Parameters:
- `width`: The width of the window in pixels.
- `height`: The height of the window in pixels.
- `flags`: Optional flags for the display mode.
- `depth`: Optional color depth for the display mode.

### Returns:
- `Surface`: The Pygame surface representing the display.

### Maps to:
- `pygame.display.set_mode((width, height), flags, depth)`: This function sets the display mode for the Pygame window.

## get_display_surface()

Get the Pygame surface associated with the display.

### Returns:
- `Surface`: The Pygame surface associated with the display.

### Maps to:
- `pygame.display.get_surface()`: This function returns the Pygame surface associated with the display.

## flip_display()

Update the full display surface to the screen.

### Maps to:
- `pygame.display.flip()`: This function updates the full display surface to the screen.

## update_display(rects=None)

Update portions of the screen for the display surface.

### Parameters:
- `rects`: Optional list of rectangles to update.

### Maps to:
- `pygame.display.update(rects)`: This function updates portions of the screen for the display surface.

## get_display_driver()

Get the name of the video driver used for the display.

### Returns:
- `str`: The name of the video driver used for the display.

### Maps to:
- `pygame.display.get_driver()`: This function returns the name of the video driver used for the display.

## get_display_info()

Get information about the display hardware.

### Returns:
- `DisplayInfo`: An object containing information about the display hardware.

### Maps to:
- `pygame.display.Info()`: This function returns information about the display hardware.

## get_wm_info()

Get window manager information for the display.

### Returns:
- `dict`: A dictionary containing window manager information for the display.

### Maps to:
- `pygame.display.get_wm_info()`: This function returns window manager information for the display.

## get_desktop_sizes()

Get the sizes of all the desktop displays.

### Returns:
- `list`: A list containing the sizes of all the desktop displays.

### Maps to:
- `pygame.display.get_desktop_sizes()`: This function returns the sizes of all the desktop displays.

## list_modes(depth=0, flags=pygame.FULLSCREEN)

Get a list of available display modes.

### Parameters:
- `depth`: Optional color depth for the display modes.
- `flags`: Optional flags for the display modes.

### Returns:
- `list`: A list of available display modes.

### Maps to:
- `pygame.display.list_modes(depth, flags)`: This function returns a list of available display modes.

## mode_ok(width, height, flags=0, depth=0)

Check if a specific display mode is supported.

### Parameters:
- `width`: The width of the display mode in pixels.
- `height`: The height of the display mode in pixels.
- `flags`: Optional flags for the display mode.
- `depth`: Optional color depth for the display mode.

### Returns:
- `bool`: True if the display mode is supported, False otherwise.

### Maps to:
- `pygame.display.mode_ok((width, height), flags, depth)`: This function checks if a specific display mode is supported.

## gl_get_attribute(attr)

Get the value of an OpenGL display attribute.

### Parameters:
- `attr`: The attribute to get.

### Returns:
- `int`: The value of the OpenGL display attribute.

### Maps to:
- `pygame.display.gl_get_attribute(attr)`: This function gets the value of an OpenGL display attribute.

## gl_set_attribute(attr, value)

Set the value of an OpenGL display attribute.

### Parameters:
- `attr`: The attribute to set.
- `value`: The value to set.

### Maps to:
- `pygame.display.gl_set_attribute(attr, value)`: This function sets the value of an OpenGL display attribute.

## get_display_active()

Check if the display is active.

### Returns:
- `bool`: True if the display is active, False otherwise.

### Maps to:
- `pygame.display.get_active()`: This function checks if the display is active.

## iconify_display()

Iconify (minimize) the display window.

### Maps to:
- `pygame.display.iconify()`: This function iconifies (minimizes) the display window.

## toggle_fullscreen_display()

Toggle the display between fullscreen and windowed mode.

### Maps to:
- `pygame.display.toggle_fullscreen()`: This function toggles the display between fullscreen and windowed mode.

## set_gamma_display(value)

Set the gamma value for the display.

### Parameters:
- `value`: The gamma value to set.

### Maps to:
- `pygame.display.set_gamma(value)`: This function sets the gamma value for the display.

## set_gamma_ramp_display(r, g, b)

Set the gamma ramp for the display.

### Parameters:
- `r`: The red gamma ramp.
- `g`: The green gamma ramp.
- `b`: The blue gamma ramp.

### Maps to:
- `pygame.display.set_gamma_ramp(r, g, b)`: This function sets the gamma ramp for the display.

## set_display_icon(surface)

Set the icon for the display window.

### Parameters:
- `surface`: The Pygame surface to use as the icon.

### Maps to:
- `pygame.display.set_icon(surface)`: This function sets the icon for the display window.

## set_display_caption(title, icontitle="")

Set the title and icon title for the display window.

### Parameters:
- `title`: The title of the display window.
- `icontitle`: The title of the icon (optional).

### Maps to:
- `pygame.display.set_caption(title, icontitle)`: This function sets the title and icon title for the display window.

## get_display_caption()

Get the title and icon title for the display window.

### Returns:
- `tuple`: A tuple containing the title and icon title for the display window.

### Maps to:
- `pygame.display.get_caption()`: This function gets the title and icon title for the display window.

## set_display_palette(palette)

Set the palette for the display.

### Parameters:
- `palette`: The palette to set.

### Maps to:
- `pygame.display.set_palette(palette)`: This function sets the palette for the display.

## get_num_displays()

Get the number of attached displays.

### Returns:
- `int`: The number of attached displays.

### Maps to:
- `pygame.display.get_num_displays()`: This function gets the number of attached displays.

## get_window_size()

Get the size of the display window.

### Returns:
- `tuple`: A tuple containing the width and height of the display window.

### Maps to:
- `pygame.display.get_window_size()`: This function gets the size of the display window.

## get_allow_screensaver()

Check if the screensaver is allowed.

### Returns:
- `bool`: True if the screensaver is allowed, False otherwise.

### Maps to:
- `pygame.display.get_allow_screensaver()`: This function checks if the screensaver is allowed.

## set_allow_screensaver(allow)

Set whether the screensaver is allowed.

### Parameters:
- `allow`: True to allow the screensaver, False to prevent it.

### Maps to:
- `pygame.display.set_allow_screensaver(allow)`: This function sets whether the screensaver is allowed.

## draw_text(surface, x, y, text, font_name, font_size, hex_color)

Draw text on the given surface at the specified coordinates.

### Parameters:
- `surface`: The surface to draw the text on.
- `x`: The x-coordinate for the text position.
- `y`: The y-coordinate for the text position.
- `text`: The text string to draw.
- `font_name`: The name of the font to use.
- `font_size`: The size of the font.
- `hex_color`: The color of the text in hexadecimal format or as a string: `"red"`.

### Returns:
The rectangle area of the rendered text.

### Maps to:
- `pygame.font.SysFont`: This function creates a font object with the specified font name and size.
- `pygame.Surface.blit`: This method blits the rendered text surface onto the target surface.

## draw_circle(surface, hex_color, center, radius, width=0, draw_top_right=False, draw_top_left=False, draw_bottom_left=False, draw_bottom_right=False)

Draw a circle on the given surface.

### Parameters:
- `surface`: The surface to draw the circle on.
- `hex_color`: The color of the circle in hexadecimal format.
- `center`: The center point of the circle as a tuple `(x, y)`.
- `radius`: The radius of the circle.
- `width`: The thickness of the circle's border. 0 for filled circle.
- `draw_top_right`: Flag to draw only the top-right quarter.
- `draw_top_left`: Flag to draw only the top-left quarter.
- `draw_bottom_left`: Flag to draw only the bottom-left quarter.
- `draw_bottom_right`: Flag to draw only the bottom-right quarter.

### Returns:
The rectangle area of the drawn circle.

### Maps to:
- `pygame.draw.circle`: This function draws a circle onto a surface.

## draw_rectangle(surface, x, y, width, height, hex_color, line_width=0, border_radius=0, border_top_left_radius=-1, border_top_right_radius=-1, border_bottom_left_radius=-1, border_bottom_right_radius=-1)

Draw a rectangle on the given surface at the specified coordinates.

### Parameters:
- `surface`: The surface to draw the rectangle on.
- `x`: The x-coordinate for the rectangle's top-left corner.
- `y`: The y-coordinate for the rectangle's top-left corner.
- `width`: The width of the rectangle.
- `height`: The height of the rectangle.
- `hex_color`: The color of the rectangle in hexadecimal format.
- `line_width`: The thickness of the rectangle's border. 0 for filled rectangle.
- `border_radius`: The radius of the rectangle's corners.
- `border_top_left_radius`: The radius of the top-left corner.
- `border_top_right_radius`: The radius of the top-right corner.
- `border_bottom_left_radius`: The radius of the bottom-left corner.
- `border_bottom_right_radius`: The radius of the bottom-right corner.

### Returns:
The rectangle area of the drawn rectangle.

### Maps to:
- `pygame.Rect`: This function creates a rectangle object with the specified position and dimensions.
- `pygame.draw.rect`: This function draws a rectangle onto a surface.

## draw_ellipse(surface, hex_color, rect, line_width=0)

Draw an ellipse inside the given rectangle area on the specified surface.

### Parameters:
- `surface`: The surface to draw the ellipse on.
- `hex_color`: The color of the ellipse in hexadecimal format.
- `rect`: The rectangle defining the bounds of the ellipse.
- `line_width`: The thickness of the ellipse's border. 0 for filled ellipse.

### Returns:
The rectangle area of the drawn ellipse.

### Maps to:
- `pygame.draw.ellipse`: This function draws an ellipse onto a surface.

## draw_arc(surface, hex_color, rect, start_angle, stop_angle, line_width=1)

Draw an elliptical arc inside the given rectangle area on the specified surface.

### Parameters:
- `surface`: The surface to draw the arc on.
- `hex_color`: The color of the arc in hexadecimal format.
- `rect`: The rectangle defining the bounds of the arc.
- `start_angle`: The starting angle of the arc in radians.
- `stop_angle`: The stopping angle of the arc in radians.
- `line_width`: The thickness of the arc's border.

### Returns:
The rectangle area of the drawn arc.

### Maps to:
- `pygame.draw.arc`: This function draws an arc onto a surface.

## draw_line(surface, hex_color, start_pos, end_pos, line_width=1)

Draw a straight line on the given surface between two points.

### Parameters:
- `surface`: The surface to draw the line on.
- `hex_color`: The color of the line in hexadecimal format.
- `start_pos`: The starting position of the line `(x, y)`.
- `end_pos`: The ending position of the line `(x, y)`.
- `line_width`: The thickness of the line.

### Returns:
The rectangle area of the drawn line.

### Maps to:
- `pygame.draw.line`: This function draws a line onto a surface.

## draw_lines(surface, hex_color, closed, points, line_width=1)

Draw multiple connected lines on the given surface.

### Parameters:
- `surface`: The surface to draw the lines on.
- `hex_color`: The color of the lines in hexadecimal format.
- `closed`: Whether the lines should form a closed shape.
- `points`: A list of points `(x, y)` to connect with lines.
- `line_width`: The thickness of the lines.

### Returns:
The rectangle area of the drawn lines.

### Maps to:
- `pygame.draw.lines`: This function draws connected lines onto a surface.

## draw_aaline(surface, hex_color, start_pos, end_pos, blend=1)

Draw an anti-aliased line on the given surface between two points.

### Parameters:
- `surface`: The surface to draw the line on.
- `hex_color`: The color of the line in hexadecimal format.
- `start_pos`: The starting position of the line `(x, y)`.
- `end_pos`: The ending position of the line `(x, y)`.
- `blend`: Whether to blend the colors.

### Returns:
The rectangle area of the drawn line.

### Maps to:
- `pygame.draw.aaline`: This function draws an anti-aliased line onto a surface.

## draw_aalines(surface, hex_color, closed, points, blend=1)

Draw multiple connected anti-aliased lines on the given surface.

### Parameters:
- `surface`: The surface to draw the lines on.
- `hex_color`: The color of the lines in hexadecimal format.
- `closed`: Whether the lines should form a closed shape.
- `points`: A list of points `(x, y)` to connect with lines.
- `blend`: Whether to blend the colors.

### Returns:
The rectangle area of the drawn lines.

### Maps to:
- `pygame.draw.aalines`: This function draws connected anti-aliased lines onto a surface.

## draw_polygon(surface, hex_color, points, width=0)

Draw a polygon on the given surface.

### Parameters:
- `surface`: The surface to draw the polygon on.
- `hex_color`: The color of the polygon in hexadecimal format.
- `points`: A list of points `(x, y)` to form the vertices of the polygon.
- `width`: The thickness of the polygon's border. 0 for filled polygon.

### Returns:
The rectangle area of the drawn polygon.

### Maps to:
- `pygame.draw.polygon`: This function draws a polygon onto a surface.

## clear_canvas(surface)

Clear the canvas by filling it with black.

### Parameters:
- `surface`: The surface to clear.

### Maps to:
- `pygame.Surface.fill`: This method fills the entire surface with the specified color.

# Python to Lua Bindings Documentation for Event Handling

# Event Handling Functions

### register_event_handler(event_name, handler)

Register a handler function for a specific event.

#### Parameters:
- `event_name`: Name of the event to handle (e.g., 'on_key_down').
- `handler`: The function to call when the event occurs.

### set_event_handling_active(active)

Set the flag to enable or disable event handling.

#### Parameters:
- `active`: True to enable event handling, False to disable it.

### handle_events()

Handle Pygame events by calling registered Lua event handlers. This function should be called regularly to process events and keep the UI responsive.

# Event Retrieval Functions

### get_event()

Get a single event from the event queue. Equivalent to `pygame.event.get()` but returns a single event.

### get_events(eventtype=None, pump=True, exclude=None)

Get events from the event queue. Equivalent to `pygame.event.get(eventtype, pump, exclude)`.

#### Parameters:
- `eventtype`: The type of events to get.
- `pump`: Whether to pump the event queue.
- `exclude`: Events to exclude from the returned list.

### pump_events()

Pump the event queue to keep the UI responsive. Equivalent to `pygame.event.pump()`.

### poll_event()

Poll for a single event from the event queue. Equivalent to `pygame.event.poll()`.

### wait_event()

Wait for a single event from the event queue. Equivalent to `pygame.event.wait()`.

### peek_event(eventtype=None)

Check if there are events of a certain type in the event queue. Equivalent to `pygame.event.peek(eventtype)`.

#### Parameters:
- `eventtype`: The type of events to check for.

### clear_events(eventtype=None)

Clear events from the event queue. Equivalent to `pygame.event.clear(eventtype)`.

#### Parameters:
- `eventtype`: The type of events to clear.

### event_name(event_id)

Get the name of an event given its ID. Equivalent to `pygame.event.event_name(event_id)`.

#### Parameters:
- `event_id`: The ID of the event.

# Other Event System Functions

### set_blocked(eventtype)

Block a certain type of event. Equivalent to `pygame.event.set_blocked(eventtype)`.

#### Parameters:
- `eventtype`: The type of event to block.

### set_allowed(eventtype)

Allow a certain type of event. Equivalent to `pygame.event.set_allowed(eventtype)`.

#### Parameters:
- `eventtype`: The type of event to allow.

### get_blocked(eventtype)

Check if a certain type of event is blocked. Equivalent to `pygame.event.get_blocked(eventtype)`.

#### Parameters:
- `eventtype`: The type of event to check.

### set_grab(grab)

Set the input grab mode. Equivalent to `pygame.event.set_grab(grab)`.

#### Parameters:
- `grab`: Boolean flag to enable or disable input grab.

### get_grab()

Get the current input grab mode. Equivalent to `pygame.event.get_grab()`.

### set_keyboard_grab(grab)

Set the keyboard input grab mode. Equivalent to `pygame.event.set_keyboard_grab(grab)`.

#### Parameters:
- `grab`: Boolean flag to enable or disable keyboard input grab.

### get_keyboard_grab()

Get the current keyboard input grab mode. Equivalent to `pygame.event.get_keyboard_grab()`.

### post_event(event)

Post a new event to the event queue. Equivalent to `pygame.event.post(event)`.

#### Parameters:
- `event`: The event to post.

### custom_event_type()

Create a new custom event type. Equivalent to `pygame.event.custom_type()`.

### Event(eventtype, dict=None)

Create a new event object. Equivalent to `pygame.event.Event(eventtype, dict)`.

#### Parameters:
- `eventtype`: The type of event to create.
- `dict`: Dictionary of attributes for the event.

# Font Module Functions

## init_font_module()

Initialize the Pygame font module.

### Maps to:
- `pygame.font.init()`: This function initializes the Pygame font module.

## quit_font_module()

Quit the Pygame font module.

### Maps to:
- `pygame.font.quit()`: This function quits the Pygame font module.

## is_font_initialized()

Check if the Pygame font module is initialized.

### Returns:
- `True` if the font module is initialized, `False` otherwise.

### Maps to:
- `pygame.font.get_init()`: This function returns whether the Pygame font module is initialized.

## get_default_font()

Get the default system font.

### Returns:
- The path to the default system font.

### Maps to:
- `pygame.font.get_default_font()`: This function returns the path to the default system font.

## get_fonts()

Get a list of available font names.

### Returns:
- A list of available font names.

### Maps to:
- `pygame.font.get_fonts()`: This function returns a list of available font names.

## match_font(name, bold=False, italic=False)

Find a font that matches the given name, bold, and italic style.

### Parameters:
- `name`: The name of the font to match.
- `bold`: Whether the font should be bold. Default is `False`.
- `italic`: Whether the font should be italic. Default is `False`.

### Returns:
- The path to the matched font file.

### Maps to:
- `pygame.font.match_font()`: This function finds a font that matches the given parameters.

## create_sys_font(name, size, bold=False, italic=False)

Create a system font with the specified name, size, bold, and italic style.

### Parameters:
- `name`: The name of the font.
- `size`: The size of the font.
- `bold`: Whether the font should be bold. Default is `False`.
- `italic`: Whether the font should be italic. Default is `False`.

### Returns:
- A font object.

### Maps to:
- `pygame.font.SysFont()`: This function creates a system font with the specified parameters.

## create_font(file_path=None, size=12)

Create a font from a file with the specified path and size.

### Parameters:
- `file_path`: The path to the font file. If `None`, the default system font is used. Default is `None`.
- `size`: The size of the font. Default is `12`.

### Returns:
- A font object.

### Maps to:
- `pygame.font.Font()`: This function creates a font from a file with the specified path and size.

# Image Functions

## load_image(image_path)

Load an image from the specified path.

### Parameters:
- `image_path`: The path to the image file to be loaded.

### Returns:
The loaded image as a Pygame surface object.

### Maps to:
- `pygame.image.load`: This function is used internally to load an image.

## draw_image(surface, image, x, y)

Draw the loaded image on the given surface at the specified coordinates.

### Parameters:
- `surface`: The Pygame surface object on which to draw the image.
- `image`: The image to draw on the surface.
- `x`: The x-coordinate of the top-left corner of the image on the surface.
- `y`: The y-coordinate of the top-left corner of the image on the surface.

### Maps to:
- `surface.blit`: This function is used internally to draw an image on a surface.

## save_image(image, image_path)

Save the image to the specified path.

### Parameters:
- `image`: The image to be saved.
- `image_path`: The path where the image will be saved.

### Maps to:
- `pygame.image.save`: This function is used internally to save an image.

# Key Functions

## get_focused()

Check if the Pygame window is currently focused.

### Returns:
- `True` if the Pygame window is focused, `False` otherwise.

### Maps to:
- `pygame.key.get_focused()`: This function checks if the Pygame window is currently focused.

## get_pressed()

Get the state of all keyboard keys.

### Returns:
A Lua table containing the state of all keyboard keys, where the keys are the key codes and the values are `True` if the key is pressed, `False` otherwise.

### Maps to:
- `pygame.key.get_pressed()`: This function returns the state of all keyboard keys as a list.

## get_mods()

Get the state of modifier keys (Shift, Ctrl, Alt, etc.).

### Returns:
An integer representing the state of modifier keys.

### Maps to:
- `pygame.key.get_mods()`: This function returns an integer representing the state of modifier keys.

## set_mods(mods)

Set the state of modifier keys (Shift, Ctrl, Alt, etc.).

### Parameters:
- `mods`: An integer representing the new state of modifier keys.

### Maps to:
- `pygame.key.set_mods(mods)`: This function sets the state of modifier keys.

## set_repeat(delay=None, interval=None)

Set keyboard key repeat behavior.

### Parameters:
- `delay`: The delay in milliseconds before the first repeated key event. If `None`, the key repeat is disabled.
- `interval`: The interval in milliseconds between repeated key events.

### Maps to:
- `pygame.key.set_repeat(delay, interval)`: This function sets the keyboard key repeat behavior.

## get_repeat()

Get the current keyboard key repeat delay and interval.

### Returns:
A tuple containing the delay and interval in milliseconds.

### Maps to:
- `pygame.key.get_repeat()`: This function returns the current keyboard key repeat delay and interval.

## key_name(key, use_compat=True)

Get the name of a key given its key code.

### Parameters:
- `key`: The key code.
- `use_compat`: Whether to use the compatibility key names. Default is `True`.

### Returns:
The name of the key.

### Maps to:
- `pygame.key.name(key, use_compat)`: This function returns the name of a key given its key code.

## key_code(name)

Get the key code of a key given its name.

### Parameters:
- `name`: The name of the key.

### Returns:
The key code of the key.

### Maps to:
- `pygame.key.key_code(name)`: This function returns the key code of a key given its name.

## start_text_input()

Start text input mode.

### Maps to:
- `pygame.key.start_text_input()`: This function starts text input mode.

## stop_text_input()

Stop text input mode.

### Maps to:
- `pygame.key.stop_text_input()`: This function stops text input mode.

## set_text_input_rect(rect)

Set the rectangle where text input will be captured.

### Parameters:
- `rect`: A tuple or list containing the (x, y, width, height) of the rectangle.

### Maps to:
- `pygame.key.set_text_input_rect(rect)`: This function sets the rectangle where text input will be captured.

# Math Functions

## clamp(value, min_val, max_val)

Clamps a numeric value so that it's no lower than min_val, and no higher than max_val.

### Parameters:
- `value`: The value to clamp.
- `min_val`: The minimum value.
- `max_val`: The maximum value.

### Returns:
The clamped value.

### Maps to:
- `max`: This function is used to find the maximum value between two numbers.
- `min`: This function is used to find the minimum value between two numbers.

## lerp(a, b, weight)

Linearly interpolates between a and b by weight.

### Parameters:
- `a`: The start value.
- `b`: The end value.
- `weight`: The weight of interpolation.

### Returns:
The interpolated value.

### Maps to:
- Arithmetic operations: This function performs arithmetic operations to calculate the linear interpolation.

## Vector2(x, y=None)

Create a 2D vector.

### Parameters:
- `x`: The x component of the vector.
- `y`: The y component of the vector (optional).

### Returns:
A 2D vector object.

### Maps to:
- `pygame.math.Vector2`: This function creates a 2D vector.

## Vector3(x, y, z)

Create a 3D vector.

### Parameters:
- `x`: The x component of the vector.
- `y`: The y component of the vector.
- `z`: The z component of the vector.

### Returns:
A 3D vector object.

### Maps to:
- `pygame.math.Vector3`: This function creates a 3D vector.

# Time Functions

## get_ticks()

Get the time in milliseconds since pygame.init() was called.

### Returns:
Number of milliseconds.

### Maps to:
- `pygame.time.get_ticks()`: This function returns the time in milliseconds since Pygame initialization.

## wait(milliseconds)

Pause the program for an amount of time.

### Parameters:
- `milliseconds`: Number of milliseconds to pause.

### Returns:
Actual number of milliseconds used.

### Maps to:
- `pygame.time.wait(milliseconds)`: This function pauses the program for the specified number of milliseconds.

## delay(milliseconds)

Pause the program for an amount of time.

### Parameters:
- `milliseconds`: Number of milliseconds to pause.

### Returns:
Actual number of milliseconds used.

### Maps to:
- `pygame.time.delay(milliseconds)`: This function pauses the program for the specified number of milliseconds.

## set_timer(event, millis, loops=0)

Set an event to appear on the event queue every given number of milliseconds.

### Parameters:
- `event`: Event type or pygame.event.Event object.
- `millis`: Time in milliseconds.
- `loops`: Number of events to post (0 for infinite).

### Maps to:
- `pygame.time.set_timer(event, millis, loops)`: This function sets an event to appear on the event queue every given number of milliseconds.

## Clock

A class for managing time-related operations.

### Methods:

### __init__()
Constructor method to initialize the Clock object.

### tick(framerate=0)
Update the clock.

#### Parameters:
- `framerate`: Frame rate to cap.

#### Returns:
Number of milliseconds passed since the last call.

### tick_busy_loop(framerate=0)
Update the clock using a busy loop.

#### Parameters:
- `framerate`: Frame rate to cap.

#### Returns:
Number of milliseconds passed since the last call.

### get_time()
Get the time used in the previous tick.

#### Returns:
Number of milliseconds.

### get_rawtime()
Get the actual time used in the previous tick.

#### Returns:
Number of milliseconds.

### get_fps()
Compute the clock framerate.

#### Returns:
Frames per second.

### Python to Lua Bindings Documentation for Pygame Utils

## initialize_pygame()

Initialize Pygame modules.

### Returns:
None.

### Maps to:
- `pygame.display.init()`: Initializes Pygame display module.
- `pygame.font.init()`: Initializes Pygame font module.

## delay(milliseconds)

Delay execution for a given number of milliseconds.

### Parameters:
- `milliseconds`: The number of milliseconds to delay execution.

### Returns:
None.

### Maps to:
- `pygame.time.delay(milliseconds)`: Delays execution for the specified number of milliseconds.

## sleep(seconds)

Delay execution for a given number of seconds.

### Parameters:
- `seconds`: The number of seconds to delay execution.

### Returns:
None.

### Maps to:
- `time.sleep(seconds)`: Delays execution for the specified number of seconds.

# Math Functions

The following math functions are exposed to Lua from Python:

### get_pi()

Return the value of pi.

### Parameters:
None.

### Returns:
The value of pi.

### Maps to:
- `pi`: The mathematical constant pi.

### get_sin(x)

Return the sine of x (measured in radians).

### Parameters:
- `x`: Angle in radians.

### Returns:
The sine of x.

### Maps to:
- `sin(x)`: Sine function in Python's math module.

### get_cos(x)

Return the cosine of x (measured in radians).

### Parameters:
- `x`: Angle in radians.

### Returns:
The cosine of x.

### Maps to:
- `cos(x)`: Cosine function in Python's math module.

### get_tan(x)

Return the tangent of x (measured in radians).

### Parameters:
- `x`: Angle in radians.

### Returns:
The tangent of x.

### Maps to:
- `tan(x)`: Tangent function in Python's math module.

### get_asin(x)

Return the arc sine of x, in radians.

### Parameters:
- `x`: Value whose arc sine is to be calculated.

### Returns:
The arc sine of x.

### Maps to:
- `asin(x)`: Arc sine function in Python's math module.

### get_acos(x)

Return the arc cosine of x, in radians.

### Parameters:
- `x`: Value whose arc cosine is to be calculated.

### Returns:
The arc cosine of x.

### Maps to:
- `acos(x)`: Arc cosine function in Python's math module.

### get_atan(x)

Return the arc tangent of x, in radians.

### Parameters:
- `x`: Value whose arc tangent is to be calculated.

### Returns:
The arc tangent of x.

### Maps to:
- `atan(x)`: Arc tangent function in Python's math module.

### get_atan2(y, x)

Return atan(y / x), in radians. The result is between -pi and pi.

### Parameters:
- `y`: Numerator.
- `x`: Denominator.

### Returns:
The arc tangent of y / x.

### Maps to:
- `atan2(y, x)`: Two-argument arc tangent function in Python's math module.

### get_exp(x)

Return e raised to the power of x.

### Parameters:
- `x`: Exponent.

### Returns:
The value of e raised to the power of x.

### Maps to:
- `exp(x)`: Exponential function in Python's math module.

### get_log(x, base=None)

Return the logarithm of x to the given base. If the base is not specified, returns the natural logarithm (base e) of x.

### Parameters:
- `x`: Number.
- `base`: Base of the logarithm. If not specified, defaults to natural logarithm.

### Returns:
The logarithm of x to the given base.

### Maps to:
- `log(x, base)`: Logarithm function in Python's math module.

### get_log10(x)

Return the base-10 logarithm of x.

### Parameters:
- `x`: Number.

### Returns:
The base-10 logarithm of x.

### Maps to:
- `log10(x)`: Base-10 logarithm function in Python's math module.

### get_pow(x, y)

Return x raised to the power of y.

### Parameters:
- `x`: Base.
- `y`: Exponent.

### Returns:
x raised to the power of y.

### Maps to:
- `pow(x, y)`: Power function in Python's math module.

### get_sqrt(x)

Return the square root of x.

### Parameters:
- `x`: Number.

### Returns:
The square root of x.

### Maps to:
- `sqrt(x)`: Square root function in Python's math module.

### get_ceil(x)

Return the ceiling of x as an Integral.

### Parameters:
- `x`: Number.

### Returns:
The smallest integer greater than or equal to x.

### Maps to:
- `ceil(x)`: Ceiling function in Python's math module.

### get_floor(x)

Return the floor of x as an Integral.

### Parameters:
- `x`: Number.

### Returns:
The largest integer less than or equal to x.

### Maps to:
- `floor(x)`: Floor function in Python's math module.

### get_fabs(x)

Return the absolute value of x.

### Parameters:
- `x`: Number.

### Returns:
The absolute value of x.

### Maps to:
- `fabs(x)`: Absolute value function in Python's math module.

# Version Functions

## version()

Return the version of the Pygame library.

### Usage in Lua:
```lua
pygame_version = version()
print(pygame_version)
```
### Maps to:

- `pygame.version.ver`: This attribute retrieves the version of the Pygame library.

get_sdl_version()

Return the version of the SDL library that Pygame uses.

### Usage in Lua:
```lua
pygame_sdl_version = get_sdl_version()
print(pygame_sdl_version)
```

## Pygame Key Constants

### Key Constants:
- `K_BACKSPACE`: Backspace key
- `K_TAB`: Tab key
- `K_CLEAR`: Clear key
- `K_RETURN`: Return key
- `K_PAUSE`: Pause key
- `K_ESCAPE`: Escape key
- `K_SPACE`: Space key
- `K_EXCLAIM`: Exclaim (!) key
- `K_QUOTEDBL`: Double quote (") key
- `K_HASH`: Hash (#) key
- `K_DOLLAR`: Dollar ($) key
- `K_AMPERSAND`: Ampersand (&) key
- `K_QUOTE`: Quote (') key
- `K_LEFTPAREN`: Left parenthesis (() key
- `K_RIGHTPAREN`: Right parenthesis ()) key
- `K_ASTERISK`: Asterisk (*) key
- `K_PLUS`: Plus (+) key
- `K_COMMA`: Comma (,) key
- `K_MINUS`: Minus (-) key
- `K_PERIOD`: Period (.) key
- `K_SLASH`: Forward slash (/) key
- `K_0` to `K_9`: Numeric keys 0 to 9
- `K_COLON`: Colon (:) key
- `K_SEMICOLON`: Semicolon (;) key
- `K_LESS`: Less than (<) key
- `K_EQUALS`: Equals (=) key
- `K_GREATER`: Greater than (>) key
- `K_QUESTION`: Question mark (?) key
- `K_AT`: At (@) key
- `K_LEFTBRACKET`: Left bracket ([) key
- `K_BACKSLASH`: Backslash (\) key
- `K_RIGHTBRACKET`: Right bracket (]) key
- `K_CARET`: Caret (^) key
- `K_UNDERSCORE`: Underscore (_) key
- `K_BACKQUOTE`: Backquote (`) key
- `K_a` to `K_z`: Alphabetic keys a to z
- `K_DELETE`: Delete key
- `K_KP0` to `K_KP9`: Numeric keypad keys 0 to 9
- `K_KP_PERIOD`: Keypad period (.) key
- `K_KP_DIVIDE`: Keypad divide (/) key
- `K_KP_MULTIPLY`: Keypad multiply (*) key
- `K_KP_MINUS`: Keypad minus (-) key
- `K_KP_PLUS`: Keypad plus (+) key
- `K_KP_ENTER`: Keypad enter key
- `K_KP_EQUALS`: Keypad equals (=) key
- `K_UP`: Up arrow key
- `K_DOWN`: Down arrow key
- `K_RIGHT`: Right arrow key
- `K_LEFT`: Left arrow key
- `K_INSERT`: Insert key
- `K_HOME`: Home key
- `K_END`: End key
- `K_PAGEUP`: Page up key
- `K_PAGEDOWN`: Page down key
- `K_F1` to `K_F15`: Function keys F1 to F15
- `K_NUMLOCK`: Num Lock key
- `K_CAPSLOCK`: Caps Lock key
- `K_SCROLLOCK`: Scroll Lock key
- `K_RSHIFT`: Right Shift key
- `K_LSHIFT`: Left Shift key
- `K_RCTRL`: Right Control key
- `K_LCTRL`: Left Control key
- `K_RALT`: Right Alt key
- `K_LALT`: Left Alt key
- `K_RMETA`: Right Meta key
- `K_LMETA`: Left Meta key
- `K_LSUPER`: Left Super key
- `K_RSUPER`: Right Super key
- `K_MODE`: Mode key
- `K_HELP`: Help key
- `K_PRINT`: Print key
- `K_SYSREQ`: SysReq key
- `K_BREAK`: Break key
- `K_MENU`: Menu key
- `K_POWER`: Power key
- `K_EURO`: Euro key
- `K_AC_BACK`: AC Back key

## Pygame Event Constants

### Event Constants:
- `MOUSEBUTTONDOWN`: Mouse button down event
- `MOUSEBUTTONUP`: Mouse button up event
- `MOUSEMOTION`: Mouse motion event
- `QUIT`: Quit event
- `VIDEORESIZE`: Video resize event
- `KEYDOWN`: Key down event
- `KEYUP`: Key up event