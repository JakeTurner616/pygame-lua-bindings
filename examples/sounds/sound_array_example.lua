-- The following is a thread blocking example that demonstrates the use of the sndarray functions

-- Load a sound file
sound_filename = "examples/sounds/resources/example.wav"
sound = music_load(sound_filename)

-- Test sndarray_array
print("Testing sndarray_array...")
array = sndarray_array(sound)

-- Test sndarray_samples
print("Testing sndarray_samples...")
samples = sndarray_samples(sound)

-- Test sndarray_make_sound
print("Testing sndarray_make_sound...")
new_sound = sndarray_make_sound(samples)

-- Play the new sound
print("Playing the new sound...")
music_play(0, 0.0, 0)

-- Wait for the sound to finish
while music_get_busy() do
    wait(100)
end

-- Unload the sound
music_unload()

print("Music stopped and unloaded and script finished")