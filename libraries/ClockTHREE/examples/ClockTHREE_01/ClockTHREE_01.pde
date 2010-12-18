/*
  ClockTHREE Test10 english test
  Display time 12:12 PM in words: "ITS TEN PAST TWELVE NOON"

  Justin Shaw Dec 12, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0
 */

#include <avr/pgmspace.h>
#include <Wire.h>
#include <Time.h>
#include "ClockTHREE.h"
#include "SPI.h"
#include "english.h"

// globals
ClockTHREE c3 = ClockTHREE();
English lang = English();

uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));
time_t t;

void setup(){
  Wire.begin(); 

  c3.init();
  c3.setdisplay(display);
  c3.set_column_hold(50);

  setSyncProvider(getTime);  // PC, then RTC
  setSyncInterval(3600000);      // update hour (and on boot)
  pinMode(SPEAKER_PIN, OUTPUT);
  t = now();

  // display[1] = 0b11111111111111111111111111111111;
}

uint32_t count = 0;
uint8_t color_i = 1;
const int display_hold = 500;

void loop(){
  digitalWrite(SPEAKER_PIN, HIGH);
  lang.display_time(year(),
		    month(),
		    day(),
		    hour(),
		    minute(),
		    second(),
		    c3, BLUE, 32);
  c3.refresh(100);
}

// decimal to binary coded decimal
byte dec2bcd(int dec){
  byte t = dec / 10;
  byte o = dec - t * 10;
  return (t << 4) + o;
}

// binary coded decimal to decimal
int bcd2dec(byte bcd){
  return (((bcd & 0b11110000)>>4)*10 + 
    (bcd & 0b00001111));
}

/*
 * single front end interface to both PCgetTime and RTCgetTime()
 * Uses RTC if available or INT if not.
 * Updates time from PC if available
 */
time_t getTime(){
  boolean status;
  int ss, mm, hh, DD, MM, YY;

  // reused from macetech.com sample code
  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0); // start at register 0
  Wire.endTransmission();
  Wire.requestFrom(104, 7); // request six bytes (second, minute, hour, day, month, year)
  status = Wire.available();
  if(status){
    ss = bcd2dec(Wire.receive()); // get seconds
    mm = bcd2dec(Wire.receive()); // get minutes
    hh = bcd2dec(Wire.receive());   // get hours
    Wire.receive(); // day of week is discarded
    DD = bcd2dec(Wire.receive());   // get day
    MM = bcd2dec(Wire.receive());   // get month
    YY = bcd2dec(Wire.receive());   // get year
    /*
      Serial.print("Setting Time from RTC, YY:");
      Serial.print(YY);
      Serial.print(", status:");
      Serial.println(status, BIN);
    */
    setTime(hh, mm, ss, DD, MM, YY);
    // printTime(year(), month(), day(), hour(), minute(), second());
  }
  if(YY < 10){
    // Bad year, don't trust time.
    // Serial.println("not trusing RTC!");
    status = false;
  }
  return now();
}

