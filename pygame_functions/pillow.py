from PIL import Image
import pygame

# Load image and store pixel data as Pygame surface
def load_image_from_pil(image_path):
    img = Image.open(image_path)
    img = img.convert("RGB")  # Ensure image is in RGB format
    mode = img.mode
    size = img.size
    data = img.tobytes()

    # Convert PIL image to Pygame surface
    pygame_image = pygame.image.fromstring(data, size, mode)
    return pygame_image

# Get the color of a pixel
def get_pixel_color(pixels, x, y):
    r, g, b = pixels[x, y]
    return {"r": r, "g": g, "b": b}

# Function to get pixel data as a Lua table
def get_image_data(image_path):
    img = Image.open(image_path)
    img = img.convert("RGB")
    pixels = img.load()
    width, height = img.size
    return {
        "width": width,
        "height": height,
        "pixels": pixels
    }