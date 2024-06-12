-- Pac-Man game constants
local SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
local TILE_SIZE = 20
local GRID_WIDTH, GRID_HEIGHT = SCREEN_WIDTH / TILE_SIZE, SCREEN_HEIGHT / TILE_SIZE

local DIRECTION = {
    LEFT = {x = -1, y = 0},
    RIGHT = {x = 1, y = 0},
    UP = {x = 0, y = -1},
    DOWN = {x = 0, y = 1}
}

-- Pac-Man and ghost colors
local COLORS = {
    PACMAN = "#FFFF00",
    GHOST = "#FF0000",
    WALL = "#0000FF",
    PELLET = "#FFFFFF"
}

-- Initialize game state
local grid = {}
for y = 1, GRID_HEIGHT do
    grid[y] = {}
    for x = 1, GRID_WIDTH do
        if x == 1 or x == GRID_WIDTH or y == 1 or y == GRID_HEIGHT or (x % 2 == 0 and y % 2 == 0) then
            grid[y][x] = "WALL"
        else
            grid[y][x] = "PELLET"
        end
    end
end

local pacman = {x = 2, y = 2, direction = DIRECTION.RIGHT}
local ghosts = {
    {x = GRID_WIDTH - 2, y = 2, direction = DIRECTION.LEFT},
    {x = GRID_WIDTH - 2, y = GRID_HEIGHT - 2, direction = DIRECTION.UP},
    {x = 2, y = GRID_HEIGHT - 2, direction = DIRECTION.RIGHT}
}
local score = 0
local game_over = false

-- Draw function
local function draw_game()
    clear_canvas()

    -- Draw grid
    for y = 1, GRID_HEIGHT do
        for x = 1, GRID_WIDTH do
            if grid[y][x] == "WALL" then
                draw_rectangle((x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE, COLORS.WALL)
            elseif grid[y][x] == "PELLET" then
                draw_circle((x - 0.5) * TILE_SIZE, (y - 0.5) * TILE_SIZE, TILE_SIZE / 4, COLORS.PELLET)
            end
        end
    end

    -- Draw Pac-Man
    draw_circle((pacman.x - 0.5) * TILE_SIZE, (pacman.y - 0.5) * TILE_SIZE, TILE_SIZE / 2, COLORS.PACMAN)

    -- Draw ghosts
    for _, ghost in ipairs(ghosts) do
        draw_circle((ghost.x - 0.5) * TILE_SIZE, (ghost.y - 0.5) * TILE_SIZE, TILE_SIZE / 2, COLORS.GHOST)
    end

    -- Draw score
    draw_text(10, SCREEN_HEIGHT - 30, "Score: " .. score, "Arial", 20, "#FFFFFF")

    flip_display()
end

local function draw_game_over()
    clear_canvas()
    draw_text(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 50, "Game Over", "Arial", 40, "#FF0000")
    draw_text(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2, "Score: " .. score, "Arial", 30, "#FFFFFF")
    flip_display()
end

-- Event handling
register_event_handler('on_keydown', function(event)
    if game_over then return end
    if event.key == KEY_CONSTANTS.K_LEFT then
        pacman.direction = DIRECTION.LEFT
    elseif event.key == KEY_CONSTANTS.K_RIGHT then
        pacman.direction = DIRECTION.RIGHT
    elseif event.key == KEY_CONSTANTS.K_UP then
        pacman.direction = DIRECTION.UP
    elseif event.key == KEY_CONSTANTS.K_DOWN then
        pacman.direction = DIRECTION.DOWN
    end
end)

-- Move Pac-Man and ghosts
local function move_entity(entity)
    local new_x = entity.x + entity.direction.x
    local new_y = entity.y + entity.direction.y
    if grid[new_y][new_x] ~= "WALL" then
        entity.x = new_x
        entity.y = new_y
    end
end

local function update_pacman()
    move_entity(pacman)
    if grid[pacman.y][pacman.x] == "PELLET" then
        grid[pacman.y][pacman.x] = nil
        score = score + 10
    end
end

local function update_ghosts()
    for _, ghost in ipairs(ghosts) do
        local directions = {DIRECTION.LEFT, DIRECTION.RIGHT, DIRECTION.UP, DIRECTION.DOWN}
        ghost.direction = directions[math.random(#directions)]
        move_entity(ghost)
    end
end

local function check_collision()
    for _, ghost in ipairs(ghosts) do
        if ghost.x == pacman.x and ghost.y == pacman.y then
            game_over = true
        end
    end
end

-- Game logic
function process_events()
    pump_events()
    for _, e in ipairs(get_events()) do
        if e.type == "QUIT" then
            stop_main_loop()
        end
    end
end

local update_counter = 0
function update_position()
    if game_over then
        return
    end
    update_counter = update_counter + 1
    if update_counter >= 10 then
        update_pacman()
        update_ghosts()
        check_collision()
        update_counter = 0
    end
end

-- Register functions and start the loop
register_function("process_events", process_events)
register_function("update_position", update_position)
register_function("draw", function()
    if game_over then
        draw_game_over()
    else
        draw_game()
    end
end)
start_main_loop()