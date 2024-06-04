-- Description: A simple platformer game using Pygame Lua bindings, inspired by Megaman.

-- Game constants
local SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
local PLAYER_SPEED = 5
local PLAYER_JUMP_SPEED = 15
local GRAVITY = 1
local BULLET_SPEED = 10
local ENEMY_SPEED = 2
local EXPLOSION_DURATION = 30
local MAX_LEVELS = 10

local TURRET_SHOOT_INTERVAL = 2
local TURRET_BULLET_SPEED = 5

local current_scene = 0
local level_data
local deco_image
local debug_mode = false -- Debug mode flag to show hitboxes

-- Turret shooting directions
local TURRET_DIRECTIONS = {
    { dx = -1, dy = 0 }, -- left
    { dx = 1,  dy = 0 }, -- right
    { dx = 0,  dy = -1 }, -- up
    { dx = 0,  dy = 1 } -- down
}

-- key: left 1, right 0, up 2, down 3 directions respectively
-- for each turret in the level we will have a direction that we want it to shoot
local turret_directions_list = { 0, 0, 2 }

-- Player health variables
local PLAYER_MAX_HEALTH = 100
local PLAYER_DAMAGE_COOLDOWN = 0.5 -- Damage cooldown in seconds
local player_damage_cooldown = 0 -- Timer to track damage cooldown

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
        local sprite_path = "examples/games/data/megaman/player_sprites/run" .. i .. ".png"
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
        local sprite_path = "examples/games/data/megaman/player_sprites/shoot" .. i .. ".png"
        if file_exists(sprite_path) then
            local sprite = load_image(sprite_path)
            table.insert(shooting_sprites, sprite)
            i = i + 1
        else
            break
        end
    end
    num_shooting_sprites = #shooting_sprites

    local falling_sprite_path = "examples/games/data/megaman/player_sprites/fall.png"
    if file_exists(falling_sprite_path) then
        falling_sprite = load_image(falling_sprite_path)
    end

    local falling_shooting_sprite_path = "examples/games/data/megaman/player_sprites/fall_shoot.png"
    if file_exists(falling_shooting_sprite_path) then
        falling_shooting_sprite = load_image(falling_shooting_sprite_path)
    end
end

-- Function to load the hitbox from an image
local function load_hitbox_pixels(image_path)
    local hitbox_pixels = {}
    local image_data = get_image_data(image_path)
    local width, height = image_data.width, image_data.height
    local pixels = image_data.pixels

    for y = 1, height do
        for x = 1, width do
            local color = get_pixel_color(pixels, x - 1, y - 1)      -- Lua uses 1-based indexing
            if color.r == 255 and color.g == 0 and color.b == 0 then -- Red
                table.insert(hitbox_pixels, { x = x - 1, y = y - 1 })
            end
        end
    end

    return hitbox_pixels
end

-- Load hitboxes
local running_hitbox_pixels = load_hitbox_pixels("examples/games/data/megaman/player_sprites/player_running_hitbox.png")
local falling_hitbox_pixels = load_hitbox_pixels("examples/games/data/megaman/player_sprites/player_falling_hitbox.png")
local met_hitbox_pixels_moving = load_hitbox_pixels("examples/games/data/megaman/player_sprites/met_hitbox_moving.png")
local met_hitbox_pixels_hiding = load_hitbox_pixels("examples/games/data/megaman/player_sprites/met_hitbox_hiding.png")

-- Function to load the Met enemy sprites
local met_sprites = {}
local num_met_sprites = 7

