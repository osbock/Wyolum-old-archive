/*
 p.u.l.s.e. Fader for Motorcycle Lamp
 
When NeutralDetect is HIGH, Lamp fades via PWM,
When NeutralDetect is LOW, Lamp is 100% ON
 
 The circuit:
 * LED attached from digital pin 3 (ATMega) 0r pin 0 (ATTiny) to ground.
 * NeutralDetect Switch to digital pin 4.
 
 Created 23 Jun 2012
 By Anool J Mahidharia
 modified 
 By 
 
 This code is in the public domain. 
 */

int NeutralDetect = 4;    // NeutralDetect signal to digital pin 4 (ATMega or ATTiny)
//comment out below line depending on use of ATMega or ATTiny
int ledPin = 3;    // LED connected to digital pin 3 (ATMega)
//int ledPin = 0;    // LED connected to digital pin 0 (ATTiny)

void setup()
{ 
    pinMode(NeutralDetect, INPUT);
} 

void loop()
{
    // read the value of the NeutralDetect pin:
  int NDValue = digitalRead(NeutralDetect);
  
    // if the digital value is high , PWM the LED:
  if (NDValue == HIGH)
 {
  // fade in from min to max in increments:
  for(int fadeValue = 0 ; fadeValue <= 255; fadeValue +=5)
    {
    // sets the value (range from 0 to 255):
    analogWrite(ledPin, fadeValue);         
    // wait for milliseconds to see the dimming effect    
    delay(35);                            
    }

  // fade out from max to min in increments:
  for(int fadeValue = 255 ; fadeValue >= 0; fadeValue -=5)
    {
    // sets the value (range from 255 to 0):
    analogWrite(ledPin, fadeValue);
    // wait for milliseconds to see the dimming effect    
    delay(35);
    }
 }
    else
    {
    digitalWrite(ledPin,HIGH);
    }
}
