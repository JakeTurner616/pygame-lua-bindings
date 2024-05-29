import pygame


# pygame math functions
def clamp(value, min_val, max_val):
    """
    Clamps a numeric value so that it's no lower than min_val, and no higher than max_val.
    :param value: The value to clamp.
    :param min_val: The minimum value.
    :param max_val: The maximum value.
    :return: The clamped value.
    """
    return max(min_val, min(value, max_val))

def lerp(a, b, weight):
    """
    Linearly interpolates between a and b by weight.
    :param a: The start value.
    :param b: The end value.
    :param weight: The weight of interpolation.
    :return: The interpolated value.
    """
    return a + (b - a) * weight

def Vector2(x, y=None):
    """
    Create a 2D vector.
    :param x: The x component of the vector.
    :param y: The y component of the vector (optional).
    :return: A 2D vector object.
    ```python
    vector = Vector2(1, 1)
    print(vector)
    ```
    ```
    Output:
    [1, 1]
    ```
    """
    if y is None:
        return pygame.math.Vector2(x)
    else:
        return pygame.math.Vector2(x, y)

def Vector3(x, y, z):
    """
    Create a 3D vector.
    :param x: The x component of the vector.
    :param y: The y component of the vector.
    :param z: The z component of the vector.
    :return: A 3D vector object.
    ```lua
    vector = Vector3(1, 1, 1)
    print(vector)
    ```
    ```
    Output:
    [1, 1, 1]
    ```
    """
    return pygame.math.Vector3(x, y, z)

