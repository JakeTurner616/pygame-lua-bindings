#/pygame_functions/drawing.py
# This file contains pygame lua bindings for drawing shapes and text on the screen.
import pygame
from lupa import LuaRuntime
from pygame_functions.color import hex_to_rgb

def draw_text(surface, x, y, text, font_name, font_size, hex_color):
    """
    Draw text on the given surface at the specified coordinates.
    :param surface: The surface to draw the text on.
    :param x: The x-coordinate for the text position.
    :param y: The y-coordinate for the text position.
    :param text: The text string to draw.
    :param font_name: The name of the font to use.
    :param font_size: The size of the font.
    :param hex_color: The color of the text in hexadecimal format or as a string: `"red"`.
    :return: The rectangle area of the rendered text.
    """
    color = hex_to_rgb(hex_color)
    font = pygame.font.SysFont(font_name, font_size)
    text_surface = font.render(text, True, color)
    surface.blit(text_surface, (x, y))
    return text_surface.get_rect()

def draw_circle(surface, hex_color, center, radius, width=0, draw_top_right=False, draw_top_left=False, draw_bottom_left=False, draw_bottom_right=False):
    """
    Draw a circle on the given surface.
    :param surface: The surface to draw the circle on.
    :param hex_color: The color of the circle in hexadecimal format.
    :param center: The center point of the circle as a tuple (x, y).
    :param radius: The radius of the circle.
    :param width: The thickness of the circle's border. 0 for filled circle.
    :param draw_top_right: Flag to draw only the top-right quarter.
    :param draw_top_left: Flag to draw only the top-left quarter.
    :param draw_bottom_left: Flag to draw only the bottom-left quarter.
    :param draw_bottom_right: Flag to draw only the bottom-right quarter.
    :return: The rectangle area of the drawn circle.
    """
    color = hex_to_rgb(hex_color)
    try:
        if hasattr(center, 'items'):
            center = [v for k, v in sorted(center.items())]

        if not (isinstance(center, (list, tuple)) and len(center) == 2):
            raise TypeError("center must be a sequence of two numbers")

        if not isinstance(radius, (int, float)):
            raise TypeError("radius must be a number")

        return pygame.draw.circle(surface, color, center, radius, width, draw_top_right=draw_top_right, draw_top_left=draw_top_left, draw_bottom_left=draw_bottom_left, draw_bottom_right=draw_bottom_right)
    except Exception as e:
        print(f"Error in draw_circle: {e}")
        print(f"Offending center: {center}, radius: {radius}")
        return None


def draw_rectangle(surface, x, y, width, height, hex_color, line_width=0, border_radius=0, border_top_left_radius=-1, border_top_right_radius=-1, border_bottom_left_radius=-1, border_bottom_right_radius=-1):
    """
    Draw a rectangle on the given surface at the specified coordinates.
    :param surface: The surface to draw the rectangle on.
    :param x: The x-coordinate for the rectangle's top-left corner.
    :param y: The y-coordinate for the rectangle's top-left corner.
    :param width: The width of the rectangle.
    :param height: The height of the rectangle.
    :param hex_color: The color of the rectangle in hexadecimal format.
    :param line_width: The thickness of the rectangle's border. 0 for filled rectangle.
    :param border_radius: The radius of the rectangle's corners.
    :param border_top_left_radius: The radius of the top-left corner.
    :param border_top_right_radius: The radius of the top-right corner.
    :param border_bottom_left_radius: The radius of the bottom-left corner.
    :param border_bottom_right_radius: The radius of the bottom-right corner.
    :return: The rectangle area of the drawn rectangle.
    """
    color = hex_to_rgb(hex_color)
    rect = pygame.Rect(x, y, width, height)
    return pygame.draw.rect(surface, color, rect, line_width, border_radius, border_top_left_radius, border_top_right_radius, border_bottom_left_radius, border_bottom_right_radius)

def draw_ellipse(surface, hex_color, rect, line_width=0):
    """
    Draw an ellipse inside the given rectangle area on the specified surface.
    :param surface: The surface to draw the ellipse on.
    :param hex_color: The color of the ellipse in hexadecimal format.
    :param rect: The rectangle defining the bounds of the ellipse.
    :param line_width: The thickness of the ellipse's border. 0 for filled ellipse.
    :return: The rectangle area of the drawn ellipse.
    """
    color = hex_to_rgb(hex_color)
    return pygame.draw.ellipse(surface, color, rect, line_width)

