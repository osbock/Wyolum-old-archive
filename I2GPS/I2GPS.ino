/*
  I2GPS Slave code handles all of the I2C events.  Load this code
  directly onto the I2GPS device.  


  This is slave code.
  For client code, see
  
 */

#include <inttypes.h>
#include "SD.h"
#include "Wire.h"
#include "TinyGPS.h"
#include "SoftwareSerial.h"
#include "Time.h"

// globals
const int  LED1 = 7; 
const int  LED2 = 4;
const int SQW_PIN = 3;
const int PPS_PIN = 2;
const uint8_t I2GPS_I2C_ADDRESS = 88; // TODO: put in header
const uint8_t N_DATA_BYTE = 0x27;
volatile boolean pps_led_state = true;

uint8_t address = 0;
uint8_t gps_data[N_DATA_BYTE];

TinyGPS gps;
SoftwareSerial sws(6, A7);
void I2GPS_onReceive(int n_byte);
void I2GPS_onRequest(void);

bool feedgps();

void setup(){
  Serial.begin(115200);
  sws.begin(9600);

  Serial.println("I2GPS Slave v1.0");
  Serial.println("Copyright WyoLum, LLC 2012");
  Wire.begin(I2GPS_I2C_ADDRESS);
  Wire.onReceive(I2GPS_onReceive);
  Wire.onRequest(I2GPS_onRequest);

  attachInterrupt(PPS_PIN - 2, pps_interrupt, RISING);

  for(uint8_t i=0; i < N_DATA_BYTE; i++){
    gps_data[i] = 255;
    gps_data[i] = i;
  }
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  for(int i=0; i < 3; i++){
    digitalWrite(LED1, HIGH);
    digitalWrite(LED2, LOW);
    delay(100);
    digitalWrite(LED2, HIGH);
    digitalWrite(LED1, LOW);
    delay(50);
  }
  digitalWrite(LED2, LOW);
  digitalWrite(LED1, LOW);
}
void loop(){
  int Year;
  uint8_t Month, Day, Hour, Minute, Second, Hundredths;
  tmElements_t tm_ele;
  unsigned long gps_time, speed, course, age;
  long lat, lon, alt;

  if(feedgps()){
    gps.crack_datetime(&Year, &tm_ele.Month, &tm_ele.Day, 
		       &tm_ele.Hour, &tm_ele.Minute, &tm_ele.Second, 
		       &Hundredths, &age);
    tm_ele.Year = CalendarYrToTm(Year);
    gps_time = makeTime(tm_ele);
    serialize_ulong(gps_time, gps_data + 0x00);

    gps.get_position(&lat, &lon, &age);
    serialize_long(lat, gps_data + 0x04);
    serialize_long(lon, gps_data + 0x08);

    alt = gps.altitude();
    serialize_long(alt, gps_data + 0x0C);

    speed = gps.speed();
    serialize_ulong(speed, gps_data + 0x10);

    course = gps.course();
    serialize_ulong(course, gps_data + 0x14);
    
    gps_data[0x1C] = (uint8_t)(Year % 100);
    gps_data[0x1D] = tm_ele.Month;
    gps_data[0x1E] = tm_ele.Day;
    gps_data[0x1F] = tm_ele.Hour;
    gps_data[0x20] = tm_ele.Minute;
    gps_data[0x21] = tm_ele.Second;

  }
  else{
    age = gps.age();
  }
  serialize_ulong(age, gps_data + 0x18);
  if(age < 2000){
    digitalWrite(LED1, HIGH);
  }
  else{
    digitalWrite(LED1, LOW);
  }
}

void I2GPS_onReceive(int n_byte){
  address = Wire.read();
}
void I2GPS_onRequest(){
  int n_byte = 32;
  if(N_DATA_BYTE - address < 32){
    n_byte = N_DATA_BYTE - address;
  }
  Wire.write(gps_data + address, n_byte);
}

bool feedgps()
{
  while (sws.available())
  {
    if (gps.encode(sws.read())){
      delay(100);
      return true;
    }
  }
  return false;
}

void serialize_short(int16_t val, uint8_t* dest){
  char *dat_p = (char*)&val;
  for(uint8_t i=0; i < 2; i++){
    dest[i] = dat_p[i];
  }
}
void serialize_long(long val, uint8_t* dest){
  char *dat_p = (char*)&val;
  for(uint8_t i=0; i < 4; i++){
    dest[i] = dat_p[i];
  }
}
void serialize_ushort(uint16_t val, uint8_t* dest){
  char *dat_p = (char*)&val;
  for(uint8_t i=0; i < 2; i++){
    dest[i] = dat_p[i];
  }
}
void serialize_ulong(unsigned long val, uint8_t* dest){
  char *dat_p = (char*)&val;
  for(uint8_t i=0; i < 4; i++){
    dest[i] = dat_p[i];
  }
}

void pps_interrupt(){
  unsigned long  now_us = micros();
  pps_led_state = !pps_led_state;
  digitalWrite(LED2, pps_led_state);
}
