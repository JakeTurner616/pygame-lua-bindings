
-- Initialize the counter
local counter = 0
local circle_x, circle_y = 300, 300

-- Simple loop to test the event system and update the counter
while true do
    -- Pump the event queue to ensure events are being processed
    pump_events()

    -- Update the counter
    counter = counter + 1
    print("Counter: " .. counter)

    -- Drawing example
    clear_canvas()
    draw_text(100, 100, "Counter: " .. counter, "Arial", 20, "#FFFFFF")
    draw_rectangle(50, 50, 200, 150, "#00FF00", 5)
    draw_circle(0x00FF00, {circle_x, circle_y}, 50)

    -- Flush the drawings to the screen
    flip_display()

    -- Delay for 1 second (1 second = 1.0)
    delay(1000)

    -- Optional: Break the loop on a specific condition if needed
end