def draw_arc(surface, hex_color, rect, start_angle, stop_angle, line_width=1):
    """
    Draw an elliptical arc inside the given rectangle area on the specified surface.
    :param surface: The surface to draw the arc on.
    :param hex_color: The color of the arc in hexadecimal format.
    :param rect: The rectangle defining the bounds of the arc.
    :param start_angle: The starting angle of the arc in radians.
    :param stop_angle: The stopping angle of the arc in radians.
    :param line_width: The thickness of the arc's border.
    :return: The rectangle area of the drawn arc.
    """
    color = hex_to_rgb(hex_color)
    return pygame.draw.arc(surface, color, rect, start_angle, stop_angle, line_width)

def draw_line(surface, hex_color, start_pos, end_pos, line_width=1):
    """
    Draw a straight line on the given surface between two points.
    :param surface: The surface to draw the line on.
    :param hex_color: The color of the line in hexadecimal format.
    :param start_pos: The starting position of the line (x, y).
    :param end_pos: The ending position of the line (x, y).
    :param line_width: The thickness of the line.
    :return: The rectangle area of the drawn line.
    """
    color = hex_to_rgb(hex_color)
    return pygame.draw.line(surface, color, start_pos, end_pos, line_width)

def draw_lines(surface, hex_color, closed, points, line_width=1):
    """
    Draw multiple connected lines on the given surface.
    :param surface: The surface to draw the lines on.
    :param hex_color: The color of the lines in hexadecimal format.
    :param closed: Whether the lines should form a closed shape.
    :param points: A list of points (x, y) to connect with lines.
    :param line_width: The thickness of the lines.
    :return: The rectangle area of the drawn lines.
    """
    color = hex_to_rgb(hex_color)
    return pygame.draw.lines(surface, color, closed, points, line_width)

def draw_aaline(surface, hex_color, start_pos, end_pos, blend=1):
    """
    Draw an anti-aliased line on the given surface between two points.
    :param surface: The surface to draw the line on.
    :param hex_color: The color of the line in hexadecimal format.
    :param start_pos: The starting position of the line (x, y).
    :param end_pos: The ending position of the line (x, y).
    :param blend: Whether to blend the colors.
    :return: The rectangle area of the drawn line.
    """
    color = hex_to_rgb(hex_color)
    return pygame.draw.aaline(surface, color, start_pos, end_pos, blend)

def draw_aalines(surface, hex_color, closed, points, blend=1):
    """
    Draw multiple connected anti-aliased lines on the given surface.
    :param surface: The surface to draw the lines on.
    :param hex_color: The color of the lines in hexadecimal format.
    :param closed: Whether the lines should form a closed shape.
    :param points: A list of points (x, y) to connect with lines.
    :param blend: Whether to blend the colors.
    :return: The rectangle area of the drawn lines.
    """
    color = hex_to_rgb(hex_color)
    return pygame.draw.aalines(surface, color, closed, points, blend)

def draw_polygon(surface, hex_color, points, width=0):
    """
    Draw a polygon on the given surface.
    :param surface: The surface to draw the polygon on.
    :param hex_color: The color of the polygon in hexadecimal format.
    :param points: A list of points (x, y) to form the vertices of the polygon.
    :param width: The thickness of the polygon's border. 0 for filled polygon.
    :return: The rectangle area of the drawn polygon.
    
    Example usage in Lua:
    
    ```
    -- Clear the screen and draw some shapes
    clear_canvas()

    -- Draw a diamond
    local diamond_points = {300, 300, 350, 250, 400, 300, 350, 350}
    draw_polygon(0xFFFF00, diamond_points)  -- Yellow diamond

    -- Draw a triangle
    local triangle_points = {500, 300, 550, 250, 600, 300}
    draw_polygon(0xFF00FF, triangle_points)  -- Magenta triangle
    ```
    """
    color = hex_to_rgb(hex_color)
    try:
        # Convert Lua table to a Python list if needed
        if hasattr(points, 'items'):
            points = [v for k, v in sorted(points.items())]

        if points is None:
            raise ValueError("points is None")

        if len(points) % 2 != 0:
            raise ValueError("points list must contain an even number of elements")

        # Ensure all points are numbers
        for i, point in enumerate(points):
            if not isinstance(point, (int, float)):
                raise TypeError(f"Point at index {i} is not a number: {point}")

        formatted_points = [(points[i], points[i + 1]) for i in range(0, len(points), 2)]
        return pygame.draw.polygon(surface, color, formatted_points, width)
    except Exception as e:
        print(f"Error in draw_polygon: {e}")
        print(f"Offending points: {points}")
        return None








def clear_canvas(surface):
    """
    Clear the canvas by filling it with black.
    :param surface: The surface to clear.
    """
    surface.fill((0, 0, 0))