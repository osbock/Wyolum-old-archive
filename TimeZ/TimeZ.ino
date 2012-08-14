#include <avr/pgmspace.h>
#include "rtcBOB.h"
#include "Time.h"
#include "Wire.h"
#include "SD.h"

#include "Arduino.h"
#define WIRE_READ Wire.read();
#include "SoftwareSerial.h"

#include <TinyGPS.h>

#define DEFINED

volatile unsigned long count = 0;
volatile unsigned long pps_start_us = 0;
volatile unsigned long pps_tick_us = 1000000;  // filtered (unused)
volatile unsigned long _pps_tick_us = 1000000; // unfiltered
volatile float lat = 1000; // default to bad lat
volatile float lon = 1000; // default to bad lon

volatile unsigned long rtc_start_us = 0;          
volatile unsigned long rtc_tick_us = 1000000;  // filtered (unused)
volatile unsigned long _rtc_tick_us = 1000000; // unfiltered (unused)
int rtc_set_hour = -1;
bool dst_flag;

unsigned long sync_time = 0;     // seconds of last GPS 1pps sync
unsigned long last_set_time = 0; // seconds of last GPS time set
int16_t tz_offset_st = 0;
int16_t tz_offset_dst = 0;
// ClockTHREE c3;                      // ClockTHREE singleton

// drift = actual_us - desired_us
// drift > 0 ==> pulse is late
// drift < 0 ==> pulse is early
volatile          long rtc_drift_us;          // Filtered


volatile boolean pps_led_state = true;
volatile boolean sqw_led_state = true;
volatile boolean synced = false;

const int SQW_PIN = 3;
const int PPS_PIN = 2;
const int  PPS_LED = 7; 
const int  SQW_LED = 4;
const unsigned int RTC_STALE_S = 1800;
const unsigned int RTC_SECOND_STALE_S = 1000 * 3600;// 1000 hours
const unsigned long  RTC_WRITE_US = 750;
const unsigned long OFFSET_US = 1000; // uS offset of 1HZ rel to 1PPS
const uint8_t chipSelect = 10;
const uint8_t MY_ADDR = 121;

TinyGPS gps;
SoftwareSerial sws(6, A7);

void ERROR_OUT(uint8_t n_blink){
  detachInterrupt(0);
  detachInterrupt(1);
  while(1){
    for(int i=0; i < n_blink; i++){
      digitalWrite(SQW_LED, HIGH);
      delay(100);
      digitalWrite(SQW_LED, LOW);
      delay(100);
    }
    delay(500);
  }
}

void pps_interrupt(){
  unsigned long  now_us = micros();
  _pps_tick_us = (now_us - pps_start_us);
  // TODO: Nix led?
  pps_led_state = !pps_led_state;
  digitalWrite(PPS_LED, pps_led_state);
  pps_start_us = now_us;
}

void rtc_interrupt(){
  unsigned long  now_us = micros();
  long drift_us;
  sqw_led_state = !sqw_led_state;
  // digitalWrite(SQW_LED, sqw_led_state);
  rtc_start_us = now_us;
}

// write 4 bytes of in into char buffer out.
void Time_to_Serial(time_t in, char *out){
  time_t *out_p = (time_t *)out;
  *out_p = in;
}

time_t Serial_to_time(char *in){
  time_t out;
  out = *(time_t *)in;
  return out;
}

void setup(){
  delay(100); // wait for ClockTHREE to start up first.
  sws.begin(9600);
  Serial.begin(115200);
  Serial.println("TimeZ v1.0");
  Serial.println("Copyright WyoLum, LLC, 2012");

  Wire.begin(MY_ADDR);

  // From MaceTech.com: set 1Hz reference square wave
  Wire.beginTransmission(0x68); // address DS3231
  WIRE_WRITE1(0x0E); // select register
  WIRE_WRITE1(0b00000000); // write register bitmap, bit 7 is /EOSC
  Wire.endTransmission();
  
  pinMode(PPS_LED, OUTPUT);
  pinMode(SQW_LED, OUTPUT);
  pinMode(PPS_PIN, INPUT);
  pinMode(SQW_PIN, INPUT);

  digitalWrite(PPS_LED, HIGH);
  digitalWrite(SQW_LED, HIGH);

  delay(100);
  digitalWrite(PPS_LED, LOW);
  digitalWrite(SQW_LED, LOW);
  // setRTC(2010, 1, 1, 0, 0, 0); // TODO: DELETE THIS LINE!
  set_1Hz_ref(getTime(), SQW_PIN, rtc_interrupt, FALLING);

  while(rtc_start_us == 0){
    delay(100);
  }
  attachInterrupt(PPS_PIN - 2, pps_interrupt, RISING);

  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
   pinMode(chipSelect, OUTPUT);
  if (!SD.begin(chipSelect)) {
    ERROR_OUT(4);
  }
}

/*
 * read and return a 2 byte singed integer from current location in myFile
 */
int readshort(File myFile){
  int16_t out;
  char *dat = (char*)&out;
  for(uint8_t i=0; i < 2; i++){
    dat[i] = myFile.read();
  }
  return out;
}
/*
 * write a 2 byte singed integer stored in val to current location in myFile
 */
void writeshort(File myFile, int16_t val){
  char *dat = (char*)&val;
  for(uint8_t i=0; i < 2; i++){
    myFile.write(dat[i]);
  }
}

/*
 * read and return a 4 byte time_t from current location in myFile
 */
time_t readtime(File myFile){
  time_t out;
  char *dat = (char*)&out;
  for(uint8_t i=0; i < 4; i++){
    dat[i] = myFile.read();
  }
  return out;
}
/*
 * write a 4 byte time_t (val) to current location in myFile
 */
