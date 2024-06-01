import pygame

def hex_to_rgb(hex_color):
    """
    Convert a hexadecimal color or common color name to an RGB tuple.
    :param hex_color: The color in hexadecimal format, either as a string or integer, or a common color name.
    :return: A tuple representing the RGB color.
    """
    if hex_color is None:
        raise ValueError("hex_color cannot be None")

    # Dictionary mapping common color names to their hexadecimal values
    color_names = {
        'black': '000000',
        'white': 'ffffff',
        'red': 'ff0000',
        'lime': '00ff00',
        'blue': '0000ff',
        'yellow': 'ffff00',
        'cyan': '00ffff',
        'magenta': 'ff00ff',
        'silver': 'c0c0c0',
        'gray': '808080',
        'maroon': '800000',
        'olive': '808000',
        'green': '008000',
        'purple': '800080',
        'teal': '008080',
        'navy': '000080',
    }

    # Check if hex_color is a common color name
    if isinstance(hex_color, str) and hex_color.lower() in color_names:
        hex_color = color_names[hex_color.lower()]

    # If hex_color is an integer, convert it to a hexadecimal string
    if isinstance(hex_color, int):
        hex_color = f"{hex_color:06x}"

    # Ensure hex_color is a string at this point
    if not isinstance(hex_color, str):
        raise ValueError("hex_color must be a string or an integer")

    # Remove leading '#' if present
    hex_color = hex_color.lstrip('#')
    lv = len(hex_color)

    # Convert hex to RGB tuple
    return tuple(int(hex_color[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))

def color(r, g, b, a=255):
    """
    Create a color with the specified RGB and alpha values.
    :param r: The red component of the color (0-255).
    :param g: The green component of the color (0-255).
    :param b: The blue component of the color (0-255).
    :param a: The alpha component of the color (0-255). Default is 255 (opaque).
    :return: A color object.
    """
    pygame.Color(r, g, b, a)
    return (r, g, b, a)

def THECOLORS():
    """
    Returns a lua table of color names and their RGB values. "{'aliceblue': (240, 248, 255, 255), 'antiquewhite': (250, 235, 215, 255), 'antiquewhite1': (255, 239, 219, 255)...."
    """
    color_dict = pygame.color.THECOLORS
    return {key: tuple(value) for key, value in color_dict.items()}

