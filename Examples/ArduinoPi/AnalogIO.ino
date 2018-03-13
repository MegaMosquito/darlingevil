/*
    Analog Input/Output Test Program

    Verifies analog input and output circuitry.
    Details here refer to a 3.3V Arduino Pro Mini.

    Note that analog output is implemented using a
    digital Pulse Wave Modulation (PWM) output pin
    since the Arduino does not have true analog out
    circuitry through an Analog to Digital Convertor
    (ADC).

    The code reads the analog input from the specified
    analog input pin (e.g., A0..A7) then writes that
    (now digitized) data to the specified PWM output
    pin (only D3, D5, D6, D9, D10, or D11 on the
    Arduino Pro Mini -- check the documentation for
    your board to see which digital pins are capable
    of PWM output...  not all of them are).

    Wiring (see the Fritzing diagram for clarity):

    * Potentiometer: 
        - GND, A0, 3V3 (i.e., regulated power output)
        - center pin must be wired to A0
        - the other 2 may be wired either way around
        - one side pin (either one) to ground
        - the other side pin to regulated power pin
          (on my 3.3V Arduino Pro Mini this is the
          3V3 pin.  On a 5V board this will be 5V0.
    * LED:
        - anode (longer leg) is wired to D10
        - cathode (shorter leg) attached to a
          200K ohm resistor which is connected
          to GND (ground)

 */

int analogInputPin = A0; // Potentiometer
int analogOutputPin = 10; // LED
int delayBetweenLoops = 20; // Sampling frequency

void setup() {
}

void loop() {
  
    // Read the potentiometer (value will be in {0..1023}
    int inputValue = analogRead(analogInputPin);

    // Map the "value from the input range down to the desired output range {0..255}
    int outputValue = map(inputValue, 0, 1023, 0, 255);
    
    // Write the value in range {0..255} via PWM to the output pin to simulate analog output
    analogWrite(analogOutputPin, outputValue);

    // Pause the program for a few milliseconds before sampling again
    delay(delayBetweenLoops);
}
