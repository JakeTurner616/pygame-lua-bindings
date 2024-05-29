import tkinter as tk
import tkinter.scrolledtext as scrolledtext
from lupa import LuaRuntime
import pygame

# Function to execute Lua code
def execute_lua_code():
    lua_code = editor.get("1.0", tk.END)  # Get Lua code from the editor
    lua.execute(lua_code)  # Execute the Lua code

# Initialize Pygame
def initialize_pygame():
    pygame.init()

# Function to draw text on the Pygame screen
def draw_text(x, y, text, font_size):
    font = pygame.font.SysFont(None, font_size)
    text_surface = font.render(text, True, (255, 255, 255))
    screen.blit(text_surface, (x, y))
    pygame.display.flip()  # Update the Pygame display

# Expose the draw_text function to Lua
def expose_pygame_hooks(lua):
    lua.globals().draw_text = draw_text

# Create the main window
root = tk.Tk()
root.title("Lua Scripting with Python")

# Create a text editor for Lua code
editor = scrolledtext.ScrolledText(root, width=40, height=10)
editor.pack(fill=tk.BOTH, expand=True)

# Create a button to execute Lua code
execute_button = tk.Button(root, text="Execute Lua Code", command=execute_lua_code)
execute_button.pack()

# Create a Lua runtime
lua = LuaRuntime(unpack_returned_tuples=True)

# Initialize Pygame
initialize_pygame()

# Create a Pygame screen
screen = pygame.display.set_mode((400, 300))

# Expose Pygame hooks to Lua
expose_pygame_hooks(lua)

# Start the Tkinter event loop
root.mainloop()