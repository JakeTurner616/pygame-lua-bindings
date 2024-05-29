import pygame.version

def version():
    """Return the version of the Pygame library.
    
    ```lua
    pygame_version = version()
    print(pygame_version)
    ```
    Output:
    ```
    2.5.2
    ```
    """
    return pygame.version.ver

def get_sdl_version():
    """Return the version of the SDL library that Pygame uses.
    
    ```lua
    sdl_version = get_sdl_version()
    print(sdl_version)
    ```
    Output:
    ```
    2
    ```
    """
    return pygame.get_sdl_version()