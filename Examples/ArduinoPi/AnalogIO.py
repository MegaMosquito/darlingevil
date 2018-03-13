#!/usr/bin/python
#
#   Arduino Interface Test Program (For Analog I/O)
#
#   Verifies the pyFirmata interface to an Arduino
#   by performing analog read and write operations
#   on a simple circuit.
#   I used a 3.3V Arduino Pro Mini for this.
#
#   Note that analog output is implemented using a
#   digital Pulse Wave Modulation (PWM) output pin
#   since the Arduino does not have true analog out
#   circuitry through an Analog to Digital Convertor
#   (ADC).
#
#   The code reads the analog input from the specified
#   analog input pin (e.g., A0..A7) then writes that
#   (now digitized) data to the specified PWM output
#   pin (only D3, D5, D6, D9, D10, or D11 on the
#   Arduino Pro Mini -- check the documentation for
#   your board to see which digital pins are capable
#   of PWM output...  not all of them are).
#
#   Wiring (see the Fritzing diagram for clarity):
#
#   * Potentiometer: 
#       - GND, A0, 3V3 (i.e., regulated power output)
#       - center pin must be wired to A0
#       - the other 2 may be wired either way around
#       - one side pin (either one) to ground
#       - the other side pin to regulated power pin
#         (on my 3.3V Arduino Pro Mini this is the
#         3V3 pin.  On a 5V board this will be 5V0.
#   * LED:
#       - anode (longer leg) is wired to D10
#       - cathode (shorter leg) attached to a
#         200K ohm resistor which is connected
#         to GND (ground)
#
import pyfirmata
import signal
import sys
import time

# Use this to turn on/off the print statements
DEBUG = False

# Set this to the Arduino serial port (e.g., '/dev/ttyUSB0' or '/dev/ttyACM0')
ARDUINO_PORT = '/dev/ttyUSB0'

# Create a new board object, specifying the serial port
board = pyfirmata.Arduino(ARDUINO_PORT)

# Set up analog pin 0 for input (i.e., 'a:0:i') for the potentiometer
analogInputPin = board.get_pin('a:0:i')

# Set up digital pin 10 for PWM output (i.e., 'd:10:p') for the LED
analogOutputPin = board.get_pin('d:10:p')

# Signal handler to clean up after the interrupt is received
def signal_handler(signal, frame):
  if DEBUG: print 'Cleaning up...'
  analogOutputPin.write(0)
  board.exit()
  sys.exit(0)

def main():

  # Start an iterator thread so the serial buffer doesn't overflow
  iter8 = pyfirmata.util.Iterator(board)
  iter8.start()

  # IMPORTANT! discard first reads until A0 gets something valid
  while analogInputPin.read() is None:
    if DEBUG: print "warming up..."
    time.sleep(0.02)

  # Set up a signal handler to shut down cleanly
  signal.signal(signal.SIGINT, signal_handler)

  # Run until interrupted
  if DEBUG: print "Press Crtl-C to exit..."
  while True:

    # Read from the analog pin (pyFirmata range is {0.0..1.0}
    inputValue = analogInputPin.read()
    if DEBUG: print "Debug: %f" % (inputValue)

    # Simulate an analog output using PWM on the output pin in {0.0..1.0}
    analogOutputPin.write(inputValue)

    # Pause before resampling
    time.sleep(0.02)

if __name__ == "__main__":
    main()

