-- Game constants
local SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
local PLAYER_WIDTH, PLAYER_HEIGHT = 50, 30
local PLAYER_SPEED = 20
local BULLET_SPEED = 15
local ENEMY_WIDTH, ENEMY_HEIGHT = 80, 72
local ENEMY_SPEED = 5
local ENEMY_SPAWN_INTERVAL = 60  -- frames
local EXPLOSION_MIN_DURATION = 30  
local EXPLOSION_MAX_DURATION = 60  
local SPEED_INCREMENT_INTERVAL = 200  -- frames
local SPEED_INCREMENT_AMOUNT = 1
local KILL_STEP = 5  -- kills needed to increase the number of enemies spawned
local MAX_ENEMIES = 1

-- Initialize game state
local player = {x = SCREEN_WIDTH / 2 - PLAYER_WIDTH / 2, y = SCREEN_HEIGHT - PLAYER_HEIGHT - 10, width = PLAYER_WIDTH, height = PLAYER_HEIGHT}
local keys = {left = false, right = false, space = false}
local bullets = {}
local enemies = {}
local explosions = {}
local enemy_spawn_timer = ENEMY_SPAWN_INTERVAL
local speed_increment_timer = SPEED_INCREMENT_INTERVAL
local score_counter = 0
local game_over = false
local kills = 0

print("Initialized game state")

-- Load the player image
local player_image_path = "examples/games/data/player1.gif"
print("Attempting to load player image from:", player_image_path)
local player_image = load_image(player_image_path)
if not player_image then
    print("Failed to load player image:", player_image_path)
else
    print("Successfully loaded player image:", player_image_path)
end

-- Load the enemy image
local enemy_image_path = "examples/games/data/alien1.gif"
print("Attempting to load enemy image from:", enemy_image_path)
local enemy_image = load_image(enemy_image_path)
if not enemy_image then
    print("Failed to load enemy image:", enemy_image_path)
else
    print("Successfully loaded enemy image:", enemy_image_path)
end

-- Load the explosion image
local explosion_image_path = "examples/games/data/explosion1.gif"
print("Attempting to load explosion image from:", explosion_image_path)
local explosion_image = load_image(explosion_image_path)
if not explosion_image then
    print("Failed to load explosion image:", explosion_image_path)
else
    print("Successfully loaded explosion image:", explosion_image_path)
end

-- Function to spawn enemies
local function spawn_enemy()
    local x
    local valid_position
    repeat
        x = math.random(0, SCREEN_WIDTH - ENEMY_WIDTH)
        valid_position = true
        for _, enemy in ipairs(enemies) do
            if math.abs(x - enemy.x) < 80 then
                valid_position = false
                break
            end
        end
    until valid_position
    local y = 0
    table.insert(enemies, {x = x, y = y, width = ENEMY_WIDTH, height = ENEMY_HEIGHT})
end

-- Function to spawn multiple enemies with staggered times and ensuring no overlap
local function spawn_multiple_enemies(num_enemies)
    local stagger_interval = math.floor(60 / num_enemies)  -- Stagger evenly within 1 second (60 frames)
    for i = 1, num_enemies do
        local delay = i * stagger_interval
        local x
        local valid_position
        repeat
            x = math.random(0, SCREEN_WIDTH - ENEMY_WIDTH)
            valid_position = true
            for _, enemy in ipairs(enemies) do
                if math.abs(x - enemy.x) < 80 then
                    valid_position = false
                    break
                end
            end
        until valid_position
        local y = 0
        local spawn_time = delay + (enemy_spawn_timer - ENEMY_SPAWN_INTERVAL)
        table.insert(enemies, {x = x, y = y, width = ENEMY_WIDTH, height = ENEMY_HEIGHT, spawn_time = spawn_time})
    end
end

-- Function to spawn explosions
local function spawn_explosion(x, y)
    local offset_x = math.random(-25, 25)
    local offset_y = math.random(-25, 25)
    local duration = math.random(EXPLOSION_MIN_DURATION, EXPLOSION_MAX_DURATION)
    table.insert(explosions, {x = x + offset_x, y = y + offset_y, duration = duration})
end

