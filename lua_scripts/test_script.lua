--[[---------------------------------------------
Tetris Game Implementation in Lua with Pygame

This script implements a simple version of the classic Tetris game using lua with
Pygame for graphics and event handling. The game includes surface level core mechanics such as piece movement,
rotation, line clearing, and score tracking.
-----------------------------------------------]]--

-- Game constants
local SCREEN_WIDTH, SCREEN_HEIGHT, TILE_SIZE = 300, 600, 30
local GRID_WIDTH, GRID_HEIGHT = SCREEN_WIDTH / TILE_SIZE, SCREEN_HEIGHT / TILE_SIZE

local SHAPES = {
    {{0,1,0},{1,1,1}},  -- T shape
    {{1,1,0},{0,1,1}},  -- S shape
    {{0,1,1},{1,1,0}},  -- Z shape
    {{1,1,1,1}},        -- I shape
    {{1,1,1},{1,0,0}},  -- L shape
    {{1,1,1},{0,0,1}},  -- J shape
    {{1,1},{1,1}},      -- O shape
}

local COLORS = {
    "#800080",  -- Purple (T piece)
    "#00FF00",  -- Green (S piece)
    "#FF0000",  -- Red (Z piece)
    "#00FFFF",  -- Cyan (I piece)
    "#FFA500",  -- Orange (L piece)
    "#0000FF",  -- Blue (J piece)
    "#FFFF00"   -- Yellow (O piece)
}

-- Initialize game state
local grid = {}
for y = 1, GRID_HEIGHT do
    grid[y] = {}
    for x = 1, GRID_WIDTH do
        grid[y][x] = 0
    end
end

local double_bag = {}

local function refill_double_bag()
    double_bag = {}
    for i = 1, 2 do
        for j = 1, #SHAPES do
            table.insert(double_bag, {shape = SHAPES[j], color = COLORS[j]})
        end
    end
    -- Shuffle the double bag
    for i = #double_bag, 2, -1 do
        local j = math.random(1, i)
        double_bag[i], double_bag[j] = double_bag[j], double_bag[i]
    end
end

local function get_next_piece()
    if #double_bag == 0 then
        refill_double_bag()
    end
    return table.remove(double_bag)
end

local function collides(piece, offsetX, offsetY)
    for y = 1, #piece.shape do
        for x = 1, #piece.shape[y] do
            if piece.shape[y][x] ~= 0 then
                local newX = piece.x + x - 1 + offsetX
                local newY = piece.y + y - 1 + offsetY
                if newX < 0 or newX >= GRID_WIDTH or newY >= GRID_HEIGHT or (newY >= 0 and grid[newY + 1][newX + 1] ~= 0) then
                    return true
                end
            end
        end
    end
    return false
end

local current_piece = get_next_piece()
current_piece.x = math.floor(GRID_WIDTH / 2) - 1
current_piece.y = 0

local next_piece = get_next_piece()
next_piece.x = math.floor(GRID_WIDTH / 2) - 1
next_piece.y = 0

local game_speed = 3
local speed_timer = 0
local score = 0
local speed_drop = false

local function draw_grid()
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do
            if grid[y][x] ~= 0 then
                draw_rectangle((x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE, grid[y][x])
            end
        end
    end
end

local function draw_piece(piece, offsetX, offsetY, color)
    for y = 1, #piece.shape do
        for x = 1, #piece.shape[y] do
            if piece.shape[y][x] ~= 0 then
                draw_rectangle((piece.x + x - 1 + (offsetX or 0)) * TILE_SIZE, (piece.y + y - 1 + (offsetY or 0)) * TILE_SIZE, TILE_SIZE, TILE_SIZE, color or piece.color)
            end
        end
    end
end

local function get_ghost_piece(piece)
    local ghost_piece = {shape = piece.shape, color = "#CCCCCC", x = piece.x, y = piece.y}
    while not collides(ghost_piece, 0, 1) do
        ghost_piece.y = ghost_piece.y + 1
    end
    return ghost_piece
end

local function draw_game()
    clear_canvas()
    draw_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "#FFFFFF", 1)  -- Outline the game area
    draw_grid()
    local ghost_piece = get_ghost_piece(current_piece)
    draw_piece(ghost_piece)
    draw_piece(current_piece)
    draw_text(10, 10, "Next piece:", "Arial", 20, "#FFFFFF")
    draw_piece(next_piece, GRID_WIDTH + 1, 2)
    draw_text(10, 50, "Score: " .. score, "Arial", 20, "#FFFFFF")
    flip_display()
end

local function merge_piece(piece)
    for y = 1, #piece.shape do
        for x = 1, #piece.shape[y] do
            if piece.shape[y][x] ~= 0 then
                grid[piece.y + y][piece.x + x] = piece.color
            end
        end
    end
end

local function clear_lines()
    local lines_cleared = 0
    for y = GRID_HEIGHT, 1, -1 do
        local full_line = true
        for x = 1, GRID_WIDTH do
            if grid[y][x] == 0 then
                full_line = false
                break
            end
        end
        if full_line then
            lines_cleared = lines_cleared + 1
            for clearY = y, 2, -1 do
                for x = 1, GRID_WIDTH do
                    grid[clearY][x] = grid[clearY - 1][x]
                end
            end
            for x = 1, GRID_WIDTH do
                grid[1][x] = 0
            end
            y = y + 1  -- Check the same line again
        end
    end
    if lines_cleared > 0 then
        score = score + (lines_cleared * 100)
    end
end

local function rotate_piece(piece)
    local new_shape = {}
    for x = 1, #piece.shape[1] do
        new_shape[x] = {}
        for y = #piece.shape, 1, -1 do
            new_shape[x][#piece.shape - y + 1] = piece.shape[y][x]
        end
    end
    return new_shape
end

local function update_game()
    speed_timer = speed_timer + 1
    if speed_timer >= 30 / game_speed or speed_drop then
        speed_timer = 0
        speed_drop = false
        if collides(current_piece, 0, 1) then
            merge_piece(current_piece)
            clear_lines()
            current_piece = next_piece
            next_piece = get_next_piece()
            current_piece.x = math.floor(GRID_WIDTH / 2) - 1
            current_piece.y = 0
            next_piece.x = math.floor(GRID_WIDTH / 2) - 1
            next_piece.y = 0
            if collides(current_piece, 0, 0) then
                stop_main_loop()
            end
        else
            current_piece.y = current_piece.y + 1
        end
    end
end

local function move_piece(dx)
    if not collides(current_piece, dx, 0) then
        current_piece.x = current_piece.x + dx
    end
end

local function rotate_current_piece()
    local rotated = {shape = rotate_piece(current_piece), color = current_piece.color, x = current_piece.x, y = current_piece.y}
    if not collides(rotated, 0, 0) then
        current_piece.shape = rotated.shape
    end
end

register_event_handler('on_keydown', function(event)
    if event.key == K_LEFT then
        move_piece(-1)
    elseif event.key == K_RIGHT then
        move_piece(1)
    elseif event.key == K_SPACE then
        rotate_current_piece()
    elseif event.key == K_DOWN then
        speed_drop = true
    elseif event.key == K_PLUS or event.key == K_EQUALS then
        game_speed = game_speed + 1
    elseif event.key == K_MINUS then
        game_speed = math.max(1, game_speed - 1)
    end
end)

register_function("process_events", function() end)
register_function("update_position", update_game)
register_function("draw", draw_game)
start_main_loop()