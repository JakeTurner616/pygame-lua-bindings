-- Clear the screen 
clear_canvas()

-- Register event handler for key down
register_event_handler('on_keydown', function(event)
    print('Key down event: ' .. event.key)
    if event.key == K_RIGHT then
        print("RIGHT key pressed")
    elseif event.key == K_LEFT then
        print("LEFT key pressed")
    elseif event.key == K_UP then
        print("UP key pressed")
    elseif event.key == K_DOWN then
        print("DOWN key pressed")
    elseif event.key == K_a then
        print("A key pressed")
    elseif event.key == K_b then
        print("B key pressed")
    -- Add more key checks as needed
    end
end)

-- Update display
flip_display()