local function load_met_sprites()
    for i = 0, num_met_sprites - 1 do
        local sprite_path = "examples/games/data/megaman/player_sprites/enemy_met_" .. i .. ".png"
        if file_exists(sprite_path) then
            local sprite = load_image(sprite_path)
            table.insert(met_sprites, sprite)
        end
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
        turrets = {},
        teleports = {},
        player_start = nil,
        width = width * 10, -- assuming each pixel represents a 10x10 block
        height = height * 10
    }

    local turret_index = 1

    for y = 1, height do
        for x = 1, width do
            local color = get_pixel_color(pixels, x - 1, y - 1)          -- Lua uses 1-based indexing
            if color.r == 0 and color.g == 0 and color.b == 0 then       -- Black
                table.insert(level_data.platforms, { x = (x - 1) * 10, y = (y - 1) * 10, width = 10, height = 10 })
            elseif color.r == 255 and color.g == 0 and color.b == 0 then -- Red
                table.insert(level_data.enemies, {
                    x = (x - 1) * 10,
                    y = (y - 1) * 10,
                    width = 32,
                    height = 34,
                    type = "met",
                    current_frame = 1,
                    frame_timer = 0,
                    frame_interval = 0.1,
                    hiding = false,
                    hiding_timer = 0,
                    hitbox_pixels_moving = met_hitbox_pixels_moving,
                    hitbox_pixels_hiding = met_hitbox_pixels_hiding,
                    hitbox_pixels = met_hitbox_pixels_moving                -- Initialize with moving hitbox
                })
            elseif color.r == 0 and color.g == 0 and color.b == 255 then    -- Blue
                level_data.player_start = { x = (x - 1) * 10, y = (y - 1) * 10 }
            elseif color.r == 0 and color.g == 255 and color.b == 0 then    -- Green
                table.insert(level_data.teleports, { x = (x - 1) * 10, y = (y - 1) * 10, width = 10, height = 10 })
            elseif color.r == 255 and color.g == 255 and color.b == 0 then  -- Yellow
                local direction = turret_directions_list[turret_index] or 0 -- Default to left if out of bounds
                table.insert(level_data.turrets,
                    { x = (x - 1) * 10, y = (y - 1) * 10, width = 10, height = 10, shoot_timer = 0, direction = direction })
                turret_index = turret_index + 1
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
    level_data = load_level_from_image("examples/games/data/megaman/levels/level" .. scene .. ".png")
    deco_image = load_deco_image("examples/games/data/megaman/levels/level" .. scene .. "_deco.png")
end

-- Initialize game state for the first scene
load_level(current_scene)
load_player_sprites()
load_met_sprites()

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
    facing_left = true,   -- Track the direction the player is facing
    shooting = false,
    shooting_frame = 1,
    shooting_timer = 0,
    shooting_interval = 0.1,
    hitbox_pixels = running_hitbox_pixels, -- Initialize with running hitbox
    health = PLAYER_MAX_HEALTH -- Add health to player structure
}

local keys = { left = false, right = false, space = false, up = false }
local bullets = {}
local enemies = level_data.enemies
local turrets = level_data.turrets
local explosions = {}
local platforms = level_data.platforms
local teleports = level_data.teleports
local score_counter = 0
local game_over = false
local scroll_x = 0
local turret_bullets = {}

-- Function to draw the health bar
local function draw_health_bar()
    local bar_width = 200
    local bar_height = 20
    local health_ratio = player.health / PLAYER_MAX_HEALTH
    local health_bar_width = bar_width * health_ratio

    draw_rectangle(10, 10, bar_width, bar_height, "#000000") -- Draw black background
    draw_rectangle(10, 10, health_bar_width, bar_height, "#FF0000") -- Draw red health bar
end

-- Function to apply damage and knockback to the player
local function apply_damage(damage, knockback_direction)
    if player_damage_cooldown <= 0 then
        player.health = player.health - damage
        if player.health <= 0 then
            game_over = true
        else
            -- Apply horizontal knockback force
            player.dx = knockback_direction
            
            -- Apply vertical knockback force
            player.dy = -PLAYER_JUMP_SPEED * 0.5 -- Adjust this multiplier for vertical knockback if needed
            
            -- Set damage cooldown
            player_damage_cooldown = PLAYER_DAMAGE_COOLDOWN
        end
    end
end

-- Function to spawn explosions
local function spawn_explosion(x, y)
    table.insert(explosions, { x = x, y = y, duration = EXPLOSION_DURATION })
end

-- Function to load the next scene
local function load_next_scene()
    current_scene = current_scene + 1
    if current_scene < MAX_LEVELS then
        load_level(current_scene)
        player.x = level_data.player_start.x
        player.y = level_data.player_start.y
        enemies = level_data.enemies
        turrets = level_data.turrets
        platforms = level_data.platforms
        teleports = level_data.teleports
        scroll_x = 0
    else
        game_over = true
    end
end

