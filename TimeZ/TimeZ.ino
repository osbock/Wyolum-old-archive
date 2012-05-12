#include <avr/pgmspace.h>
#include "rtcBOB.h"
#include "Time.h"
#include "Wire.h"
#include "SD.h"
// #include "SPI.h"

// Arduino 1.0 compatibility
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#define WIRE_READ Wire.read();
#include "SoftwareSerial.h"
#else
#include "WProgram.h"
#define WIRE_READ Wire.receive()
// #include "NewSoftSerial.h"
#endif

#include <TinyGPS.h>

#define DEFINED

volatile unsigned long count = 0;
volatile unsigned long pps_start_us = 0;
volatile unsigned long pps_tick_us = 1000000;  // filtered
volatile unsigned long _pps_tick_us = 1000000; // unfiltered
volatile double lat = 1000; // default to bad lat
volatile double lon = 1000; // default to bad lon

volatile unsigned long rtc_start_us = 0;          
volatile unsigned long rtc_tick_us = 1000000;  // filtered
volatile unsigned long _rtc_tick_us = 1000000; // unfiltered

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
#if defined(ARDUINO) && ARDUINO >= 100
// SoftwareSerial sws(5, 4);
SoftwareSerial sws(6, A7);
#else
//NewSoftSerial sws(5, 4);
#endif

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
  // Serial.println("rtc_interrupt");
  sqw_led_state = !sqw_led_state;
  // digitalWrite(PPS_LED, sqw_led_state);
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
  gps.add_callback(grab_datetime);
  sws.begin(9600);

  Serial.begin(115200);
  Serial.println("TimeZ v1.0");
  //\\Serial.println("Copyright WyoLum, LLC, 2012");

  Wire.begin(MY_ADDR);
  // c3.init();
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
  //\\Serial.println("Waiting for 1Hz signal");
  while(rtc_start_us == 0){
    delay(100);
  }
  //\\Serial.println("1Hz signal found");
  attachInterrupt(PPS_PIN - 2, pps_interrupt, RISING);

  //\\Serial.print("now():");
  //\\Serial.println(now());

  //\\Serial.print("Initializing SD card...");
  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
   pinMode(chipSelect, OUTPUT);
  if (!SD.begin(chipSelect)) {
    //\\Serial.println("initialization failed!");
    ERROR_OUT(4);
  }
  //\\Serial.println("initialization done.");
  initialize_clock();
}

/*
  Stored in minutes in the file
  converted to seconds for local vars

  format:StandardTime, Dailight Time 4-byte unsigned
 */
void restore_tz(){
  char *buff;
  int16_t st;
  int16_t dst;
  File tz_file;
  unsigned long start_s;
  
  if(abs(lat) < 90 and abs(lon) < 360){
    // 2. lat / lon valid
    gmt_offset(lat, lon, &tz_offset_st, &tz_offset_dst);
  }
  // Europe DST rule
  // last Sunday in March to last sun in October at 01:00
  
  // Americas  DST from 
  // 2nd Sunday in March to first Sunday in November at 02:00
  //\\Serial.println(tz_offset_st);
}

int readshort(File myFile){
  int16_t out;
  char *dat = (char*)&out;
  for(uint8_t i=0; i < 2; i++){
    dat[i] = myFile.read();
  }
  return out;
}
void writeshort(File myFile, int16_t val){
  char *dat = (char*)&val;
  for(uint8_t i=0; i < 2; i++){
    myFile.write(dat[i]);
  }
}

time_t readtime(File myFile){
  time_t out;
  char *dat = (char*)&out;
  for(uint8_t i=0; i < 4; i++){
    dat[i] = myFile.read();
  }
  return out;
}
void writetime(File myFile, time_t val){
  char *dat = (char*)&val;
  for(uint8_t i=0; i < 4; i++){
    myFile.write(dat[i]);
  }
}

time_t readdouble(File myFile){
  double out;
  char *dat = (char*)&out;
  for(uint8_t i=0; i < 4; i++){
    dat[i] = myFile.read();
  }
  return out;
}
void writedouble(File myFile, double val){
  char *dat = (char*)&val;
  for(uint8_t i=0; i < 4; i++){
    myFile.write(dat[i]);
  }
}

const int RECLEN = 38;
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
bool is_dst(uint16_t year, time_t t, float lon){
  //}
  // bool is_dst_not_used(uint16_t year, time_t t, float lon){
  File dst_file = SD.open("DST.DAT");
  time_t start, stop;
  bool out;

  if(dst_file){
    year = year % 2000;
    dst_file.seek(year * 16 + 8 * (lon > -20)); // lat > -20 --> EU, else US 
    start = readtime(dst_file);
    stop = readtime(dst_file);
    out = (start < t) && (t < stop);
  }
  dst_file.close();
  return out;
}

