-- Description: A simple platformer game using pygame Lua bindings. meant to play similar to megaman.

-- Game constants
local SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
local PLAYER_SPEED = 5
local PLAYER_JUMP_SPEED = 15
local GRAVITY = 1
local BULLET_SPEED = 10
local ENEMY_SPEED = 2
local EXPLOSION_DURATION = 30
local SCROLL_SPEED = 2
local MAX_LEVELS = 10  -- Assuming you have 10 levels for simplicity

local current_scene = 0
local level_data
local deco_image

-- Load player sprites
local player_sprites = {}
local shooting_sprites = {}
local falling_sprite
local falling_shooting_sprite
local num_sprites = 0
local num_shooting_sprites = 0

local function file_exists(name)
    local f = io.open(name, "r")
    if f then f:close() end
    return f ~= nil
end

local function load_player_sprites()
    local i = 1
    while true do
        local sprite_path = "player_sprites/run" .. i .. ".png"
        if file_exists(sprite_path) then
            local sprite = load_image(sprite_path)
            table.insert(player_sprites, sprite)
            i = i + 1
        else
            break
        end
    end
    num_sprites = #player_sprites

    i = 1
    while true do
        local sprite_path = "player_sprites/shoot" .. i .. ".png"
        if file_exists(sprite_path) then
            local sprite = load_image(sprite_path)
            table.insert(shooting_sprites, sprite)
            i = i + 1
        else
            break
        end
    end
    num_shooting_sprites = #shooting_sprites

    local falling_sprite_path = "player_sprites/fall.png"
    if file_exists(falling_sprite_path) then
        falling_sprite = load_image(falling_sprite_path)
    end

    local falling_shooting_sprite_path = "player_sprites/fall_shoot.png"
    if file_exists(falling_shooting_sprite_path) then
        falling_shooting_sprite = load_image(falling_shooting_sprite_path)
    end
end

-- Function to load the level from a PNG file
local function load_level_from_image(image_path)
    local image_data = get_image_data(image_path)
    local width, height = image_data.width, image_data.height
    local pixels = image_data.pixels
    local level_data = {
        platforms = {},
        enemies = {},
        teleports = {},
        player_start = nil
    }

    for y = 1, height do
        for x = 1, width do
            local color = get_pixel_color(pixels, x - 1, y - 1)  -- Lua uses 1-based indexing
            if color.r == 0 and color.g == 0 and color.b == 0 then  -- Black
                table.insert(level_data.platforms, {x = (x - 1) * 10, y = (y - 1) * 10, width = 10, height = 10})
            elseif color.r == 255 and color.g == 0 and color.b == 0 then  -- Red
                table.insert(level_data.enemies, {x = (x - 1) * 10, y = (y - 1) * 10, width = 10, height = 10})
            elseif color.r == 0 and color.g == 0 and color.b == 255 then  -- Blue
                level_data.player_start = {x = (x - 1) * 10, y = (y - 1) * 10}
            elseif color.r == 0 and color.g == 255 and color.b == 0 then  -- Green
                table.insert(level_data.teleports, {x = (x - 1) * 10, y = (y - 1) * 10, width = 10, height = 10})
            end
        end
    end
    return level_data
end

-- Function to load the background decoration
local function load_deco_image(image_path)
    return load_image(image_path)
end

-- Function to load a level and its decoration
local function load_level(scene)
    level_data = load_level_from_image("level" .. scene .. ".png")
    deco_image = load_deco_image("level" .. scene .. "_deco.png")
end

-- Initialize game state for the first scene
load_level(current_scene)
load_player_sprites()

local player = {
    x = level_data.player_start.x,
    y = level_data.player_start.y,
    width = 50,
    height = 60,
    dx = 0,
    dy = 0,
    on_ground = true,
    current_frame = 1,
    frame_timer = 0,
    frame_interval = 0.1, -- Change frame every 0.1 seconds
    facing_left = true,  -- Track the direction the player is facing
    shooting = false,
    shooting_frame = 1,
    shooting_timer = 0,
    shooting_interval = 0.1
}

local keys = {left = false, right = false, space = false, up = false}
local bullets = {}
local enemies = level_data.enemies
local explosions = {}
local platforms = level_data.platforms
local teleports = level_data.teleports
local score_counter = 0
local game_over = false
local scroll_x = 0

-- Function to spawn explosions
local function spawn_explosion(x, y)
    table.insert(explosions, {x = x, y = y, duration = EXPLOSION_DURATION})
end

-- Function to load the next scene
local function load_next_scene()
    current_scene = current_scene + 1
    if current_scene < MAX_LEVELS then
        load_level(current_scene)
        player.x = level_data.player_start.x
        player.y = level_data.player_start.y
        enemies = level_data.enemies
        platforms = level_data.platforms
        teleports = level_data.teleports
        scroll_x = 0
    else
        game_over = true
    end
end

