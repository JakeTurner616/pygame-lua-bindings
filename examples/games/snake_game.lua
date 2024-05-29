-- Game constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local TILE_SIZE = 20

-- Initialize game state
local snake = {
    {x = 10, y = 10},
}
local food = {x = 15, y = 15}
local direction = {x = 1, y = 0} -- Initial direction: right
local score = 0

-- Function to draw a tile
local function draw_tile(x, y, color)
    draw_rectangle(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE, color)
end

-- Function to draw the game
local function draw_game()
    clear_canvas()
    -- Draw snake
    for _, segment in ipairs(snake) do
        draw_tile(segment.x, segment.y, "#00FF00")
    end
    -- Draw food
    draw_tile(food.x, food.y, "#FF0000")
    -- Draw score
    draw_text(10, SCREEN_HEIGHT - 30, "Score: " .. score, "Arial", 20, "#FFFFFF")
    flip_display()
end

-- Function to handle events
function process_events()
    local events = get_events()
    for _, event in ipairs(events) do
        if event.type == "QUIT" then
            stop_main_loop()
        end
    end
end

-- Function to update the snake's position
function update_position()
    local head = {x = snake[1].x + direction.x, y = snake[1].y + direction.y}
    -- Check for collision with the walls
    if head.x < 0 or head.x >= SCREEN_WIDTH / TILE_SIZE or head.y < 0 or head.y >= SCREEN_HEIGHT / TILE_SIZE then
        stop_main_loop()
    end
    -- Check for collision with itself
    for _, segment in ipairs(snake) do
        if segment.x == head.x and segment.y == head.y then
            stop_main_loop()
        end
    end
    table.insert(snake, 1, head)
    -- Check if food is eaten
    if head.x == food.x and head.y == food.y then
        score = score + 1
        food.x = math.random(0, (SCREEN_WIDTH / TILE_SIZE) - 1)
        food.y = math.random(0, (SCREEN_HEIGHT / TILE_SIZE) - 1)
    else
        table.remove(snake)
    end
end

-- Function to draw the game state
function draw()
    draw_game()
end

-- Register event handler for key down events to control the snake
register_event_handler('on_keydown', function(event)
    if event.key == 1073741903 and direction.x ~= -1 then  -- RIGHT key
        direction = {x = 1, y = 0}
    elseif event.key == 1073741904 and direction.x ~= 1 then  -- LEFT key
        direction = {x = -1, y = 0}
    elseif event.key == 1073741906 and direction.y ~= -1 then  -- UP key
        direction = {x = 0, y = -1}
    elseif event.key == 1073741905 and direction.y ~= 1 then  -- DOWN key
        direction = {x = 0, y = 1}
    end
end)

-- Register the Lua functions
register_function("process_events", process_events)
register_function("update_position", update_position)
register_function("draw", draw)

-- Start the main loop
start_main_loop()