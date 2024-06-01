-- Get the state of the mouse buttons
function check_mouse_buttons()
    local button1, button2, button3 = get_mouse_pressed(3)  -- Check the first three buttons
    if button1 then
        print("Button 1 is pressed")
    end
    if button2 then
        print("Button 2 is pressed")
    end
    if button3 then
        print("Button 3 is pressed")
    end
end

-- Get the mouse cursor position
function get_mouse_position()
    local x, y = get_mouse_pos()
    print("Mouse position:", x, y)
end

-- Set the mouse cursor position
function set_mouse_position(x, y)
    set_mouse_pos(x, y)
end

-- Set the mouse cursor to a new cursor
function set_custom_cursor(cursor)
    set_mouse_cursor(cursor)
end

-- Get the current mouse cursor
function get_current_cursor()
    local cursor = get_mouse_cursor()
    print("Current mouse cursor:", cursor)
end

-- Example usage
check_mouse_buttons()
get_mouse_position()
set_mouse_position(100, 100)
get_current_cursor()