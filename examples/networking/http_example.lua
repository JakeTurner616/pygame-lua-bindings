-- Make an HTTP GET request
local response = http_get("https://jsonplaceholder.typicode.com/todos/1")
-- Print response to the Pygame window
draw_text(50, 50, response, "Arial", 20, 0x7C00)  -- Red text