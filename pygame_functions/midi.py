import pygame.midi

def midi_init():
    """
    Initialize the midi module.
    """
    pygame.midi.init()

def midi_quit():
    """
    Uninitialize the midi module.
    """
    pygame.midi.quit()

def midi_get_init():
    """
    Check if the midi module is currently initialized.
    """
    return pygame.midi.get_init()

def midi_Input(device_id, buffer_size=None):
    """
    Create a midi input object.
    """
    return pygame.midi.Input(device_id, buffer_size)

def midi_Input_close(midi_input):
    """
    Close a midi input object.
    """
    midi_input.close()

def midi_Input_poll(midi_input):
    """
    Check if there's data available in the input buffer.
    """
    return midi_input.poll()

def midi_Input_read(midi_input, num_events):
    """
    Read midi events from the input buffer.
    """
    return midi_input.read(num_events)

def midi_Output(device_id, latency=0, buffer_size=256):
    """
    Create a midi output object.
    """
    return pygame.midi.Output(device_id, latency, buffer_size)

def midi_Output_abort(midi_output):
    """
    Terminate outgoing messages immediately.
    """
    midi_output.abort()

def midi_Output_close(midi_output):
    """
    Close a midi output object.
    """
    midi_output.close()

def midi_Output_note_off(midi_output, note, velocity=None, channel=0):
    """
    Turn a midi note off.
    """
    midi_output.note_off(note, velocity, channel)

def midi_Output_note_on(midi_output, note, velocity=None, channel=0):
    """
    Turn a midi note on.
    """
    midi_output.note_on(note, velocity, channel)

def midi_Output_set_instrument(midi_output, instrument_id, channel=0):
    """
    Select an instrument.
    """
    midi_output.set_instrument(instrument_id, channel)

def midi_Output_pitch_bend(midi_output, value=0, channel=0):
    """
    Modify the pitch of a channel.
    """
    midi_output.pitch_bend(value, channel)

def midi_Output_write(midi_output, data):
    """
    Write midi data to the output.
    """
    midi_output.write(data)

def midi_Output_write_short(midi_output, status, data1=0, data2=0):
    """
    Write up to 3 bytes of midi data to the output.
    """
    midi_output.write_short(status, data1, data2)

def midi_Output_write_sys_ex(midi_output, when, msg):
    """
    Write a timestamped system-exclusive midi message.
    """
    midi_output.write_sys_ex(when, msg)

def midi_get_count():
    """
    Get the number of midi devices.
    """
    return pygame.midi.get_count()

def midi_get_default_input_id():
    """
    Get the default input device number.
    """
    return pygame.midi.get_default_input_id()

def midi_get_default_output_id():
    """
    Get the default output device number.
    """
    return pygame.midi.get_default_output_id()

def midi_get_device_info(device_id):
    """
    Get information about a midi device.
    """
    return pygame.midi.get_device_info(device_id)

def midi_midis2events(midi_events, device_id):
    """
    Convert midi events to pygame events.
    """
    return pygame.midi.midis2events(midi_events, device_id)

def midi_time():
    """
    Get the current time in ms of the PortMidi timer.
    """
    return pygame.midi.time()

def midi_frequency_to_midi(frequency):
    """
    Convert a frequency into a MIDI note.
    """
    return pygame.midi.frequency_to_midi(frequency)

def midi_midi_to_frequency(midi_note):
    """
    Convert a MIDI note to a frequency.
    """
    return pygame.midi.midi_to_frequency(midi_note)

def midi_midi_to_ansi_note(midi_note):
    """
    Get the Ansi Note name for a midi number.
    """
    return pygame.midi.midi_to_ansi_note(midi_note)

class MidiException(Exception):
    """
    Exception raised by pygame.midi functions and classes.
    """
    def __init__(self, errno):
        super().__init__(errno)