void initialize_clock(){
  // insure file is large enough
}

/*
  GPS time is GMT, 
  Arduino time is local, 
  RTC time is local
 */
void grab_datetime(unsigned long _date, 
		   unsigned long _time,
		   long _lat,
		   long _lon,
		   long alt,
		   unsigned long speed,
		   unsigned long course){
  int YY, MM, DD, hh, mm, ss;
  int nYY, nMM, nDD, nhh, nmm, nss;
  unsigned long date = _date;
  unsigned long time = _time;
  int16_t offset;
  boolean dst_flag;
  int16_t my_offset;

  // set globals
  if((abs(lon - _lon / 1e5) > .1) or (abs(lat - _lat / 1e5) > .1)){
    lat = _lat / 1e5;
    lon = _lon / 1e5;
    restore_tz();
  }
  gmt_offset(lat, lon, &tz_offset_st, &tz_offset_dst);
  // ck if DST applies
  dst_flag = is_dst(year(), getTime(), lon);
  if(dst_flag){
    digitalWrite(SQW_LED, HIGH);
    my_offset = tz_offset_dst;
  }
  else{
    digitalWrite(SQW_LED, LOW);
    my_offset = tz_offset_st;
  }
  time_t gmt = now() + my_offset;
  nYY = YY = year(gmt);
  nMM = MM = month(gmt);
  nDD = DD = day(gmt);
  hh = hour(gmt);
  mm = minute(gmt);
  ss = second(gmt);


  nhh = time / 1000000;
  time = time % 1000000;
  nmm = time / 10000;
  time = time % 10000;
  nss = time / 100;
  
  //\\Serial.print("LAT:");
  //\\Serial.println(lat);
  //\\Serial.print("LON:");
  //\\Serial.println(lon);
  if(date > 0){
    nDD = date / 10000;
    date = date % 10000;
    nMM = date / 100; 
    date = date % 100;
    nYY = 2000 + date;
  }
  //setRTC(YY, MM, DD, hh, mm, ss);

  if(YY != nYY || MM != nMM || DD != nDD ||
     hh != nhh || mm != nmm || abs(ss- nss) > 10){
    setTime(nhh,nmm,nss,nDD,nMM,nYY);
    setRTC(now() + my_offset);
    last_set_time = getTime();
    //setTime(last_set_time);
  }
  // Serial.print(nhh);
  // Serial.print("hour():");
  // Serial.println(hour());
  // Serial.print(" ");
  // Serial.print(getTime());
  // Serial.print(" ");
  // Serial.println(lon);
  //  Serial.print(" ");
  // Serial.println(is_dst(year(), getTime(), lon));
}

void loop(){

  //xxSerial.print("loop() ");
  //xxSerial.print(year());
  //xxSerial.print("/");
  //xxSerial.print(month());
  //xxSerial.print("/");
  //xxSerial.print(day());
  //xxSerial.print(" ");
  Serial.print(hour());
  Serial.print(":");
  Serial.println(minute());
  //\\Serial.print("lat:");
  //\\Serial.println(lat);
  feedgps(10);
}

void do_nothing(){
}
bool feedgps(uint8_t secs){
  for(int i=0; i  < secs * 100; i++){
    feedgps();
    delay(10);
  }
}

bool feedgps(){
  while (sws.available())
  {
    if (gps.encode(sws.read()))
      return true;
  }
  return false;
}

void printFloat(double number, int digits)
{
  // Handle negative numbers
  if (number < 0.0)
  {
     Serial.print('-');
     number = -number;
  }

  // Round correctly so that print(1.999, 2) prints as "2.00"
  double rounding = 0.5;
  for (uint8_t i=0; i<digits; ++i)
    rounding /= 10.0;
  
  number += rounding;

  // Extract the integer part of the number and print it
  unsigned long int_part = (unsigned long)number;
  double remainder = number - (double)int_part;
  Serial.print(int_part);

  // Print the decimal point, but only if there are digits beyond
  if (digits > 0)
    Serial.print("."); 

  // Extract digits from the remainder one at a time
  while (digits-- > 0)
  {
    remainder *= 10.0;
    int toPrint = int(remainder);
    Serial.print(toPrint);
    remainder -= toPrint; 
  } 
}
