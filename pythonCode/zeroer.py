import serial
import time
from functions import initialise_micromanip,move_funct,goto_funct,print_pos,reset_funct,zero_pos

outputter = bytearray() # Store for bit-array outputs.
condition = True  # Condition for the main loop to keep running.
TiWa = 3 # Wait time between main loop runs (seconds).

with serial.Serial() as ser:
    ser = initialise_micromanip(ser)
    zero_pos(ser)
