-- Create and use a socket
local sock = create_socket()
local connected = connect_socket(sock, "example.com", 80)
if connected == true then
    draw_text(50, 50, "Connected to example.com", "Arial", 20, 0x7C00)  -- Red text
    local sent = send_socket(sock, "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")
    if sent == true then
        draw_text(50, 80, "Data sent to example.com", "Arial", 20, 0x7C00)  -- Red text
        local received = receive_socket(sock, 4096)
        draw_text(50, 110, received, "Arial", 20, 0x7C00)  -- Red text
    else
        draw_text(50, 80, "Failed to send data: " .. sent, "Arial", 20, 0x7C00)  -- Red text
    end
else
    draw_text(50, 50, "Failed to connect: " .. connected, "Arial", 20, 0x7C00)  -- Red text
end