/*
  ClockTHREE Test09 RTC
  scroll time from rtcBOB using font library

  Justin Shaw Dec 11, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0
 */

#include <Time.h>
#include <Wire.h>
#include "rtcBOB.h"
#include "SPI.h"
#include "font.h"
#include "english.h"
#include "EEPROM.h"
#include "MsTimer2.h"

const char RESET_BYTE = 'R';

void setup(){
  // start comm protos
  Serial.begin(57600); // for debugging
  Wire.begin();

  setSyncProvider(getTime);      // RTC
  setSyncInterval(60000);      // update every minute (and on boot)
  Serial.print("Type ");
  Serial.print(RESET_BYTE);
  Serial.println(" to reset time to 2016/6/17 09:10:11");
}

uint32_t count = 0;
void resettime(){
  setRTC(2016, 6, 17, 
	 9, 10, 11);
  Serial.println("Time reset time to 2016/6/17 09:10:11");
  Serial.println("Disconnect power and reconnect.");
  Serial.println("Displayed time should be a few seconds later.");
  Serial.println("");
  Serial.println("This tests RTC reading, writing, and back up battery");
  delay(5000);
}
void interact(){
  if(Serial.available()){
    if(Serial.read() == RESET_BYTE){
      resettime();
    }
  }
}

void loop(){
  uint8_t ahh, amm, ass, is_set = count % 2;
  int ones, tens, dec_val, bcd_val;
  for(int tens = 0; tens < 10; tens++){
    for(int ones = 0; ones < 10; ones++){
      bcd_val = tens << 4 | ones; 
      dec_val = 10 * tens + ones;
      if(dec2bcd(dec_val) != bcd_val){
	Serial.print("dec2bcd broken: ");
	Serial.print(dec2bcd(dec_val), BIN);
	Serial.print("!=");
	Serial.print(bcd_val, BIN);
	done();
      }
      if(bcd2dec(bcd_val) != dec_val){
	Serial.print("bcd2dec broken: ");
	Serial.print(bcd2dec(bcd_val), DEC);
	Serial.print("!=");
	Serial.print(dec_val, DEC);
	done();
      }
    }
  }
  Serial.println("Verify that time = alarm time");
  for(int i = 0; i < 60; i++){
    is_set = i % 2;
    interact();
    Serial.print("rtc time:");
    Serial.print(getTime());
    Serial.print(" =? Arduino time:");
    Serial.print(year());
    Serial.print("/");
    Serial.print(month());
    Serial.print("/");
    Serial.print(day());
    Serial.print(" ");
    print_time(hour(), minute(), second());
    Serial.print(" ");
    Serial.print(is_set, DEC);
    Serial.print(" =? alarm time:");
    setRTC_alarm(hour(), minute(), second(), is_set);
    getRTC_alarm(&ahh, &amm, &ass, &is_set);
    print_time(ahh, amm, ass);
    Serial.print(" ");
    Serial.println(is_set, DEC);

    delay(1000);
    count++;
  }
  
  Serial.print("Type ");
  Serial.print(RESET_BYTE);
  Serial.println(" to reset time to 2016/6/17 09:10:11");
  while(1){
    interact();
    delay(100);
  }
  done();
}
void print_time(uint8_t hh, uint8_t mm, uint8_t ss){
  two_digits(hh);
  Serial.print(":");
  two_digits(mm);
  Serial.print(":");
  two_digits(ss);
}
void two_digits(uint8_t val){
  Serial.print(val/10, DEC);
  Serial.print(val%10, DEC);
}

void done(){
  Serial.println("");
  Serial.println("DONE!");
  while(1){
    delay(1000);
  }
}
