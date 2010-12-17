/*
  ClockTHREE Test09 RTC
  scroll time from rtcBOB using font library

  Justin Shaw Dec 11, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0
 */

#include <avr/pgmspace.h>
#include <Time.h>
#include <Wire.h>
#include "ClockTHREE.h"
#include "SPI.h"
#include "font.h"
#include "english.h"

// time sync to PC is HEADER followed by unix time_t as ten ascii digits
#define TIME_MSG_LEN  10   
#define TIME_HEADER  '$'   // Header tag for serial time sync message
#define TIME_REQ '%'
#define VERSION_REQ '^'    // Header tag for software version
#define PC_TIME  1
#define RTC_TIME 2
#define AVR_TIME 3

// globals
char msg[100];
uint32_t word32[20 * 8]; // holds 20 chars
uint8_t time_source = AVR_TIME;
English lang = English();

ClockTHREE c3 = ClockTHREE();
Font font = Font();
uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));
const byte OnePins[3] = {
  9, 10, 11};

void setup(){
  // start Wire proto
  Wire.begin();
  // Serial.begin(9600); // for debugging

  setCompileTime();          // default initial time
  setSyncProvider(getTime);  // PC, then RTC
  setSyncInterval(3600000);      // update hour (and on boot)

  c3.init();
  c3.setdisplay(display);
  c3.set_column_hold(20);
  pinMode(10, OUTPUT);
  analogWrite(10, 0);
  displaytime();

  pinMode(COL_DRIVER_ENABLE, OUTPUT); // ClockTWO Hack
}

uint32_t count = 0;
uint8_t color_i = 1;
const int display_hold = 200;
int myx = 0;

void loop(){
  uint8_t c;
  int n = strlen(msg);
  // Serial.println("in loop(), getting time");
  // getTime();
  // delay(1000);
  if(count % 8 == 0){
    char c = msg[(count / 8) % n];
    font.getChar(c, COLORS[color_i], display + N_COL);
    
    if((count / 8) % n == n - 1){
      displaytime();
      color_i = (color_i + 1) % (N_COLOR - 1) + 1;
    }
  }
  for(int i = 0; i < N_COL + 7; i++){
    // make room for new column
    display[i] = display[i + 1];
  }
  count++;
  c3.refresh(display_hold);
}

void setCompileTime(){
  char *date = __DATE__;
  char *tm   = __TIME__;
  byte i;
  int yyyy = 0;
  int hh = 0;
  int mm = 0;
  int ss = 0;
  int dd = 0;
  for(i = 0; i<4; i++){
    yyyy = (10 * yyyy) + (date[7 + i] - '0');
  }
  for(i = 0; i < 2; i++){
    hh = (10 * hh) + (tm[0 + i] - '0');
    mm = (10 * mm) + (tm[3 + i] - '0');
    ss = (10 * ss) + (tm[6 + i] - '0');
    dd = (10 * dd) + (date[4 + i] - '0');
  }

  long mmm = (date[0] - 'A') * (26 * 26) + 
    (date[1] - 'a') * 26 + 
    date[2] - 'a';
  switch (mmm) {
  case 6097:
    mmm = 1;
    break;
  case 3485:
    mmm = 2;
    break;
  case 8129:
    mmm = 3;
    break;
  case 407:
    mmm = 4;
    break;
  case 8136:
    mmm = 5;
    break;
  case 6617:
    mmm = 6;
    break;
  case 6615:
    mmm = 7;
    break;
  case 526:
    mmm = 8;
    break;
  case 12287:
    mmm = 9;
    break;
  case 9535:
    mmm = 10;
    break;
  case 9173:
    mmm = 11;
    break;
  case 2134:
    mmm = 12;
    break;
  default:
    mmm = 1;
    break;
  }
  /*
Jan 6097
   Feb 3485
   Mar 8129
   Apr 407
   May 8136
   Jun 6617
   Jul 6615
   Aug 526
   Sep 12287
   Oct 9535
   Nov 9173
   Dec 2134
   */

  setTime(hh, mm, ss, dd, mmm, yyyy);
}

