local screen = set_display_mode_lua(800, 600)

-- Create a surface and draw something on it
local surface = create_surface(200, 200)
surface_fill(surface, {255, 0, 0})  -- Fill with red

-- Draw a green rectangle on the red surface
surface_fill(surface, {0, 255, 0}, {50, 50, 100, 100})

-- Create another surface and fill it with blue
local screen_surface = create_surface(800, 600)
surface_fill(screen_surface, {0, 0, 255})  -- Fill with blue to visualize

-- Blit the red surface (with green rectangle) onto the blue screen surface
surface_blit(screen_surface, surface, 300, 200)  -- Blit red surface onto blue

-- Blit the screen surface onto the main screen
surface_blit(screen, screen_surface, 0, 0)

-- Display the result
flip_display()