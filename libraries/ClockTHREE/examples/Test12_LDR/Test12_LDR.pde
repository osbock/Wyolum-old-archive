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
ClockTHREE c3 = ClockTHREE();

void setup() {
  c3.init();

  pinMode(DBG, OUTPUT); // LED is as an OUTPUT
  // Note: Analogue pins are
  // automatically set as inputs
}
void loop() {
  val = (analogRead(LDR_PIN) - 800) * 10; // read the value from
  digitalWrite(DBG, HIGH); // turn the LED on
  delay(val); // stop the program for

  // really anoying sounds based on LDR value
  // tone(SPEAKER_PIN, val * 2);
  // return;

  val = (analogRead(LDR_PIN) - 900) * 10; // read the value from
  digitalWrite(DBG, LOW); // turn the LED off
  delay(val); // stop the program for
  c3.refresh();

}

