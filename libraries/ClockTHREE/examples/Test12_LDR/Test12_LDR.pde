/*
  ClockTHREE Test12 LDR test
  blink LED based on LDR value

  Original source _Getting_Started_With_Arduino_ p. 64.
  Modified by Justin Shaw Dec 14, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0 Unported
 */

#include "ClockTHREE.h"
#include "SPI.h"

// Example 06A: Blink LED at a rate specified by the
// value of the analogue input

 // the pin for the LED
int val;
// variable used to store the value
// coming from the sensor
void setup() {
  Serial.begin(9600);
  pinMode(DBG, OUTPUT); // LED is as an OUTPUT
  // Note: Analogue pins are
  // automatically set as inputs
}
void loop() {
  val = analogRead(LDR_PIN); // read the value from
  Serial.println(val);
  // the sensor
  digitalWrite(DBG, HIGH); // turn the LED on
  delay(val); // stop the program for
  // some time
  digitalWrite(DBG, LOW); // turn the LED off
  delay(val); // stop the program for
  // some time
}

