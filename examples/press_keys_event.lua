-- Clear the screen 
clear_canvas()

-- Register event handler for key down
register_event_handler('on_keydown', function(event)
    print('Key down event: ' .. event.key)
    if event.key == 1073741903 then  -- RIGHT key
print("RIGHT key pressed")
    elseif event.key == 1073741904 then  -- LEFT key
print("LEFT key pressed")
    elseif event.key == 1073741906 then  -- UP key
print("UP key pressed")
    elseif event.key == 1073741905 then  -- DOWN key
print("DOWN key pressed")
    end
end)



-- Update display
flip_display()