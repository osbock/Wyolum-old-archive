#include "rtcBOB.h"
#include "Wire.h"

/*
 * single front end interface to both PCgetTime and RTCgetTime()
 * Uses RTC if available or INT if not.
 * Updates time from PC if available
 */
time_t getTime(){
  int ss, mm, hh, DD, MM, YY;
  
  // reused from macetech.com sample code
  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0); // start at register 0
  Wire.endTransmission();
  Wire.requestFrom(104, 7); // request six bytes (second, minute, hour, day, month, year)
  if(Wire.available()){
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
  }
  return now();
}

void setRTC(uint16_t YY, uint8_t MM, uint8_t DD, 
	    uint8_t hh, uint8_t mm, uint8_t ss){
  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0); // start at register 0
  
  Wire.send(dec2bcd(ss)); //Send seconds as BCD
  Wire.send(dec2bcd(mm)); //Send minutes as BCD
  Wire.send(dec2bcd(hh)); //Send hours as BCD
  Wire.send(dec2bcd(weekday())); // dow
  Wire.send(dec2bcd(DD)); //Send day as BCD
  Wire.send(dec2bcd(MM)); //Send month as BCD
  Wire.send(dec2bcd(YY % 1000)); //Send year as BCD
  Wire.endTransmission();  

}

void setRTC_alarm(uint8_t ahh, uint8_t amm, uint8_t ass, uint8_t alarm_set, uint8_t temp_unit){
  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0x7); // start at register 0
  
  Wire.send(dec2bcd(ass)); //Send seconds as BCD
  Wire.send(dec2bcd(amm)); //Send minutes as BCD
  Wire.send(dec2bcd(ahh)); //Send hours as BCD
  Wire.send(((temp_uint & 1) << 6) || ((alarm_set & 1) << 7)); // use A1M4 as alarm_set bit, DY/_DT as temp_unit bit
  Wire.endTransmission();  

}

void getRTC_alarm(uint8_t *ahh, uint8_t *amm, uint8_t *ass, uint8_t *alarm_set, uint8_t *temp_unit){
  uint8_t x;

  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0x7); // start at register 0x7
  Wire.endTransmission();
  Wire.requestFrom(104, 4); // request 3 bytes 
  if(Wire.available()){
    *ass = bcd2dec(Wire.receive());
    *amm = bcd2dec(Wire.receive());
    *ahh = bcd2dec(Wire.receive());
    x = Wire.receive();
    *alarm_set = (x >> 7) & 1; // use A1M4 as set bit
    *temp_unit = (x >> 6) & 1; // use DY/_DT as temp_unit bit
  }
  else{
    *ass = 0;
    *amm = 0;
    *ahh = 0;
  }
}

// get current temperature
int getTemp(){
  int temp;
  int temp_c;
  
  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0x11); // start at register 0x11
  Wire.endTransmission();
  Wire.requestFrom(104, 2); // request 2 bytes 
  if(Wire.available()){
    uint8_t tmp[0];
    tmp[0] = Wire.receive();
    tmp[1] = Wire.receive();
    temp = (int)(tmp[0] << 5);
    temp |= (int)(tmp[1] >> 3); // will not work for negative temps (celcius)
    temp_c = .03125 * temp;
  }
  else{
    temp_c = 99;
  }
  return temp_c;
}
// conversion routines
int toF(int C){
  return C * 9./5 + 32;
}
int toC(int F){
  return (F  - 32)* 5./9;
}

// decimal to binary coded decimal
uint8_t dec2bcd(int dec){
  uint8_t t = dec / 10;
  uint8_t o = dec - t * 10;
  return (t << 4) + o;
}

// binary coded decimal to decimal
int bcd2dec(uint8_t bcd){
  return (((bcd & 0b11110000)>>4)*10 + 
    (bcd & 0b00001111));
}

