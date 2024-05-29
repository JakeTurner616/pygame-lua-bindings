# This file contains the event handling functions and bindings to use the event system in pygame with Lua.
# The functions below allow for registering Lua callbacks for specific pygame events, enabling Lua scripts to interact with pygame.

import pygame
import sys

# Initialize an empty dictionary to hold event handlers for different pygame events.
event_handlers = {
    'on_quit': None,                # Handler for the QUIT event (e.g., when the user closes the window).
    'on_key_down': None,            # Handler for the KEYDOWN event (e.g., when a key is pressed).
    'on_key_up': None,              # Handler for the KEYUP event (e.g., when a key is released).
    'on_mouse_button_down': None,   # Handler for the MOUSEBUTTONDOWN event (e.g., when a mouse button is pressed).
    'on_mouse_button_up': None,     # Handler for the MOUSEBUTTONUP event (e.g., when a mouse button is released).
    'on_mouse_motion': None,        # Handler for the MOUSEMOTION event (e.g., when the mouse is moved).
}

# Flag to control whether event handling is active.
event_handling_active = False


def register_event_handler(event_name, handler):
    """
    Register a handler function for a specific event.
    :param event_name: Name of the event to handle (e.g., 'on_key_down').
    :param handler: The function to call when the event occurs.
    """
    if event_name in event_handlers:
        event_handlers[event_name] = handler

def set_event_handling_active(active):
    """
    Set the flag to enable or disable event handling.
    :param active: True to enable event handling, False to disable it.
    """
    global event_handling_active
    event_handling_active = active

def handle_events():
    """
    Handle pygame events by calling registered Lua event handlers.
    This function should be called regularly to process events and keep the UI responsive.
    """
    if not event_handling_active:
        return

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            if event_handlers['on_quit']:
                event_handlers['on_quit']()
            else:
                pygame.quit()
                sys.exit()
        elif event.type == pygame.KEYDOWN and event_handlers['on_key_down']:
            event_handlers['on_key_down'](event.key, event.mod)
        elif event.type == pygame.KEYUP and event_handlers['on_key_up']:
            event_handlers['on_key_up'](event.key, event.mod)
        elif event.type == pygame.MOUSEBUTTONDOWN and event_handlers['on_mouse_button_down']:
            event_handlers['on_mouse_button_down'](event.button, event.pos[0], event.pos[1])
        elif event.type == pygame.MOUSEBUTTONUP and event_handlers['on_mouse_button_up']:
            event_handlers['on_mouse_button_up'](event.button, event.pos[0], event.pos[1])
        elif event.type == pygame.MOUSEMOTION and event_handlers['on_mouse_motion']:
            pos_x, pos_y = event.pos
            rel_x, rel_y = event.rel if event.rel else (0, 0)
            buttons = event.buttons if event.buttons else (0, 0, 0)
            event_handlers['on_mouse_motion'](pos_x, pos_y, rel_x, rel_y, buttons)

# The following functions provide access to various pygame event system features.



def get_event():
    """
    Get a single event from the event queue.
    Equivalent to pygame.event.get() but returns a single event.
    :return: The next event on the queue.
    """
    return pygame.event.get()

def get_events(eventtype=None, pump=True, exclude=None):
    """
    Get events from the event queue.
    Equivalent to pygame.event.get(eventtype, pump, exclude).
    :param eventtype: The type of events to get.
    :param pump: Whether to pump the event queue.
    :param exclude: Events to exclude from the returned list.
    :return: List of events.
    """
    events = pygame.event.get(eventtype, pump, exclude)
    event_list = []
    for event in events:
        event_dict = {
            'type': event.type
        }
        if event.type in (pygame.KEYDOWN, pygame.KEYUP):
            event_dict['key'] = event.key
            event_dict['mod'] = event.mod
        elif event.type == pygame.MOUSEBUTTONDOWN:
            event_dict['button'] = event.button
            event_dict['pos'] = event.pos
        elif event.type == pygame.MOUSEBUTTONUP:
            event_dict['button'] = event.button
            event_dict['pos'] = event.pos
        elif event.type == pygame.MOUSEMOTION:
            event_dict['pos'] = event.pos
            event_dict['rel'] = event.rel
            event_dict['buttons'] = event.buttons
        event_list.append(event_dict)
    return event_list