-- Function to spawn turret bullets in a cone pattern
local function spawn_turret_bullets(turret, bullet_width, bullet_height)
    local direction = TURRET_DIRECTIONS[turret.direction + 1] -- +1 because Lua arrays are 1-based
    local spread_angle = math.pi / 8
    local base_angle

    if direction.dx == -1 and direction.dy == 0 then
        base_angle = math.pi      -- left
    elseif direction.dx == 1 and direction.dy == 0 then
        base_angle = 0            -- right
    elseif direction.dx == 0 and direction.dy == -1 then
        base_angle = -math.pi / 2 -- up
    elseif direction.dx == 0 and direction.dy == 1 then
        base_angle = math.pi / 2  -- down
    end

    for i = -1, 1 do
        local angle = base_angle + spread_angle * i
        local dx = TURRET_BULLET_SPEED * math.cos(angle)
        local dy = TURRET_BULLET_SPEED * math.sin(angle)
        table.insert(turret_bullets,
            { x = turret.x + turret.width / 2, y = turret.y + turret.height / 2, dx = dx, dy = dy, width = bullet_width, height =
            bullet_height })
    end
end

-- Function to flip hitbox pixels
local function flip_hitbox_pixels(hitbox_pixels, width)
    local flipped_hitbox_pixels = {}
    for _, pixel in ipairs(hitbox_pixels) do
        table.insert(flipped_hitbox_pixels, { x = width - pixel.x - 1, y = pixel.y })
    end
    return flipped_hitbox_pixels
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
        if platform.x - scroll_x + platform.width > 0 and platform.x - scroll_x < SCREEN_WIDTH then
            draw_rectangle(platform.x - scroll_x, platform.y, platform.width, platform.height, 0x00FF00)
        end
    end

    -- Draw player sprite
    local sprite
    if not player.on_ground then
        if player.shooting and falling_shooting_sprite then
            sprite = falling_shooting_sprite
        else
            sprite = falling_sprite
        end
        player.hitbox_pixels = falling_hitbox_pixels
    else
        if player.shooting and num_shooting_sprites > 0 then
            sprite = shooting_sprites[player.shooting_frame]
        else
            sprite = player_sprites[player.current_frame]
        end
        player.hitbox_pixels = running_hitbox_pixels
    end

    if not player.facing_left then
        sprite = flip(sprite, true, false)
        player.hitbox_pixels = flip_hitbox_pixels(player.hitbox_pixels, player.width)
    end
    draw_image(sprite, player.x - scroll_x, player.y)

    -- Draw player hitbox if debug mode is enabled
    if debug_mode then
        for _, pixel in ipairs(player.hitbox_pixels) do
            draw_rectangle(player.x + pixel.x - scroll_x, player.y + pixel.y, 1, 1, "#FF0000")
        end
    end

    -- Draw bullets as white rectangles
    for _, bullet in ipairs(bullets) do
        if bullet.x - scroll_x + bullet.width > 0 and bullet.x - scroll_x < SCREEN_WIDTH then
            draw_rectangle(bullet.x - scroll_x, bullet.y, bullet.width, bullet.height, 0xFFFFFF)
        end
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        if enemy.type == "met" then
            if enemy.x - scroll_x + enemy.width > 0 and enemy.x - scroll_x < SCREEN_WIDTH then
                draw_image(met_sprites[enemy.current_frame], enemy.x - scroll_x, enemy.y - 4) -- Offset the Met sprite by 4 pixels to align with the ground
            end
        else
            if enemy.x - scroll_x + enemy.width > 0 and enemy.x - scroll_x < SCREEN_WIDTH then
                draw_rectangle(enemy.x - scroll_x, enemy.y, enemy.width, enemy.height, 0xFF0000)
            end
        end
    end

    -- Draw turrets as yellow rectangles
    for _, turret in ipairs(turrets) do
        if turret.x - scroll_x + turret.width > 0 and turret.x - scroll_x < SCREEN_WIDTH then
            draw_rectangle(turret.x - scroll_x, turret.y, turret.width, turret.height, 0xFFFF00)
        end
    end

    -- Draw turret bullets as orange rectangles
    for _, bullet in ipairs(turret_bullets) do
        if bullet.x - scroll_x + bullet.width > 0 and bullet.x - scroll_x < SCREEN_WIDTH then
            draw_rectangle(bullet.x - scroll_x, bullet.y, bullet.width, bullet.height, 0xFFA500)
        end
    end

    -- Draw explosions as yellow circles
    for _, explosion in ipairs(explosions) do
        if explosion.x - scroll_x + 20 > 0 and explosion.x - scroll_x - 20 < SCREEN_WIDTH then
            draw_circle(0xFFFF00, { explosion.x - scroll_x, explosion.y }, 20)
        end
    end

    -- Draw score
    draw_text(10, 40, "Score: " .. score_counter, "Arial", 20, "#FFFFFF")

    -- Draw health bar
    draw_health_bar()

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
        local bullet_x = player.facing_left and (player.x - .5) or
        (player.x + player.width + .5)                                                            -- Offset bullet to the side of the X-buster
        local bullet_dx = player.facing_left and -BULLET_SPEED or BULLET_SPEED
        table.insert(bullets, { x = bullet_x, y = player.y + player.height / 2, width = 4, height = 10, dx = bullet_dx })
    elseif event.key == K_UP then
        keys.up = true
        if player.on_ground then
            player.dy = -PLAYER_JUMP_SPEED
            player.on_ground = false
        end
    elseif event.key == K_d then
        debug_mode = not debug_mode -- Toggle debug mode
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

