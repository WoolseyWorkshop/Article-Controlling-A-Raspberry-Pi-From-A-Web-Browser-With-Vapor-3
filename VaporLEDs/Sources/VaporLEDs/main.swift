// VaporLEDs - main.swift
//
// Description:
// A simple web server that lets you access and control LEDs via the web.
// Home page URL is http://raspberrypi.local:8080.
//
// GPIO:
// LEDs attached to GPIO16 (green), GPIO20 (yellow), and GPIO21 (red) pins.
//
// Created by John Woolsey on 12/16/2018.
// Copyright © 2018 Woolsey Workshop.  All rights reserved.


import Leaf
import Vapor
import SwiftyGPIO


// Vapor configuration
var config = Config.default()
config.prefer(LeafRenderer.self, for: ViewRenderer.self)
var environment = try Environment.detect()
var services = Services.default()
try services.register(LeafProvider())

// SwiftyGPIO configuration
let gpio = SwiftyGPIO.GPIOs(for: .RaspberryPi3)
guard let redLED = gpio[.P21] else {
   fatalError("Could not initialize redLED.")
}
guard let yellowLED = gpio[.P20] else {
   fatalError("Could not initialize yellowLED.")
}
guard let greenLED = gpio[.P16] else {
   fatalError("Could not initialize greenLED.")
}
redLED.direction = .OUT
yellowLED.direction = .OUT
greenLED.direction = .OUT


// Reset GPIO pins back to default states
func resetGPIO() {
   gpio[.P16]?.direction = .IN
   gpio[.P20]?.direction = .IN
   gpio[.P21]?.direction = .IN
   print("\nCompleted cleanup of GPIO resources.")
}


// Signal interrupt handler
signal(SIGINT) { signal in
   resetGPIO()
   exit(signal)
}


// Routes
let router = EngineRouter.default()
router.get { req -> Future<View> in  // home page
   return try req.view().render("home", [
      "redLEDState": redLED.value == 1 ? "ON" : "OFF",
      "redLEDColor": redLED.value == 1 ? "green" : "red",
      "yellowLEDState": yellowLED.value == 1 ? "ON" : "OFF",
      "yellowLEDColor": yellowLED.value == 1 ? "green" : "red",
      "greenLEDState": greenLED.value == 1 ? "ON" : "OFF",
      "greenLEDColor": greenLED.value == 1 ? "green" : "red"
   ])
}
router.get("redLED", String.parameter) { req -> Response in  // redLED
   let command = try req.parameters.next(String.self)
   switch command {
   case "on":
      redLED.value = 1
   default:
      redLED.value = 0
   }
   return req.redirect(to: "/")
}
router.get("yellowLED", String.parameter) { req -> Response in  // yellowLED
   let command = try req.parameters.next(String.self)
   switch command {
   case "on":
      yellowLED.value = 1
   default:
      yellowLED.value = 0
   }
   return req.redirect(to: "/")
}
router.get("greenLED", String.parameter) { req -> Response in  // greenLED
   let command = try req.parameters.next(String.self)
   switch command {
   case "on":
      greenLED.value = 1
   default:
      greenLED.value = 0
   }
   return req.redirect(to: "/")
}
services.register(router, as: Router.self)

// Main section
print("Press CTRL-C to exit.")
try Application(config: config, environment: environment, services: services).run()
