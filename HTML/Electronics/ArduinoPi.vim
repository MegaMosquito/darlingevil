<img src="https://darlingevil.com/wp-content/uploads/2018/03/arduinopi.jpg" alt="" width="3151" height="2137" class="aligncenter size-full wp-image-151" />

This is a story of true romance; a match made in silicon heaven; a story of an unlikely match up between two very different single board computers (SBCs): a Raspberry Pi 3 model B, and an Arduino Pro Mini.  It's a story that could be told about any Raspberry Pi model paired with any Arduino model.

Arduino SBCs are really great at interfacing with the real, analog, world.  They can consume analog data sources, sampling them with 10 bits (or more) of resolution, at frequencies of perhaps 60 samples per second (or even greater).  They can also produce (low amperage) simulated analog output signals using the Pulse Wave Modulation (PWM) technique.  <a href="https://darlingevil.com/electronics-analog-sources/" rel="noopener" target="_blank">This page</a> has some info about Arduinos, and analog signals.  Unfortunately though, the computing capability of Arduinos is minimal.  They typically have very small RAM memory (a few KB), and the maximum size of the programs stored in their flash memories is very small (a few tens of KB).  Many of the Arduinos are not even capable of communicating over common interfaces like USB.

Raspberry Pi SBCs are very powerful little Linux hosts, some with quad-core 32bit CPUs, powerful GPUs, and 1GB of RAM.  They one or more USB ports, HDMI and stereo audio output ports, and dozens of (purely digital) GPIO pins.  Unfortunately they are unable to consume a simple analog input signal, and their ability to produce analog output is very constrained.

When a Romeo Arduino meets a Juliet Pi, their matchup enables the world of analog I/O to join the world of modern software.  Let's take a look at how we can make this beautiful matchup happen.

<strong>Parts List:</strong>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/Raspberry-Pi-RASPBERRYPI3-MODB-1GB-Model-Motherboard/dp/B01CD5VC92/ref=sr_1_3?s=electronics&ie=UTF8&qid=1520805795&sr=1-3&keywords=raspberry+Pi" rel="noopener" target="_blank">Raspberry Pi 3, model B</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/Raspberry-Power-Supply-Adapter-Charger/dp/B0719SX3GC/ref=sr_1_1_sspa?s=electronics&ie=UTF8&qid=1520806083&sr=1-1-spons&keywords=2.5A+usb+power+supply&psc=1" rel="noopener" target="_blank">2.5A or greater USB (5V) power supply and cord</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/SanDisk-microSDHC-Standard-Packaging-SDSQUNC-032G-GN6MA/dp/B010Q57T02/ref=sr_1_2?s=electronics&ie=UTF8&qid=1520806036&sr=1-2&keywords=microsd+32G" rel="noopener" target="_blank">microSD flash card (I like to use 32GB size, but probably 8GB or larger could work)</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/Arducam-Atmega328-Development-Compatible-Arduino/dp/B01981EBBA/ref=sr_1_3?ie=UTF8&qid=1520805756&sr=8-3&keywords=arduino+pro+mini+5v" rel="noopener" target="_blank">Arduino Pro Mini (5V)</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/RobotDyn-USB-TTL-Serial-adapter-USB/dp/B071ZMKSKZ/ref=sr_1_5?s=electronics&ie=UTF8&qid=1520806137&sr=1-5&keywords=USB-serial+adapter+5v" rel="noopener" target="_blank">USB-Serial Adapter (5V)</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/Uxcell-a15011600ux0235-Linear-Rotary-Potentiometer/dp/B01DKCUVMQ/ref=sr_1_3?s=industrial&ie=UTF8&qid=1520806518&sr=1-3&keywords=10k+ohm+pot" rel="noopener" target="_blank">10K ohm potentiometer (as an example analog input source)</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/M-best-Assorted-Emitting-Electronic-Resistors/dp/B01C33LN16/ref=sr_1_3?s=industrial&ie=UTF8&qid=1520806563&sr=1-3&keywords=led+resistors" rel="noopener" target="_blank">LED with 200 ohm resistor in series (as an example analog output)</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/Elegoo-tie-points-breadboard-Arduino-Jumper/dp/B01EV640I6/ref=sr_1_4?s=industrial&ie=UTF8&qid=1520806651&sr=1-4&keywords=breadboard" rel="noopener" target="_blank">Prototyping breadboard (optional)</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://smile.amazon.com/CIRCUIT-TEST-22AWG-Solid-Hook-Wire/dp/B01180QKJ0/ref=sr_1_5?s=industrial&ie=UTF8&qid=1520806608&sr=1-5&keywords=breadboard+wire" rel="noopener" target="_blank">A few short wires suitable for breadboard use</a>

