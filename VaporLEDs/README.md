# VaporLEDs
A Swift Package Manager project that implements a simple web server that lets you access and control LEDs via the web using the Vapor, Leaf, and SwiftyGPIO libraries on a Raspberry Pi.

## GPIO
LED circuits attached to GPIO16 (green), GPIO20 (yellow), and GPIO21 (red) pins.

## Routes
http://raspberrypi.local:8080 - Home page (control panel)

http://raspberrypi.local:8080/redLED/on - Turn on red LED

http://raspberrypi.local:8080/redLED/off - Turn off red LED

http://raspberrypi.local:8080/yellowLED/on - Turn on yellow LED

http://raspberrypi.local:8080/yellowLED/off - Turn off yellow LED

http://raspberrypi.local:8080/greenLED/on - Turn on green LED

http://raspberrypi.local:8080/greenLED/off - Turn off green LED

## Fetch Libraries
% swift package update

## Compile
% swift build

## Run
% swift run VaporLEDs --hostname raspberrypi.local --port 8080

## Exit
CTRL-C
