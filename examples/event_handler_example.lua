-- Clear the screen and draw some shapes
clear_canvas()

-- Draw Blue text
draw_text(50, 50, "Hello, Pygame!", "Arial", 30, 0x0000FF)

-- Register event handler for key down
register_event_handler('on_keydown', function(event)
    print('Key down event: ' .. event.key)
end)

-- Register event handler for key up
register_event_handler('on_keyup', function(event)
    print('Key up event: ' .. event.key)
end)

-- Register event handler for mouse button down
register_event_handler('on_mousebuttondown', function(event)
    print('Mouse button down event: button=' .. event.button .. ' pos=' .. event.pos[1] .. ',' .. event.pos[2])
end)

-- Register event handler for mouse button up
register_event_handler('on_mousebuttonup', function(event)
    print('Mouse button up event: button=' .. event.button .. ' pos=' .. event.pos[1] .. ',' .. event.pos[2])
end)

-- Register event handler for mouse motion
register_event_handler('on_mousemotion', function(event)
    print('Mouse motion event: pos=' .. event.pos[1] .. ',' .. event.pos[2] .. ' rel=' .. event.rel[1] .. ',' .. event.rel[2] .. ' buttons=' .. table.concat(event.buttons, ','))
end)

-- Function to process events
function process_events()
    local events = get_events()
    for i = 1, #events do
        local event = events[i]
        print('Event: type=' .. event.type)
    end
end

-- Update display
flip_display()