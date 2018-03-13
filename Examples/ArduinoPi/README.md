# Analog versus Digital

The world is an analog place, but the Raspberry Pi is not very capable when it
comes to performing analog input and output.  Although the Raspberry Pi has many
GPIO (General Purpose Input-Output) pins, they are all designed for *digital*
input and output.  Only one of those pins supports PWM (Pulse Wave Modulation)
in hardware to enable simulated analog output, and none of them support analog
input.  On the other hand, the raspberry Pi computers are quite powerful for their size.  The Raspberry Pi 2 Model B, for example, runs at 1GHz, has 1GB RAM, and supports flash up to 64GB).  The Raspberry Pi also easily supports a wide range of powerful peripherals.

In contrast, most Arduino boards have many *analog* input GPIOs (often 8)
and a similar number of GPIOs with hardware support for PWM.  So the Arduino
boards are generally superior to the Raspberry Pi for interfacing with analog
hardware components like simple sensors.  On the other hand, the Arduino boards
are grossly underpowered (typically 8MHz-16MHz, 2KB RAM, 32KB flash) compared with
the Raspberry Pi, and standard computer peripherals simply cannot be attached to most Arduinos.

# Best of both worlds

How can you get the processing power, and peripheral devices, of a Raspberry
Pi while also being able to perform analog input and output easily?  Simple!
Connect an Arduino to your Raspberry Pi.

# Details

This directory contains example code to set up an Arduino microcontroller
as a slave of a Raspberry Pi such that you can write code on the Raspberry Pi
to control (i.e., read from and write to) the GPIO (General Purpose Input-Output)
pins on the Arduino.  On the Arduino you simply run an open source “Firmata” driver (i.e., no Arduino coding is required with this approach).  On the Raspberry Pi you can program in any one of a dozen or more languages for which Firmata has provided client bindings.

The [darlingevil.com website](https://darlingevil.com/electronics-arduino-raspberry-pi/) details all of the steps needed to get this up and running.

# Files

The files in this directory include:
* AnalogIO.fzz    Fritzing source, sed to make the the circuit diagram
* AnalogIO.ino    Hardware test program you can optionally run on the Arduino
* AnalogIO.py     Example program to do the hardware test from the Raspberry Pi