void writetime(File myFile, time_t val){
  char *dat = (char*)&val;
  for(uint8_t i=0; i < 4; i++){
    myFile.write(dat[i]);
  }
}

/*
 * read and return a double from current location in myFile
 */
time_t readdouble(File myFile){
  double out;
  char *dat = (char*)&out;
  for(uint8_t i=0; i < 4; i++){
    dat[i] = myFile.read();
  }
  return out;
}
/*
 * write a double (val) to current location in myFile
 */
void writedouble(File myFile, double val){
  char *dat = (char*)&val;
  for(uint8_t i=0; i < 4; i++){
    myFile.write(dat[i]);
  }
}

const int RECLEN = 38; // Record length for GMT offset files.
/* 
   return signed offset from GMT in minutes
   LAT FILE FORMAT:
   3600 Longitude records per file
   38 (RECLEN) bytes per record stored in order from 0 to 360 degress longitude
   Each record:
   TZ_NAME: 30 Bytes,
   lat: signed short (h)
   lon * 10 % 3600: signed short (h)
   standard_offset: signed short (h)
   daylight_savings_offset: signed short (h)
 */
int gmt_offset(float lat, float lon, int16_t *st_p, int16_t *dst_p){
  File latfile;
  while(lon < 0){
    lon += 360;
  }
  uint32_t lon10 = (uint32_t)round(lon * 10) % 3600;
  int ilat = (int)round(lat);
  char filename[8];
  int offset;

  filename[7] = NULL;
  uint8_t tens, ones;
  if(ilat < 0){
    filename[2] = 'S';
    ilat = (int)abs(ilat);
  }
  else{
    filename[2] = 'N';
  }
  tens = ilat / 10;
  ones = ilat % 10;
  filename[0] = '0' + tens;
  filename[1] = '0' + ones;
  filename[3] = '.';
  filename[4] = 'B';
  filename[5] = 'I';
  filename[6] = 'N';
  latfile = SD.open(filename, FILE_READ);
  if(latfile){
    offset = latfile.seek(lon10 * RECLEN + 34L);
    *st_p = readshort(latfile) * 60;
    *dst_p = readshort(latfile) * 60;
  }
  latfile.close();
}
/*
 * return true if current time t is in dailight savings time.  Uses global lat/lon vars.
 */
bool is_dst(uint16_t year, time_t t, float lon){
  File dst_file = SD.open("DST.DAT");
  time_t start, stop;
  bool out;

  if(dst_file){
    year = year % 2000;
    dst_file.seek((year + 0) * 16  + 8 * (lon > -20)); // lat > -20 --> EU, else US 
    start = readtime(dst_file);
    stop = readtime(dst_file);
    out = (start < t) && (t < stop);
  }
  dst_file.close();
  return out;
}

// return true if pps singal is current
bool gps_is_active(){
  unsigned long  now_us = micros();
  return (now_us > pps_start_us) && (now_us - pps_start_us) < 1.5e6;
}
// return true if real time clock has been set recently
bool rtc_is_set(){
  return hour() == rtc_set_hour;
}

// return local time offset in seconds.  including dailight savings time
long local_offset(int yyyy, time_t now, float flat, float flon){
  dst_flag = is_dst(yyyy, now, lon);
  long my_offset;
  gmt_offset(flat, flon, &tz_offset_st, &tz_offset_dst);

  if(dst_flag){
    digitalWrite(SQW_LED, HIGH);
    my_offset = tz_offset_dst;
  }
  else{
    digitalWrite(SQW_LED, LOW);
    my_offset = tz_offset_st;
  }
  return my_offset;
}

// update rtc if necessary (sleep for 1 second)
void loop(){
  unsigned long age;
  int Year;
  byte Month, Day, Hour, Minute, Second, Hundredths;
  time_t gps_t;
  tmElements_t tm_ele;
  float flat, flon;

  // if RTC is stale and GPS is active, set RTC
  while(!rtc_is_set() && 
	gps_is_active()){

    // clear GPS
    gps.reset();

    // feed GPS for a while
    for(int i=0; i<100; i++){
      for(int j=0; j<100; j++){
	feedgps();
      }
    }
    
    // see if year has been upated
    gps.crack_datetime(&Year, &Month, &Day, &Hour, &Minute, &Second, &Hundredths, &age);
    gps.f_get_position(&flat, &flon, &age);
    
    if(Year > 2000 && age < 10000){
      // accept new time... set RTC
      lat = flat;
      lon = flon;
      tm_ele.Year = CalendarYrToTm(Year);
      tm_ele.Month = Month;
      tm_ele.Day = Day;
      tm_ele.Hour = Hour;
      tm_ele.Minute = Minute;
      tm_ele.Second = Second;

      gps_t = makeTime(tm_ele);
      
      time_t local_t = gps_t + local_offset(Year, gps_t, lat, lon) + age / 1000 + 1;
      delay(1000 - age % 1000); // set time at next second
      setRTC(local_t);
      setTime(local_t);
      Serial.print("Clock Syncrhonized with GPS: Pos is ");
      Serial.print(lat);
      Serial.print(" ");
      Serial.print(lon);
      Serial.print(", Local Time is "); Serial.print(hour()); 
      Serial.print(":"); Serial.print(minute()); 
      Serial.print(":"); Serial.println(second());
      rtc_set_hour = hour();
    }
  }
  delay(1000);
}

bool feedgps(){
  char c;
  while (sws.available())
  {
    c = sws.read();
    if (gps.encode(c)){
      return true;
    }
  }
  return false;
}
