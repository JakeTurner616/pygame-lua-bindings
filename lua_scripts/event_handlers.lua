-- Function to enable event handling
function enable_event_handling()
    set_event_handling_active(true)
end

-- Register event handlers in Lua (optional)
register_event_handler("on_key_down", function(key)
    if key == 27 then  -- ESC key
        print("ESC key pressed, exiting...")
        os.exit()
    else
        print("Key down: " .. key)
    end
end)

register_event_handler("on_key_up", function(key)
    print("Key up: " .. key)
end)

register_event_handler("on_mouse_button_down", function(button, x, y)
    print("Mouse button down: " .. button .. " at (" .. x .. ", " .. y .. ")")
end)

register_event_handler("on_mouse_button_up", function(button, x, y)
    print("Mouse button up: " .. button .. " at (" .. x .. ", " .. y .. ")")
end)

-- Optional: Only register if needed
register_event_handler("on_mouse_motion", function(x, y, rel_x, rel_y)
    print("Mouse motion at (" .. x .. ", " .. y .. "), relative movement (" .. rel_x .. ", " .. rel_y .. ")")
end)