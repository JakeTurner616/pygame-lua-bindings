import pygame

def load_image(image_path):
    """Load an image from the specified path."""
    try:
        image = pygame.image.load(image_path)
        return image
    except Exception as e:
        print(f"Error loading image: {e}")
        return None

def draw_image(surface, image, x, y):
    """Draw the loaded image on the given surface at the specified coordinates."""
    if image:
        try:
            surface.blit(image, (x, y))
        except Exception as e:
            print(f"Error drawing image: {e}")
    else:
        print("No image to draw.")

def save_image(image, image_path):
    """Save the image to the specified path."""
    try:
        pygame.image.save(image, image_path)
        print(f"Image saved to {image_path}")
    except Exception as e:
        print(f"Error saving image: {e}")
