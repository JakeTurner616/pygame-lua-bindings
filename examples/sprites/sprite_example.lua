-- Simple Chess Game in Lua with Pygame using PNG Assets

-- Constants
local TILE_SIZE = 80
local SCREEN_SIZE = 8 * TILE_SIZE

local PIECE_IMAGES = {
    ["w-pawn"] = "/chess/w-pawn.png",
    ["w-rook"] = "/chess/w-rook.png",
    ["w-knight"] = "/chess/w-knight.png",
    ["w-bishop"] = "/chess/w-bishop.png",
    ["w-queen"] = "/chess/w-queen.png",
    ["w-king"] = "/chess/w-king.png",
    ["b-pawn"] = "/chess/b-pawn.png",
    ["b-rook"] = "/chess/b-rook.png",
    ["b-knight"] = "/chess/b-knight.png",
    ["b-bishop"] = "/chess/b-bishop.png",
    ["b-queen"] = "/chess/b-queen.png",
    ["b-king"] = "/chess/b-king.png"
}

local PIECES = {
    {"b-rook", "b-knight", "b-bishop", "b-queen", "b-king", "b-bishop", "b-knight", "b-rook"},
    {"b-pawn", "b-pawn", "b-pawn", "b-pawn", "b-pawn", "b-pawn", "b-pawn", "b-pawn"},
    {"", "", "", "", "", "", "", ""},
    {"", "", "", "", "", "", "", ""},
    {"", "", "", "", "", "", "", ""},
    {"", "", "", "", "", "", "", ""},
    {"w-pawn", "w-pawn", "w-pawn", "w-pawn", "w-pawn", "w-pawn", "w-pawn", "w-pawn"},
    {"w-rook", "w-knight", "w-bishop", "w-queen", "w-king", "w-bishop", "w-knight", "w-rook"}
}

local selected = nil
local turn = "white"  -- White goes first

-- Utility function to check if a move is valid for a pawn
local function is_valid_pawn_move(piece, from, to)
    local direction = piece:sub(1, 1) == "w" and -1 or 1
    local start_row = piece:sub(1, 1) == "w" and 7 or 2

    -- Moving forward
    if from.x == to.x and PIECES[to.y][to.x] == "" then
        if from.y + direction == to.y then
            return true
        elseif from.y == start_row and from.y + 2 * direction == to.y and PIECES[from.y + direction][from.x] == "" then
            return true
        end
    end

    -- Capturing diagonally
    if math.abs(from.x - to.x) == 1 and from.y + direction == to.y and PIECES[to.y][to.x] ~= "" then
        return true
    end

    return false
end

-- Function to check if a move is valid
local function is_valid_move(piece, from, to)
    if piece == "" then return false end

    if piece:sub(3) == "pawn" then
        return is_valid_pawn_move(piece, from, to)
    end

    -- Add more rules for other pieces (rook, knight, bishop, queen, king)
    return true
end

-- Draw function
local function draw_game()
    clear_canvas()

    -- Draw chessboard
    for y = 1, 8 do
        for x = 1, 8 do
            local color = (x + y) % 2 == 0 and "#EEE" or "#555"
            draw_rectangle((x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE, color)
            local piece = PIECES[y][x]
            if piece ~= "" then
                local image = PIECE_IMAGES[piece]
                draw_image(image, (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    end

    flip_display()
end

-- Event handling for mouse clicks
local function on_mousebuttondown(event)
    print("on_mousebuttondown called with event:", event)
    local gx, gy = math.floor(event.pos[1] / TILE_SIZE) + 1, math.floor(event.pos[2] / TILE_SIZE) + 1
    if selected then
        local piece = PIECES[selected.y][selected.x]
        if is_valid_move(piece, selected, {x = gx, y = gy}) then
            PIECES[gy][gx] = PIECES[selected.y][selected.x]
            PIECES[selected.y][selected.x] = ""
            turn = turn == "white" and "black" or "white"
        end
        selected = nil
    elseif PIECES[gy][gx] ~= "" then
        if (turn == "white" and PIECES[gy][gx]:sub(1, 1) == "w") or (turn == "black" and PIECES[gy][gx]:sub(1, 1) == "b") then
            selected = {x = gx, y = gy}
        end
    end
end

-- Process events (e.g., window close)
local function process_events()
    for _, e in ipairs(get_events()) do
        if e.type == "QUIT" then
            stop_main_loop()
        end
    end
end

-- Register functions and start the loop
register_event_handler('on_mousebuttondown', on_mousebuttondown)
register_function("process_events", process_events)
register_function("draw", draw_game)
start_main_loop()