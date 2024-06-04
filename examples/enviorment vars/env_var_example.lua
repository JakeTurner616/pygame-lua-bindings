-- Access the environment variables passed from Python
local env = env

-- Print some environment variables
print("Environment Variables example:")

-- Get and print the system type
local os_name = env.OS or "Unknown OS"
print("Operating System: " .. os_name)

-- You can add more environment variables to print as needed