-- Draw function
local function draw_game()
    clear_canvas()

    -- Draw player
    if player_image then
        draw_image(player_image, player.x, player.y)
    end

    -- Draw bullets
    for _, bullet in ipairs(bullets) do
        draw_rectangle(bullet.x, bullet.y, bullet.width, bullet.height, 0xFFFFFF)
    end

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        if enemy.spawn_time == nil or enemy.spawn_time <= 0 then
            if enemy_image then
                draw_image(enemy_image, enemy.x, enemy.y)
            end
        end
    end

    -- Draw explosions
    for _, explosion in ipairs(explosions) do
        if explosion_image then
            draw_image(explosion_image, explosion.x, explosion.y)
        end
    end

    -- Draw score
    draw_text(100, 100, "Score: " .. score_counter, "Arial", 20, "#FFFFFF")

    -- Draw game over message if game is over
    if game_over then
        local game_over_text = "GAME OVER"
        local font_size = 40
        local text_width = #game_over_text * (font_size / 2)  -- Approximate text width
        draw_text(SCREEN_WIDTH / 2 - text_width / 2, SCREEN_HEIGHT / 2 - font_size / 2, game_over_text, "Arial", font_size, "#FF0000")
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
        -- Add offset of 30 pixels to the right for bullet spawn
        local bullet_x = player.x + PLAYER_WIDTH / 2 - 2 + 30
        table.insert(bullets, {x = bullet_x, y = player.y, width = 4, height = 10})
    elseif event.key == K_ESCAPE then
        print("Escape key pressed, stopping main loop")
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
    end
end)

-- Game logic
function process_events()
    for _, e in ipairs(get_events()) do
        print("Event type:", e.type)
        if e.type == "QUIT" then
            print("Quit event detected, stopping main loop")
            stop_main_loop()
        end
    end
end

function update_position()
    if game_over then return end  -- Do not update positions if game is over

    -- Move player based on key states
    if keys.left then
        player.x = math.max(0, player.x - PLAYER_SPEED)
    elseif keys.right then
        player.x = math.min(SCREEN_WIDTH - PLAYER_WIDTH, player.x + PLAYER_SPEED)
    end

    -- Update bullet positions
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.y = bullet.y - BULLET_SPEED
        if bullet.y < 0 then
            table.remove(bullets, i)
        end
    end

    -- Update enemy positions
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        if enemy.spawn_time == nil or enemy.spawn_time <= 0 then
            enemy.y = enemy.y + ENEMY_SPEED
            if enemy.y > SCREEN_HEIGHT then
                game_over = true  -- Set game over if an enemy reaches the bottom
            end
        else
            enemy.spawn_time = enemy.spawn_time - 1
        end
    end

    -- Update explosion durations
    for i = #explosions, 1, -1 do
        local explosion = explosions[i]
        explosion.duration = explosion.duration - 1
        if explosion.duration <= 0 then
            table.remove(explosions, i)
        end
    end

    -- Check for collisions between bullets and enemies
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            -- Improved collision detection using bounding box
            if bullet.x < enemy.x + enemy.width and bullet.x + bullet.width > enemy.x and
               bullet.y < enemy.y + enemy.height and bullet.y + bullet.height > enemy.y then
                table.remove(bullets, i)
                spawn_explosion(enemy.x, enemy.y)
                table.remove(enemies, j)
                score_counter = score_counter + 1  -- Increment score by 1 when an enemy is destroyed
                kills = kills + 1  -- Increment kills counter
                if kills % KILL_STEP == 0 then
                    MAX_ENEMIES = MAX_ENEMIES + 1
                end
                break
            end
        end
    end

    -- Spawn enemies periodically
    if #enemies < MAX_ENEMIES then
        enemy_spawn_timer = enemy_spawn_timer - 1
        if enemy_spawn_timer <= 0 then
            if kills >= KILL_STEP then
                spawn_multiple_enemies(MAX_ENEMIES)
            else
                spawn_enemy()
            end
            enemy_spawn_timer = ENEMY_SPAWN_INTERVAL + math.random(-20, 20)
        end
    end

    -- Increment enemy speed periodically
    speed_increment_timer = speed_increment_timer - 1
    if speed_increment_timer <= 0 then
        ENEMY_SPEED = ENEMY_SPEED + SPEED_INCREMENT_AMOUNT
        speed_increment_timer = SPEED_INCREMENT_INTERVAL
        print("Increased enemy speed to:", ENEMY_SPEED)
    end
end

-- Register functions and start the loop
print("Registering functions")
register_function("process_events", process_events)
register_function("update_position", update_position)
register_function("draw", draw_game)
print("Starting main loop")
start_main_loop()
print("Main loop started")