-- Check collision between two rectangles
local function check_collision(a, b)
    return a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y
end

-- Check collision between player's hitbox pixels and another rectangle
local function check_player_hitbox_collision(player, b)
    for _, pixel in ipairs(player.hitbox_pixels) do
        local px, py = player.x + pixel.x, player.y + pixel.y
        if px < b.x + b.width and
            px + 1 > b.x and
            py < b.y + b.height and
            py + 1 > b.y then
            return true
        end
    end
    return false
end

-- Check collision between enemy hitbox pixels and another rectangle
local function check_enemy_hitbox_collision(enemy, b)
    for _, pixel in ipairs(enemy.hitbox_pixels) do
        local px, py = enemy.x + pixel.x, enemy.y + pixel.y
        if px < b.x + b.width and
            px + 1 > b.x and
            py < b.y + b.height and
            py + 1 > b.y then
            return true
        end
    end
    return false
end

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

    -- First, handle horizontal movement and collision
    local new_x = player.x + player.dx
    player.on_ground = false

    for _, platform in ipairs(platforms) do
        -- Check horizontal collision
        if player.y + player.height > platform.y and player.y < platform.y + platform.height then
            if player.dx > 0 and player.x + player.width <= platform.x and new_x + player.width > platform.x then
                new_x = platform.x - player.width
            elseif player.dx < 0 and player.x >= platform.x + platform.width and new_x < platform.x + platform.width then
                new_x = platform.x + platform.width
            end
        end
    end

    player.x = new_x

    -- Then, handle vertical movement and collision
    local new_y = player.y + player.dy

    for _, platform in ipairs(platforms) do
        -- Check vertical collision
        if player.x + player.width > platform.x and player.x < platform.x + platform.width then
            if player.dy > 0 and player.y + player.height <= platform.y and new_y + player.height > platform.y then
                new_y = platform.y - player.height
                player.dy = 0
                player.on_ground = true
            elseif player.dy < 0 and player.y >= platform.y + platform.height and new_y < platform.y + platform.height then
                new_y = platform.y + platform.height
                player.dy = 0
            end
        end
    end

    player.y = new_y

    -- Check for teleport
    for _, teleport in ipairs(teleports) do
        if check_collision(player, teleport) then
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
        -- make the player take damage if they hit the bullet
        if check_player_hitbox_collision(player, bullet) then
            apply_damage(25, player.facing_left and 1 or -1) -- Apply 25 damage and knockback
            table.remove(bullets, i) -- Remove the bullet after collision
        end
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        if enemy.type == "met" then
            enemy.frame_timer = enemy.frame_timer + 1 / 60 -- Assuming 60 FPS
            if enemy.hiding then
                enemy.hiding_timer = enemy.hiding_timer + 1 / 60
                enemy.hitbox_pixels = enemy.hitbox_pixels_hiding -- Use hiding hitbox
                if enemy.hiding_timer >= 1 then                  -- Stay hidden for 1 second
                    enemy.hiding = false
                    enemy.hiding_timer = 0
                    enemy.current_frame = 1                          -- Reset to the first frame when coming out of hiding
                    enemy.hitbox_pixels = enemy.hitbox_pixels_moving -- Switch to moving hitbox
                end
            else
                enemy.x = enemy.x - ENEMY_SPEED
                if enemy.frame_timer >= enemy.frame_interval then
                    enemy.frame_timer = 0
                    enemy.current_frame = enemy.current_frame + 1
                    if enemy.current_frame >= num_met_sprites then
                        enemy.hiding = true
                        enemy.current_frame = 7                          -- Freeze on frame 7 when hiding
                        enemy.hitbox_pixels = enemy.hitbox_pixels_hiding -- Switch to hiding hitbox
                    end
                end
            end
            -- Collision with player using hitbox
            if check_player_hitbox_collision(player, enemy) then
                apply_damage(10, player.facing_left and 1 or -1) -- Apply 10 damage and knockback
            end
        else
            enemy.x = enemy.x - ENEMY_SPEED
            if enemy.x + enemy.width < scroll_x then
                table.remove(enemies, i)
            end
            -- Collision with player using hitbox
            if check_player_hitbox_collision(player, enemy) then
                apply_damage(10, player.facing_left and 1 or -1) -- Apply 10 damage and knockback
            end
        end
    end

    -- Update turrets
    for i = #turrets, 1, -1 do
        local turret = turrets[i]
        turret.shoot_timer = turret.shoot_timer + 1 / 30 -- Assuming 30 FPS
        if turret.shoot_timer >= TURRET_SHOOT_INTERVAL then
            turret.shoot_timer = 0
            spawn_turret_bullets(turret, 12, 12)
        end
    end

    -- Update turret bullets
    for i = #turret_bullets, 1, -1 do
        local bullet = turret_bullets[i]
        bullet.x = bullet.x + bullet.dx
        bullet.y = bullet.y + bullet.dy
        if bullet.x > scroll_x + SCREEN_WIDTH or bullet.x < scroll_x or bullet.y > SCREEN_HEIGHT or bullet.y < 0 then
            table.remove(turret_bullets, i)
        end
        -- Collision with player using hitbox
        if check_player_hitbox_collision(player, bullet) then
            apply_damage(25, player.facing_left and 1 or -1) -- Apply 5 damage and knockback
            table.remove(turret_bullets, i) -- Remove the bullet after collision
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

    -- Check for collisions with bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if enemy.type == "met" then
                if not enemy.hiding and check_enemy_hitbox_collision(enemy, bullet) then
                    table.remove(bullets, i)
                    spawn_explosion(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2)
                    table.remove(enemies, j)
                    score_counter = score_counter + 1
                    break
                else
                    -- ricochet bullets off the Met enemy only if hiding
                    if enemy.hiding then
                        if bullet.x < enemy.x + enemy.width and bullet.x + bullet.width > enemy.x and
                            bullet.y < enemy.y + enemy.height and bullet.y + bullet.height > enemy.y then
                            bullet.dx = -bullet.dx
                        end
                    end
                end
            else
                if check_enemy_hitbox_collision(enemy, bullet) then
                    table.remove(bullets, i)
                    spawn_explosion(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2)
                    table.remove(enemies, j)
                    score_counter = score_counter + 1
                    break
                end
            end
        end
        for j = #turrets, 1, -1 do
            local turret = turrets[j]
            if check_collision(bullet, turret) then
                table.remove(bullets, i)
                spawn_explosion(turret.x + turret.width / 2, turret.y + turret.height / 2)
                table.remove(turrets, j)
                score_counter = score_counter + 1
                break
            end
        end
        for j = #turret_bullets, 1, -1 do
            local turret_bullet = turret_bullets[j]
            if check_collision(bullet, turret_bullet) then
                table.remove(bullets, i)
                table.remove(turret_bullets, j)
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
        player.frame_timer = player.frame_timer + 1 / 60 -- Assuming 60 FPS
        if player.frame_timer >= player.frame_interval then
            player.frame_timer = 0
            player.current_frame = (player.current_frame % num_sprites) + 1
        end
    else
        player.current_frame = 1 -- Reset to the first frame when not moving
    end

    -- Update shooting animation
    if player.shooting and num_shooting_sprites > 0 then
        player.shooting_timer = player.shooting_timer + 1 / 60 -- Assuming 60 FPS
        if player.shooting_timer >= player.shooting_interval then
            player.shooting_timer = 0
            player.shooting_frame = (player.shooting_frame % num_shooting_sprites) + 1
        end
    end

    -- Update scrolling
    local screen_center_x = SCREEN_WIDTH / 2
    if player.x > screen_center_x and player.x < level_data.width - screen_center_x then
        scroll_x = player.x - screen_center_x
    elseif player.x <= screen_center_x then
        scroll_x = 0
    elseif player.x >= level_data.width - screen_center_x then
        scroll_x = level_data.width - SCREEN_WIDTH
    end

    -- Update damage cooldown
    if player_damage_cooldown > 0 then
        player_damage_cooldown = player_damage_cooldown - 1 / 60 -- Assuming 60 FPS
    end
end

-- Register functions and start the loop
register_function("process_events", process_events)
register_function("update_position", update_position)
register_function("draw", draw_game)
start_main_loop()