PLEASE NOTE: You need to purchase an appropriate USB-Serial adapter for the particular Arduino you buy.  Above I listed 5V models, but you could instead purchase the 3.3V models, but both must match.  E.g., a 3.3V USB-Serial adapter <strong>will not work correctly</strong> with a 5V Arduino Pro Mini.  USB-Serial adapters (like the one in the Amazon link above) are able to work with either 3.3V or 5V devices.  If you purchase one of those, make sure the toggle switch is set to the appropriate one of those voltages before you connect power to these devices or you may damage the components.

You may also need to solder the pins onto the Arduino (the ones I buy always come with the pins unattached, so they require soldering).  If so, you will at least need some small diameter (e.g., 0.3mm) flux or rosin core (<strong>not acid core</strong>) solder, and a soldering pen of at least 25W (I personally prefer to use a 60W solder pen, because too hot is easier to deal with than too cold).  There are many online tutorials (like <a href="https://www.youtube.com/watch?v=IpkkfK937mU" rel="noopener" target="_blank">this one</a>) that can teach you how to solder if you have never done it before.  Be careful.  There be monsters here.

<strong>Wiring:</strong>

Let's start with the Arduino/analog side of the circuitry.

Connect the example analog input and output devices to the Arduino as shown in the Fritzing output below:

<img src="https://darlingevil.com/wp-content/uploads/2018/03/fritzing.jpg" alt="" width="2360" height="1952" class="aligncenter size-full wp-image-159" />

Next, connect the USB-Serial adapter to the Arduino, as follows:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; connect GND on the adapter to the pin labelled BLK on the Arduino
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; connect DTR on the adapter to the pin labelled GRN on the Arduino
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; connect RXD on the adapter to TX0 on the Arduino
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; connect TXD on the adapter to RX1 on the Arduino
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; connect 5V (or 3.3V) on the adapter to VCC on the Arduino

Once that is done, you can connect the USB connector to your Raspberry Pi, and the hardware (wiring) will be all done.  The photo at the top of this article shows the completed hardware.  Now let's move on to look at the two software of this project (i.e., both the Arduino and the Raspberry Pi require software for this).

<strong>Arduino Software:</strong>

The code discussed in this section is available in the <strong>Examples/AnalogIO</strong> directory of the <a href="https://github.com/MegaMosquito/darlingevil" rel="noopener" target="_blank">DarlingEvil git repo</a>.

To load software onto your Arduino you need to run the <a href="https://www.arduino.cc/en/Main/Software" rel="noopener" target="_blank">Arduino Integrated Development Environment (IDE)</a> software on some other host.  It is possible to run this software directly on the Raspberry Pi, but I don't recommend that.  It is better to use it in Windows or MacOS.  My long time preference is to use MacOS, but in the latest versions of MacOS I always seem to have trouble with the Arduino IDE not being able to communicate with my Arduinos.  Regretfully I recommend using Windows if you have access to a relatively recent Windows machine.  I personally always have a Windows machine hanging around somewhere.  Most of the time I try not to get any Windows on me, but when it comes to Virtual Reality (VR), or first person (3D) games, or programming Arduinos, it's still the best choice.  If you can't use Windows then you might want to try the new Arduino "web editor" a web-based version of the IDE (details at the link above).