void SWversion(void) {
  //delay(2000);
  Serial.println();
  Serial.println("ClockTHREE -Arduino v0.1");
  Serial.println("(c) 2010 Justin Shaw");
  Serial.print("Compiled on:");
  Serial.print(__DATE__);
  Serial.print(" ");
  Serial.println(__TIME__);
}

void printTime(int year, int month, int day, int hour, int minute, int second){
  Serial.print(year);
  Serial.print("/");
  Serial.print(month);
  Serial.print("/");
  Serial.print(day);
  Serial.print(" ");
  Serial.print(hour);
  Serial.print(":");
  if(minute < 10){
    Serial.print("0");
  }
  Serial.print(minute);
  Serial.print(":");
  if(second < 10){
    Serial.print("0");
  }
  Serial.println(second);
}

boolean PCgetTime(){
  char header;

  boolean status = false;
  while(Serial.available() > 0){
    header = Serial.read();

    // service incoming requests
    if(header == TIME_REQ){
      Serial.println(msg);
      printTime(year(), month(), day(), hour(), minute(), second());
    }
    if(header == VERSION_REQ){
      SWversion();
    }
    // if time sync available from serial port, update time and return true
    // time message consists of a header and ten ascii digits
    else if(header == TIME_HEADER) {  
      time_t pctime = 0;
      status = true; // looks like the start of a time message
      delay(10); // wait for rest of message
      for(int i = 0; i < TIME_MSG_LEN; i++){   
        if(Serial.available()){
          char c= Serial.read();          
          if( c >= '0' && c <= '9'){   
            pctime = (10 * pctime) + (c - '0') ; // convert digits to a number    
          }
          else{
            // nope, did not get valid time message
            status = false;
            break;
          }
        }
        else{
          status = false;
        }
      }
      if(status){
        Serial.println(pctime);
        setTime(pctime);   // Sync Arduino clock to the time received on the serial port
        Serial.print("PC Time:");
        printTime(year(), month(), day(), hour(), minute(), second());
        set_rtc();     // update RTC if available
        Serial.print("ARDUINO Time:");
        printTime(year(), month(), day(), hour(), minute(), second());
        status = true;
      }
    }  
  }
  return status;  //if no message return false
}

// get time from RTC
int bcd2dec(byte bcd){
  return (((bcd & 0b11110000)>>4)*10 + 
    (bcd & 0b00001111));
}
boolean RTCgetTime(){
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
    printTime(year(), month(), day(), hour(), minute(), second());
  }
  if(YY < 10){
    // Bad year, don't trust time.
    // Serial.println("not trusing RTC!");
    status = false;
  }
  return status;
}

// get current temperature
void RTCgetTemp(){
  boolean status;
  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0x11); // start at register 0x11
  Wire.endTransmission();
  Wire.requestFrom(104, 2); // request six bytes (second, minute, hour, day, month, year)
  status = Wire.available();
  if(status){
    Serial.print(Wire.receive(), BIN);
    Serial.print(" ");
    Serial.println(Wire.receive()>>6, BIN);
  }
}
/*
 * single front end interface to both PCgetTime and RTCgetTime()
 * Uses RTC if available or INT if not.
 * Updates time from PC if available
 */
time_t getTime(){
  // Serial.println('getTime()');
  if(PCgetTime()){
    time_source = PC_TIME;
  }
  else if(RTCgetTime()){
    time_source = RTC_TIME;
    // Serial.println('    Using RTC time');
  }
  else{
    time_source = AVR_TIME;
    // Serial.println("   Compile Time");
    setCompileTime(); // 0, 0, 0, 1, 1, 2010);
    setSyncProvider(0); // clear time provider
    setSyncInterval(31536000); // 10 years!
  }
  return now();
}

void set_rtc(){
  RTCsetTime(hour(), minute(), second(), day(), month(), year());
}

