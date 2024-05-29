
-- Clear the screen and draw some stuff
clear_canvas()
draw_text(50, 50, "Hello, Pygame!", "Arial", 30, 0x7C00)  -- Red text
local circle_x, circle_y = 300, 300
draw_circle(0x00FF00, {circle_x, circle_y}, 50)
draw_rectangle(100, 100, 150, 80, 0x001F)  -- Blue rectangle

-- Load and draw an image
local image = load_image("C:\\Users\\jaked\\Pictures\\image (13).png")
if image then
    draw_image(image, 100, 100)
end