Once you have the Arduino IDE installed, connect the USB-Serial adapter (with the Arduino and additional hardware attached) to one of the USB ports of the machine where you are running the IDE, then launch the IDE.  When the IDE has come up, open the <strong>AnalogIO.ino</strong> file int the <strong>Examples/AnalogIO</strong> directory of the <strong>git</strong> repo.  Now from the <strong>Tools</strong> menu, configure the <strong>Port</strong>, and <strong>Board</strong> (select "<strong>Arduino Pro or Pro Mini</strong>").  Then tap the "Upload" button (the one with the <strong>rightward-pointing arrow</strong>).  The program should then compile, and begin uploading to the Arduino.  When it is finished uploading, it will automatically start running.  You should interact with the potentiometer and observe the output LED increasing and decreasing in brightness as you do so.  With that, your hardware testing is complete.  Note that this program has been uploaded into the flash memory of the Arduino, so it is now persistent there.  You could disconnect the Arduino from the IDE host, and power it from any 5V source, and it will run that saved program.

Now let's install the software that will enable the Arduino to act as a slave (i.e., as a peripheral) of the Raspberry Pi.  There are many ways that a Raspberry Pi and an Arduino can communicate, but I find this approach to be simple and elegant.

Make sure your Arduino is still connected to the IDE machine.  Now open the "<strong>Standard Firmata</strong>" program from the "<strong>File/Examples/Firmata/Standard Firmata</strong>" menu item in the IDE.  You should see a file come open in the IDE.  This is the program that will enable your Arduino to act as a slave of your Raspberry Pi.  Next, make sure that the appropriate Port and Board are configured (as before).  And finally, tap the upload button (right arrow) to compile, upload and run the Standard Firmata program.  

Once that has completed successfully, your Arduino is ready to go!  Now let's look at what's needed on the Raspberry Pi side of things to control the Arduino.

<strong>Raspberry Pi Software:</strong>

The code discussed in this section is available in the <strong>Examples/AnalogIO</strong> directory of the <a href="https://github.com/MegaMosquito/darlingevil" rel="noopener" target="_blank">DarlingEvil git repo</a>.

Note that the Firmata software supports many <a href="https://github.com/firmata/arduino#firmata-client-libraries" rel="noopener" target="_blank">different language bindings</a> on the client side to use when controlling an Arduino (including Java, Go, Ruby, Python).  I chose the Python client to illustrate as an example here but the others are very similar to use.

Begin by connecting the USB-Serial adapter (with the Arduino and additional hardware attached) to one of the USB ports of the Raspberry Pi.

If you haven't already done so, you need to flash a Linux operating system onto your micro SD card and power up the Raspberry Pi.  <a href="https://www.raspberrypi.org/learning/hardware-guide/quickstart/" rel="noopener" target="_blank">Here are some instructions</a> for doing that.  If you are doing a <strong>headless</strong> (no monitor, keyboard, or mouse) setup, <a href="https://hackernoon.com/raspberry-pi-headless-install-462ccabd75d0" rel="noopener" target="_blank">here are some instructions</a> for that.

Once you have managed to get things set up, login (e.g., over <strong>ssh</strong>) to a Linux shelland change the default password:
<code>passwd</code>

In the linux shell, make sure basic Python development tools are installed:
<code>sudo apt-get install -y build-essential python-dev python-pip git</code>

Install the Python library that enables serial communication over USB
<code>sudo apt-get install -y python-serial</code>

Install "pyFirmata" (the Python client library for Firmata)
<code>git clone https://github.com/tino/pyFirmata
cd pyFirmata/
sudo python setup.py install</code>

You should now be able to control your Arduno from your Raspberry Pi using Python.

In your favorite text editor, open the <strong>AnalogIO.py</strong> example program in the <strong>Examples/AnalogIO</strong> directory of the <strong>git</strong> repo.  This program behaves exactly the same as the "<strong>AnalogIO.ino</strong>" program you ran earlier on the Arduino, but it is written in Python. More significantly, it runs on the Raspberry Pi (not on the Arduino).  The Arduino is running the <strong>Standard Firmata</strong> program and communicating back and forth with the Python client library that this example Python program uses.

