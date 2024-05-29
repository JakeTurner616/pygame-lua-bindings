import pygame
import sys
from math import pi, sin, cos, tan, asin, acos, atan, atan2, exp, log, log10, pow, sqrt, ceil, floor, fabs

def initialize_pygame():
    try:
        pygame.display.init()
        pygame.font.init()
    except Exception as e:
        print(f"Error initializing Pygame: {e}")
        sys.exit(1)

def delay(milliseconds):
    """Delay execution for a given number of milliseconds."""
    print(f"Delaying execution for {milliseconds} milliseconds")
    pygame.time.delay(milliseconds)

def sleep(seconds):
    """Delay execution for a given number of seconds."""
    print(f"Sleeping for {seconds} seconds")
    sleep(seconds)

# Math functions that are exposed to Lua from Python, most of these can also be found in the lua math library too but are here for convenience. allows quick prototyping of trigonometry!

def get_pi():
    """Return the value of pi."""
    return pi

def get_sin(x):
    """Return the sine of x (measured in radians)."""
    return sin(x)

def get_cos(x):
    """Return the cosine of x (measured in radians)."""
    return cos(x)

def get_tan(x):
    """Return the tangent of x (measured in radians)."""
    return tan(x)

def get_asin(x):
    """Return the arc sine of x, in radians."""
    return asin(x)

def get_acos(x):
    """Return the arc cosine of x, in radians."""
    return acos(x)

def get_atan(x):
    """Return the arc tangent of x, in radians."""
    return atan(x)

def get_atan2(y, x):
    """Return atan(y / x), in radians. The result is between -pi and pi."""
    return atan2(y, x)

def get_exp(x):
    """Return e raised to the power of x."""
    return exp(x)

def get_log(x, base=None):
    """Return the logarithm of x to the given base.
    If the base is not specified, returns the natural logarithm (base e) of x.
    """
    if base is None:
        return log(x)
    else:
        return log(x, base)

def get_log10(x):
    """Return the base-10 logarithm of x."""
    return log10(x)

def get_pow(x, y):
    """Return x raised to the power of y."""
    return pow(x, y)

def get_sqrt(x):
    """Return the square root of x."""
    return sqrt(x)

def get_ceil(x):
    """Return the ceiling of x as an Integral."""
    return ceil(x)

def get_floor(x):
    """Return the floor of x as an Integral."""
    return floor(x)

def get_fabs(x):
    """Return the absolute value of x."""
    return fabs(x)