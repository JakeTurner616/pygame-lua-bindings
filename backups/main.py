import tkinter as tk
import tkinter.scrolledtext as scrolledtext
from lupa import LuaRuntime
import pygame
import sys
from pygame_functions.color import hex_to_rgb

# Function to execute Lua code
def execute_lua_code():
    lua_code = editor.get("1.0", tk.END)  # Get Lua code from the editor
    try:
        lua.execute(lua_code)  # Execute the Lua code
    except Exception as e:
        print(f"Error executing Lua code: {e}")

# Initialize Pygame
def initialize_pygame():
    try:
        pygame.init()
    except Exception as e:
        print(f"Error initializing Pygame: {e}")
        sys.exit(1)


# Function to draw text on the Pygame screen
def draw_text(x, y, text, font_name, font_size, hex_color):
    color = hex_to_rgb(hex_color)
    print("Attempting to render text with color:", color)
    font = pygame.font.SysFont(font_name, font_size)
    try:
        text_surface = font.render(text, True, color)
        screen.blit(text_surface, (x, y))
        pygame.display.flip()  # Update the Pygame display
    except Exception as e:
        print(f"Error rendering text: {e}")

# Function to draw a circle
def draw_circle(x, y, radius, hex_color):
    color = hex_to_rgb(hex_color)
    print(f"Drawing circle at ({x}, {y}) with radius {radius} and color {color}")
    try:
        pygame.draw.circle(screen, color, (x, y), radius)
        pygame.display.flip()  # Update the Pygame display
    except Exception as e:
        print(f"Error drawing circle: {e}")

# Function to clear the Pygame canvas
def clear_canvas():
    screen.fill((0, 0, 0))  # Fill the screen with black (or any other color you prefer)
    pygame.display.flip()   # Update the Pygame display

# Function to handle Pygame events
def handle_events():
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            lua.globals().on_key_down(event.key)

# Expose the Pygame functions to Lua
def expose_pygame_hooks(lua):
    lua.globals().draw_text = draw_text
    lua.globals().draw_circle = draw_circle
    lua.globals().clear_canvas = clear_canvas
    lua.globals().handle_events = handle_events

# Create the main window
root = tk.Tk()
root.title("Lua Scripting with Python")

# Create a text editor for Lua code
editor = scrolledtext.ScrolledText(root, width=40, height=10)
editor.pack(fill=tk.BOTH, expand=True)

# Create a button to execute Lua code
execute_button = tk.Button(root, text="Execute Lua Code", command=execute_lua_code)
execute_button.pack()

# Create a button to clear the Pygame canvas
clear_button = tk.Button(root, text="Clear Canvas", command=clear_canvas)
clear_button.pack()

# Create a Lua runtime
lua = LuaRuntime(unpack_returned_tuples=True)

# Initialize Pygame
initialize_pygame()

# Create a Pygame screen
screen = pygame.display.set_mode((400, 300))

# Expose Pygame hooks to Lua
expose_pygame_hooks(lua)

# Main loop to handle Pygame events
def main_loop():
    while True:
        handle_events()
        root.update_idletasks()
        root.update()

# Start the main loop
main_loop()