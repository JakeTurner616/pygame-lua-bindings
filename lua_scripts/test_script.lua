-- Convert a common color name to RGB
local rgb = hex_to_rgb('red')
print(rgb)  -- Output: {255, 0, 0}

-- Create an opaque red color
local red = color(255, 0, 0)
print(red)  -- Output: {255, 0, 0, 255}

-- Get the dictionary of predefined colors
local colors = THECOLORS()
print(colors['aliceblue'])  -- Output: {240, 248, 255, 255}