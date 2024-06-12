-- Comprehensive Mouse Event Test Script in Lua with Pygame

-- Initialize constants
local SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
local TILE_SIZE = 20

-- Store the positions of the rectangles
local rectangles = {}
local current_position = {x = 0, y = 0}
local is_drawing = false

-- Draw function
local function draw_game(...)
    local args = {...}
    for i, arg in ipairs(args) do
        print("arg", i, ":", arg)
    end

    clear_canvas()

    -- Draw all rectangles
    for _, rect in ipairs(rectangles) do
        draw_rectangle(rect.x, rect.y, TILE_SIZE, TILE_SIZE, "#FF0000")
    end

    -- Draw current rectangle if drawing
    if is_drawing then
        draw_rectangle(current_position.x, current_position.y, TILE_SIZE, TILE_SIZE, "#00FF00")
    end

    flip_display()
end

-- Event handling for mouse clicks
local function on_mousebuttondown(event)
    local gx, gy = event.pos[1], event.pos[2]
    print("Mouse button down at:", gx, gy)
    current_position.x, current_position.y = gx - (gx % TILE_SIZE), gy - (gy % TILE_SIZE)
    is_drawing = true
end

local function on_mousebuttonup(event)
    local gx, gy = event.pos[1], event.pos[2]
    print("Mouse button up at:", gx, gy)
    if is_drawing then
        table.insert(rectangles, {x = current_position.x, y = current_position.y})
        is_drawing = false
    end
end

local function on_mousemotion(event)
    local gx, gy = event.pos[1], event.pos[2]
    print("Mouse moved to:", gx, gy)
    if is_drawing then
        current_position.x, current_position.y = gx - (gx % TILE_SIZE), gy - (gy % TILE_SIZE)
    end
end

-- Process events (e.g., window close)
local function process_events(...)
    local args = {...}
    for i, arg in ipairs(args) do
        print("arg", i, ":", arg)
    end

    for _, e in ipairs(get_events()) do
        if e.type == "QUIT" then
            stop_main_loop()
        end
    end
end

-- Register functions and start the loop
register_event_handler('on_mousebuttondown', on_mousebuttondown)
register_event_handler('on_mousebuttonup', on_mousebuttonup)
register_event_handler('on_mousemotion', on_mousemotion)
register_function("process_events", process_events)
register_function("draw", draw_game)
start_main_loop()