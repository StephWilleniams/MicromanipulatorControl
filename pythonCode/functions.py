import serial
import time

# Function to set the serial port properties
def initialise_micromanip(ser,baudval=9600,myport='/dev/cu.usbserial-A704GKM4',timeval=3):
    ser.baudrate = baudval
    ser.port = myport
    ser.timeout = timeval
    ser.parity = serial.PARITY_NONE
    ser.bytesize = serial.EIGHTBITS
    ser.stopbits = serial.STOPBITS_ONE   
    ser.open()
    return ser

# Function to move the arm.
def move_funct(ser,dx=0,dy=0,dz=0):
    command = b'REL {} {} {}\r\n'.format(dx,dy,dz)
    ser.write(command)
    
# Function to move the arm to a given position
def goto_funct(ser,x=0,y=0,z=0):
    command = b'ABS {} {} {}\r\n'.format(x,y,z)
    ser.write(command)

# Get the current position of the micromanipulator.
def print_pos(ser):
    command = b'P\r\n'
    ser.write(command)
    data = bytearray()
    data = ser.read(100)
    print(data)
    return data

# Move the micropipette far away from its current position and then return it.
def reset_funct(ser,bigval=10000):
    # Note, the sign of dy needs to be checked.
    move_funct(ser,0,bigval,0)
    time.sleep(3)
    goto_funct(ser)

# Set the current position to be '[0,0,0]'
def zero_pos(ser):
    command = b'P 0 0 0'
    ser.write(command)
