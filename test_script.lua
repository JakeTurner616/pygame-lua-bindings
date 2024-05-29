-- Game constants
local SCREEN_WIDTH, SCREEN_HEIGHT, TILE_SIZE = 800, 600, 20
-- Initialize game state
local snake, food, direction, score = {{x = 10, y = 10}}, {x = 15, y = 15}, {x = 1, y = 0}, 0
-- Draw functions
local function draw_game()
    clear_canvas()
    for _, s in ipairs(snake) do draw_rectangle(s.x * TILE_SIZE, s.y * TILE_SIZE, TILE_SIZE, TILE_SIZE, "#00FF00") end
    draw_rectangle(food.x * TILE_SIZE, food.y * TILE_SIZE, TILE_SIZE, TILE_SIZE, "#FF0000")
    draw_text(10, SCREEN_HEIGHT - 30, "Score: " .. score, "Arial", 20, "#FFFFFF")
    flip_display()
end
-- Event handling
register_event_handler('on_keydown', function(event)
    local key_map = {[1073741903]={1,0}, [1073741904]={-1,0}, [1073741906]={0,-1}, [1073741905]={0,1}}
    local dir = key_map[event.key]
    if dir and (dir[1] ~= -direction.x and dir[2] ~= -direction.y) then direction = {x = dir[1], y = dir[2]} end
end)
-- Game logic
function process_events()
    for _, e in ipairs(get_events()) do if e.type == "QUIT" then stop_main_loop() end end
end
function update_position()
    local head = {x = snake[1].x + direction.x, y = snake[1].y + direction.y}
    if head.x < 0 or head.x >= SCREEN_WIDTH / TILE_SIZE or head.y < 0 or head.y >= SCREEN_HEIGHT / TILE_SIZE or (#snake >= 4 and (function()
        for _, s in ipairs(snake) do if s.x == head.x and s.y == head.y then return true end end return false end)()) then stop_main_loop() end
    table.insert(snake, 1, head)
    if head.x == food.x and head.y == food.y then
        score = score + 1
        food = {x = math.random(0, SCREEN_WIDTH / TILE_SIZE - 1), y = math.random(0, SCREEN_HEIGHT / TILE_SIZE - 1)}
    else
        table.remove(snake)
    end
end
-- Register functions and start the loop
register_function("process_events", process_events)
register_function("update_position", update_position)
register_function("draw", draw_game)
start_main_loop()