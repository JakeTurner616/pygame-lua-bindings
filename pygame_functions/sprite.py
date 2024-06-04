import pygame
import luadata
import traceback
import sys
import pickle
# Helper function to check if an object is a Lua table
def is_lua_table(obj):
    return hasattr(obj, '_lua_type')

# Define Lua bindings for pygame.sprite.Sprite
class SpriteWrapper:
    def __init__(self):
        self.sprite = pygame.sprite.Sprite()
        self.sprite.image = None
        self.sprite.rect = pygame.Rect(0, 0, 0, 0)  # Initialize rect to an empty rectangle

    def update(self, *args):
        self.sprite.update(*args)

    def add(self, *groups):
        self.sprite.add(*groups)

    def remove(self, *groups):
        self.sprite.remove(*groups)

    def kill(self):
        self.sprite.kill()

    def alive(self):
        return self.sprite.alive()

    def groups(self):
        return self.sprite.groups()

    def set_image(self, width, height, color):
        if is_lua_table(color):
            # Convert Lua table to a Python dictionary or list
            color_dict = dict(color)
            
            # Serialize and deserialize the Python dictionary
            serialized_color = pickle.dumps(color_dict)
            color = tuple(pickle.loads(serialized_color).values())
        else:
            # Assume color is already a tuple or a list
            color = tuple(color)
        
        # Create the surface and fill it with the color
        self.sprite.image = pygame.Surface((width, height))
        self.sprite.image.fill(color)
        self.sprite.rect = self.sprite.image.get_rect()

    def get_rect(self):
        if self.sprite.rect is None:
            return None
        return {
            'x': self.sprite.rect.x,
            'y': self.sprite.rect.y,
            'width': self.sprite.rect.width,
            'height': self.sprite.rect.height
        }

    def set_rect(self, x, y, width=None, height=None):
        # Check if values are None and handle appropriately
        if x is None or y is None:
            print("Error: x or y coordinates cannot be None.")
            return  # Exit the function if necessary coordinates are missing

        # Convert values to integers, ensuring compatibility with pygame.Rect
        x = int(x)
        y = int(y)
        width = int(width) if width is not None else 0  # Default width to 0 if not provided
        height = int(height) if height is not None else 0  # Default height to 0 if not provided

        if self.sprite.rect is None:
            # Initialize rect if not already done
            self.sprite.rect = pygame.Rect(x, y, width, height)
        else:
            # Update existing rect
            self.sprite.rect.x = x
            self.sprite.rect.y = y
            self.sprite.rect.width = width
            self.sprite.rect.height = height

    @staticmethod
    def from_sprite(sprite):
        wrapper = SpriteWrapper()
        wrapper.sprite = sprite
        return wrapper

# Define Lua bindings for pygame.sprite.Group
class GroupWrapper:
    def __init__(self):
        self.group = pygame.sprite.Group()

    def sprites(self):
        return [SpriteWrapper.from_sprite(sprite) for sprite in self.group.sprites()]

    def add(self, *sprites):
        self.group.add(*(sprite.sprite for sprite in sprites))

    def remove(self, *sprites):
        self.group.remove(*(sprite.sprite for sprite in sprites))

    def has(self, *sprites):
        return self.group.has(*(sprite.sprite for sprite in sprites))

    def update(self, *args):
        self.group.update(*args)

    def draw(self, surface):
        if not isinstance(surface, pygame.Surface):
            print("Error: The surface passed to draw() is not a valid pygame.Surface.")
            return
        self.group.draw(surface)

    def clear(self, surface, background):
        self.group.clear(surface, background)

    def empty(self):
        self.group.empty()

    @staticmethod
    def from_group(group):
        wrapper = GroupWrapper()
        wrapper.group = group
        return wrapper

# Define Lua bindings for pygame.sprite.WeakSprite
class WeakSpriteWrapper(SpriteWrapper):
    def __init__(self):
        self.sprite = pygame.sprite.WeakSprite()

# Define Lua bindings for pygame.sprite.DirtySprite
class DirtySpriteWrapper(SpriteWrapper):
    def __init__(self):
        self.sprite = pygame.sprite.DirtySprite()

    def set_dirty(self, value):
        self.sprite.dirty = value

# Define Lua bindings for pygame.sprite.LayeredUpdates
class LayeredUpdatesWrapper(GroupWrapper):
    def __init__(self):
        self.group = pygame.sprite.LayeredUpdates()

    def change_layer(self, sprite, new_layer):
        self.group.change_layer(sprite.sprite, new_layer)

    def get_layer_of_sprite(self, sprite):
        return self.group.get_layer_of_sprite(sprite.sprite)

    def get_sprites_from_layer(self, layer):
        return [SpriteWrapper.from_sprite(sprite) for sprite in self.group.get_sprites_from_layer(layer)]

    @staticmethod
    def from_group(group):
        wrapper = LayeredUpdatesWrapper()
        wrapper.group = group
        return wrapper

# Collision detection functions
def spritecollide(sprite, group, dokill):
    return pygame.sprite.spritecollide(sprite.sprite, group.group, dokill)

def collide_rect(left, right):
    return pygame.sprite.collide_rect(left.sprite, right.sprite)

def collide_circle(left, right):
    return pygame.sprite.collide_circle(left.sprite, right.sprite)