byte dec2bcd(int dec){
  byte t = dec / 10;
  byte o = dec - t * 10;
  return (t << 4) + o;
}
void RTCsetTime(byte hourIn, byte minuteIn, byte secondIn, byte dayIn, byte monthIn, int yearIn){
  Wire.beginTransmission(104); // 104 is DS3231 device address
  Wire.send(0); // start at register 0

    Wire.send(dec2bcd(secondIn)); //Send seconds as BCD
  Wire.send(dec2bcd(minuteIn)); //Send minutes as BCD
  Wire.send(dec2bcd(hourIn)); //Send hours as BCD
  Wire.send(dec2bcd(weekday())); // dow
  Wire.send(dec2bcd(dayIn)); //Send day as BCD
  Wire.send(dec2bcd(monthIn)); //Send month as BCD
  Wire.send(dec2bcd(yearIn % 1000)); //Send year as BCD
  Wire.endTransmission();  

}

int append_msg(char *msg, char *end, int index){
  byte i;
  for(i = 0; end[i] > 0; i++){
    msg[index++] = end[i];
  }
  return index;
}

char* displaytime(void){
  byte msg_index = 0;

  // msg_index = append_msg(msg, "It's ", msg_index);  

  // now we display the appropriate minute counter
  if ((minute()>4) && (minute()<10)) { 
    msg_index = append_msg(msg, "Five ", msg_index);
  } 
  if ((minute()>9) &&(minute()<15)) { 
    msg_index = append_msg(msg, "Ten ", msg_index);
  }
  if ((minute()>14) && (minute()<20)) {
    msg_index = append_msg(msg, "Quarter ", msg_index);
  }
  if ((minute()>19) && (minute()<25)) { 
    msg_index = append_msg(msg, "Twenty ", msg_index);
  }
  if ((minute()>24) && (minute()<30)) { 
    msg_index = append_msg(msg, "Twenty-Five ", msg_index);
  }  
  if ((minute()>29) && (minute()<35)) {
    msg_index = append_msg(msg, "Half ", msg_index);
  }
  if ((minute()>34) && (minute()<40)) { 
    msg_index = append_msg(msg, "Twenty-Five ", msg_index);
  }  
  if ((minute()>39) && (minute()<45)) { 
    msg_index = append_msg(msg, "Twenty ", msg_index);
  }
  if ((minute()>44) && (minute()<50)) {
    msg_index = append_msg(msg, "Quarter ", msg_index);

  }
  if ((minute()>49) && (minute()<55)) { 
    msg_index = append_msg(msg, "Ten ", msg_index);
  } 
  if (minute()>54) { 
    msg_index = append_msg(msg, "Five ", msg_index);
  }

  if ((minute() <5))
  {
    switch (hour() % 12) {
    case 1: 
      msg_index = append_msg(msg, "One ", msg_index);
      break;
    case 2: 
      msg_index = append_msg(msg, "Two ", msg_index);
      break;
    case 3: 
      msg_index = append_msg(msg, "Three ", msg_index);
      break;
    case 4: 
      msg_index = append_msg(msg, "Four ", msg_index);
      break;
    case 5: 
      msg_index = append_msg(msg, "Five ", msg_index);
      break;
    case 6: 
      msg_index = append_msg(msg, "Six ", msg_index);
      break;
    case 7: 
      msg_index = append_msg(msg, "Seven ", msg_index);
      break;
    case 8: 
      msg_index = append_msg(msg, "Eight ", msg_index);
      break;
    case 9: 
      msg_index = append_msg(msg, "Nine ", msg_index);
      break;
    case 10: 
      msg_index = append_msg(msg, "Ten ", msg_index);
      break;
    case 11: 
      msg_index = append_msg(msg, "Eleven ", msg_index);
      break;
    case 0: 
      msg_index = append_msg(msg, "Twelve ", msg_index);
      break;
    }
    // msg_index = append_msg(msg, "O'Clock ", msg_index);
  }
  else
    if ((minute() < 35) && (minute() >4))
    {
      msg_index = append_msg(msg, "Past ", msg_index);
      switch (hour() % 12) {
      case 1: 
        msg_index = append_msg(msg, "One ", msg_index);
        break;
      case 2: 
        msg_index = append_msg(msg, "Two ", msg_index);
        break;
      case 3: 
        msg_index = append_msg(msg, "Three ", msg_index);
        break;
      case 4: 
        msg_index = append_msg(msg, "Four ", msg_index);
        break;
      case 5: 
        msg_index = append_msg(msg, "Five ", msg_index);
        break;
      case 6: 
        msg_index = append_msg(msg, "Six ", msg_index);
        break;
      case 7: 
        msg_index = append_msg(msg, "Seven ", msg_index);
        break;
      case 8: 
        msg_index = append_msg(msg, "Eight ", msg_index);
        break;
      case 9: 
        msg_index = append_msg(msg, "Nine ", msg_index);
        break;
      case 10: 
        msg_index = append_msg(msg, "Ten ", msg_index);
        break;
      case 11: 
        msg_index = append_msg(msg, "Eleven ", msg_index);
        break;
      case 0: 
        msg_index = append_msg(msg, "Twelve ", msg_index);
        break;
      }
    }
    else
    {
      // if we are greater than 34 minutes past the hour then display
      // the next hour, as we will be displaying a 'to' sign
      msg_index = append_msg(msg, "To ", msg_index);
      switch (hour() % 12) {
      case 1: 
        msg_index = append_msg(msg, "Two ", msg_index);
        break;
      case 2: 
        msg_index = append_msg(msg, "Three ", msg_index);
        break;
      case 3: 
        msg_index = append_msg(msg, "Four ", msg_index);
        break;
      case 4: 
        msg_index = append_msg(msg, "Five ", msg_index);
        break;
      case 5: 
        msg_index = append_msg(msg, "Six ", msg_index);
        break;
      case 6: 
        msg_index = append_msg(msg, "Seven ", msg_index);
        break;
      case 7: 
        msg_index = append_msg(msg, "Eight ", msg_index);
        break;
      case 8: 
        msg_index = append_msg(msg, "Nine ", msg_index);
        break;
      case 9: 
        msg_index = append_msg(msg, "Ten ", msg_index);
        break;
      case 10: 
        msg_index = append_msg(msg, "Eleven ", msg_index);
        break;
      case 11: 
        msg_index = append_msg(msg, "Twelve ", msg_index);
        break;
      case 0: 
        msg_index = append_msg(msg, "One ", msg_index);
        break;
      }
    }
  switch(minute() % 5){
  case 0:
    digitalWrite(OnePins[0], LOW);
    digitalWrite(OnePins[1], LOW);
    digitalWrite(OnePins[2], LOW);
    break;
  case 1:
    digitalWrite(OnePins[0], HIGH);
    digitalWrite(OnePins[1], LOW);
    digitalWrite(OnePins[2], LOW);
    break;
  case 2:
    digitalWrite(OnePins[0], HIGH);
    digitalWrite(OnePins[1], HIGH);
    digitalWrite(OnePins[2], LOW);
    break;
  case 3:
    digitalWrite(OnePins[0], LOW);
    digitalWrite(OnePins[1], HIGH);
    digitalWrite(OnePins[2], HIGH);
    break;
  case 4:
    digitalWrite(OnePins[0], LOW);
    digitalWrite(OnePins[1], LOW);
    digitalWrite(OnePins[2], HIGH);
    break;
  }
  if(time_source == PC_TIME){
    msg_index = append_msg(msg, "PC ", msg_index);
  }
  if(time_source == RTC_TIME){
    msg_index = append_msg(msg, "RTC ", msg_index);
  }
  if(time_source == AVR_TIME){
    msg_index = append_msg(msg, "AVR ", msg_index);
  }
  msg[msg_index++] = ' ';
  msg[msg_index++] = ' ';
  msg[msg_index++] = '\0';
  return msg;
}

