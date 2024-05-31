-- The following is a thread blocking example that demonstrates the use of the music functions

-- Load a music file
music_load("examples/sounds/resources/example.mp3")

-- Play the music
music_play(1, 0.0, 1000)

-- Set volume
music_set_volume(0.5)

-- Check if music is playing
if music_get_busy() then
    print("Music is playing")
else
    print("Music is not playing")
end

-- Wait for a few seconds
wait(5000)

-- Pause the music
music_pause()
print("Music paused for 2 seconds")

-- Wait for a few seconds
wait(2000)

-- Unpause the music
music_unpause()
print("Music unpaused for 5 seconds")

-- Wait for a few seconds
wait(5000)

-- Stop the music
music_stop()

-- Unload the music
music_unload()

print("Music stopped and unloaded and script finished")