def pump_events():
    """
    Pump the event queue to keep the UI responsive.
    Equivalent to pygame.event.pump().
    """
    pygame.event.pump()

def poll_event():
    """
    Poll for a single event from the event queue.
    Equivalent to pygame.event.poll().
    :return: The next event on the queue, or None if the queue is empty.
    """
    return pygame.event.poll()

def wait_event():
    """
    Wait for a single event from the event queue.
    Equivalent to pygame.event.wait().
    :return: The next event on the queue.
    """
    return pygame.event.wait()

def peek_event(eventtype=None):
    """
    Check if there are events of a certain type in the event queue.
    Equivalent to pygame.event.peek(eventtype).
    :param eventtype: The type of events to check for.
    :return: True if there are events of the specified type, False otherwise.
    """
    return pygame.event.peek(eventtype)

def clear_events(eventtype=None):
    """
    Clear events from the event queue.
    Equivalent to pygame.event.clear(eventtype).
    :param eventtype: The type of events to clear.
    """
    pygame.event.clear(eventtype)

def event_name(event_id):
    """
    Get the name of an event given its ID.
    Equivalent to pygame.event.event_name(event_id).
    :param event_id: The ID of the event.
    :return: The name of the event.
    """
    return pygame.event.event_name(event_id)

def set_blocked(eventtype):
    """
    Block a certain type of event.
    Equivalent to pygame.event.set_blocked(eventtype).
    :param eventtype: The type of event to block.
    """
    pygame.event.set_blocked(eventtype)

def set_allowed(eventtype):
    """
    Allow a certain type of event.
    Equivalent to pygame.event.set_allowed(eventtype).
    :param eventtype: The type of event to allow.
    """
    pygame.event.set_allowed(eventtype)

def get_blocked(eventtype):
    """
    Check if a certain type of event is blocked.
    Equivalent to pygame.event.get_blocked(eventtype).
    :param eventtype: The type of event to check.
    :return: True if the event type is blocked, False otherwise.
    """
    return pygame.event.get_blocked(eventtype)

def set_grab(grab):
    """
    Set the input grab mode.
    Equivalent to pygame.event.set_grab(grab).
    :param grab: Boolean flag to enable or disable input grab.
    """
    pygame.event.set_grab(grab)

def get_grab():
    """
    Get the current input grab mode.
    Equivalent to pygame.event.get_grab().
    :return: True if input grab is enabled, False otherwise.
    """
    return pygame.event.get_grab()

def set_keyboard_grab(grab):
    """
    Set the keyboard input grab mode.
    Equivalent to pygame.event.set_keyboard_grab(grab).
    :param grab: Boolean flag to enable or disable keyboard input grab.
    """
    pygame.event.set_keyboard_grab(grab)

def get_keyboard_grab():
    """
    Get the current keyboard input grab mode.
    Equivalent to pygame.event.get_keyboard_grab().
    :return: True if keyboard input grab is enabled, False otherwise.
    """
    return pygame.event.get_keyboard_grab()

def post_event(event):
    """
    Post a new event to the event queue.
    Equivalent to pygame.event.post(event).
    :param event: The event to post.
    """
    pygame.event.post(event)

def custom_event_type():
    """
    Create a new custom event type.
    Equivalent to pygame.event.custom_type().
    :return: The new custom event type.
    """
    return pygame.event.custom_type()


def Event(eventtype, dict=None):
    """
    Create a new event object.
    Equivalent to pygame.event.Event(eventtype, dict).
    :param eventtype: The type of event to create.
    :param dict: Dictionary of attributes for the event.
    :return: The new event object.
    """
    return pygame.event.Event(eventtype, dict)