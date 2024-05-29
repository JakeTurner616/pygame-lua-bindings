import pygame
import sys

def get_ticks():
    """
    Get the time in milliseconds since pygame.init() was called.
    :return: Number of milliseconds.
    """
    return pygame.time.get_ticks()

def wait(milliseconds):
    """
    Pause the program for an amount of time.
    :param milliseconds: Number of milliseconds to pause.
    :return: Actual number of milliseconds used.
    """
    return pygame.time.wait(milliseconds)

def delay(milliseconds):
    """
    Pause the program for an amount of time.
    :param milliseconds: Number of milliseconds to pause.
    :return: Actual number of milliseconds used.
    """
    return pygame.time.delay(milliseconds)

def set_timer(event, millis, loops=0):
    """
    Set an event to appear on the event queue every given number of milliseconds.
    :param event: Event type or pygame.event.Event object.
    :param millis: Time in milliseconds.
    :param loops: Number of events to post (0 for infinite).
    """
    pygame.time.set_timer(event, millis, loops)

class Clock:
    def __init__(self):
        self.clock = pygame.time.Clock()

    def tick(self, framerate=0):
        """
        Update the clock.
        :param framerate: Frame rate to cap.
        :return: Number of milliseconds passed since the last call.
        """
        return self.clock.tick(framerate)

    def tick_busy_loop(self, framerate=0):
        """
        Update the clock using a busy loop.
        :param framerate: Frame rate to cap.
        :return: Number of milliseconds passed since the last call.
        """
        return self.clock.tick_busy_loop(framerate)

    def get_time(self):
        """
        Get the time used in the previous tick.
        :return: Number of milliseconds.
        """
        return self.clock.get_time()

    def get_rawtime(self):
        """
        Get the actual time used in the previous tick.
        :return: Number of milliseconds.
        """
        return self.clock.get_rawtime()

    def get_fps(self):
        """
        Compute the clock framerate.
        :return: Frames per second.
        """
        return self.clock.get_fps()