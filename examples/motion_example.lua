-- Clear the screen and draw initial shapes
clear_canvas()

-- Initial positions
local circle_x, circle_y = 300, 300
local angle = math.rad(45) -- Initial angle in radians (45 degrees)
local speed = 7            -- Speed of movement

-- Function to update position (animation example)
local function update_position()
    -- Move circle
    circle_x = circle_x + math.cos(angle) * speed
    circle_y = circle_y + math.sin(angle) * speed

    -- Bounce off the edges
    local bounce_randomness = math.rad(math.random(-5, 5)) -- Smaller range for slight angle variation
    if circle_x <= 0 then
        angle = math.pi - angle                            -- Reflect horizontally on the left edge
        circle_x = 0                                       -- Reset position to within boundary
        angle = angle + bounce_randomness
    elseif circle_x >= 800 then
        angle = math.pi - angle -- Reflect horizontally on the right edge
        circle_x = 800          -- Reset position to within boundary
        angle = angle + bounce_randomness
    end

    if circle_y <= 0 then
        angle = -angle -- Reflect vertically on the top edge
        circle_y = 0   -- Reset position to within boundary
        angle = angle + bounce_randomness
    elseif circle_y >= 600 then
        angle = -angle -- Reflect vertically on the bottom edge
        circle_y = 600 -- Reset position to within boundary
        angle = angle + bounce_randomness
    end

    -- Ensure angle stays within 0 to 2*pi range
    if angle < 0 then
        angle = angle + 2 * math.pi
    elseif angle >= 2 * math.pi then
        angle = angle - 2 * math.pi
    end
end

-- Function to draw updated shapes
local function draw()
    clear_canvas()
    draw_circle(0x00FF00, { circle_x, circle_y }, 50)
    flip_display()
end

-- Register Lua functions to be called from Python
register_function("process_events", process_events)
register_function("update_position", update_position)
register_function("draw", draw)