-- Draw function
local function draw_game()
    clear_canvas()

    -- Draw a bright pink background to check transparency
    draw_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "#ff00ff")

    -- Draw decoration background
    if deco_image then
        draw_image(deco_image, 0 - scroll_x, 0)
    end

    -- Draw ground and platforms
    for _, platform in ipairs(platforms) do
        draw_rectangle(platform.x - scroll_x, platform.y, platform.width, platform.height, 0x00FF00)
    end

    -- Draw player sprite
    local sprite
    if not player.on_ground then
        if player.shooting and falling_shooting_sprite then
            sprite = falling_shooting_sprite
        else
            sprite = falling_sprite
        end
    elseif player.shooting and num_shooting_sprites > 0 then
        sprite = shooting_sprites[player.shooting_frame]
    else
        sprite = player_sprites[player.current_frame]
    end

    if not player.facing_left then
        sprite = flip(sprite, true, false)
    end
    draw_image(sprite, player.x - scroll_x, player.y)

    -- Draw bullets as white rectangles
    for _, bullet in ipairs(bullets) do
        draw_rectangle(bullet.x - scroll_x, bullet.y, bullet.width, bullet.height, 0xFFFFFF)
    end

    -- Draw enemies as red rectangles
    for _, enemy in ipairs(enemies) do
        draw_rectangle(enemy.x - scroll_x, enemy.y, enemy.width, enemy.height, 0xFF0000)
    end

    -- Draw explosions as yellow circles
    for _, explosion in ipairs(explosions) do
        draw_circle(0xFFFF00, {explosion.x - scroll_x, explosion.y}, 20)
    end

    -- Draw score
    draw_text(10, 10, "Score: " .. score_counter, "Arial", 20, "#FFFFFF")

    -- Draw game over message if game is over
    if game_over then
        draw_text(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2, "GAME OVER", "Arial", 40, "#FF0000")
    end

    flip_display()
end

-- Event handling
register_event_handler('on_keydown', function(event)
    if event.key == K_LEFT then
        keys.left = true
    elseif event.key == K_RIGHT then
        keys.right = true
    elseif event.key == K_SPACE then
        keys.space = true
        player.shooting = true
        local bullet_x = player.facing_left and (player.x - 25) or (player.x + player.width + 25)
        local bullet_dx = player.facing_left and -BULLET_SPEED or BULLET_SPEED
        table.insert(bullets, {x = bullet_x, y = player.y + player.height / 2, width = 4, height = 10, dx = bullet_dx})
    elseif event.key == K_UP then
        keys.up = true
        if player.on_ground then
            player.dy = -PLAYER_JUMP_SPEED
            player.on_ground = false
        end
    elseif event.key == K_ESCAPE then
        stop_main_loop()
    end
end)

register_event_handler('on_keyup', function(event)
    if event.key == K_LEFT then
        keys.left = false
    elseif event.key == K_RIGHT then
        keys.right = false
    elseif event.key == K_SPACE then
        keys.space = false
        player.shooting = false
    elseif event.key == K_UP then
        keys.up = false
    end
end)

-- Game logic
function process_events()
    for _, e in ipairs(get_events()) do
        if e.type == "QUIT" then
            stop_main_loop()
        end
    end
end

function update_position()
    if game_over then return end

    -- Move player
    player.dx = 0
    if keys.left then
        player.dx = -PLAYER_SPEED
        player.facing_left = true
    elseif keys.right then
        player.dx = PLAYER_SPEED
        player.facing_left = false
    end

    -- Apply gravity
    player.dy = player.dy + GRAVITY
    player.x = player.x + player.dx
    player.y = player.y + player.dy

    -- Collision with platforms
    player.on_ground = false
    for _, platform in ipairs(platforms) do
        if player.x + player.width > platform.x and player.x < platform.x + platform.width then
            if player.y + player.height > platform.y and player.y + player.height - player.dy <= platform.y then
                player.y = platform.y - player.height
                player.dy = 0
                player.on_ground = true
            end
        end
    end

    -- Check for teleport
    for _, teleport in ipairs(teleports) do
        if player.x < teleport.x + teleport.width and player.x + player.width > teleport.x and
           player.y + player.height > teleport.y and player.y < teleport.y + teleport.height then
            load_next_scene()
        end
    end

    -- Update bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.x = bullet.x + bullet.dx
        if bullet.x > scroll_x + SCREEN_WIDTH or bullet.x < scroll_x then
            table.remove(bullets, i)
        end
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.x = enemy.x - ENEMY_SPEED
        if enemy.x + enemy.width < scroll_x then
            table.remove(enemies, i)
        end
        -- Collision with player
        if player.x < enemy.x + enemy.width and player.x + player.width > enemy.x and
           player.y < enemy.y + enemy.height and player.y + player.height > enemy.y then
            game_over = true
        end
    end

    -- Update explosions
    for i = #explosions, 1, -1 do
        local explosion = explosions[i]
        explosion.duration = explosion.duration - 1
        if explosion.duration <= 0 then
            table.remove(explosions, i)
        end
    end

    -- Check for collisions
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if bullet.x < enemy.x + enemy.width and bullet.x + bullet.width > enemy.x and
               bullet.y < enemy.y + enemy.height and bullet.y + bullet.height > enemy.y then
                table.remove(bullets, i)
                spawn_explosion(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2)
                table.remove(enemies, j)
                score_counter = score_counter + 1
                break
            end
        end
    end

    -- Prevent player from falling below the screen
    if player.y > SCREEN_HEIGHT then
        game_over = true
    end

    -- Update player animation
    if keys.left or keys.right then
        player.frame_timer = player.frame_timer + 1/60  -- Assuming 60 FPS
        if player.frame_timer >= player.frame_interval then
            player.frame_timer = 0
            player.current_frame = (player.current_frame % num_sprites) + 1
        end
    else
        player.current_frame = 1  -- Reset to the first frame when not moving
    end

    -- Update shooting animation
    if player.shooting and num_shooting_sprites > 0 then
        player.shooting_timer = player.shooting_timer + 1/60  -- Assuming 60 FPS
        if player.shooting_timer >= player.shooting_interval then
            player.shooting_timer = 0
            player.shooting_frame = (player.shooting_frame % num_shooting_sprites) + 1
        end
    end
end

-- Register functions and start the loop
register_function("process_events", process_events)
register_function("update_position", update_position)
register_function("draw", draw_game)
start_main_loop()
