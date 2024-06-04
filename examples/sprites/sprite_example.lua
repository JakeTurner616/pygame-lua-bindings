-- Set the display mode
local screen = set_display_mode_lua(800, 600)
print("typeof screen: " .. type(screen))

-- Create a new sprite
local my_sprite = Sprite()
my_sprite:set_rect(50, 50, 50, 50)  -- Set the position and size of the sprite
my_sprite:set_image(50, 50, {255, 0, 0})  -- Set the image to a 50x50 red square

-- Create a sprite group and add the sprite to it
local my_group = Group()
my_group:add(my_sprite)

-- Define a function to update the sprite position
function update_position()
    local rect = my_sprite:get_rect()
    rect.x = rect.x + 1  -- Move the sprite to the right
    if rect.x > 800 then  -- Reset position if it goes off-screen
        rect.x = 0
    end
    my_sprite:set_rect(rect.x, rect.y, rect.width, rect.height)
end

-- Define a function to draw the sprite group
function draw()
    clear_canvas()  -- Clear the canvas before drawing
    my_group:draw(screen)
end

-- Register the update and draw functions
register_function("update_position", update_position)
register_function("draw", draw)