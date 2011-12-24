#include "rtcBOB.h"
#include "Time.h"
#include "Wire.h"
#include <NewSoftSerial.h>
#include <TinyGPS.h>
#include <EEPROM.h>
#include "EDL.h"

volatile unsigned long count = 0;
volatile unsigned long pps_start_us = 0;
volatile unsigned long pps_tick_us = 1000000;  // filtered
volatile unsigned long _pps_tick_us = 1000000; // unfiltered

volatile unsigned long rtc_start_us;          
volatile unsigned long rtc_tick_us = 1000000;  // filtered
volatile unsigned long _rtc_tick_us = 1000000; // unfiltered

// drift = actual_us - desired_us
// drift > 0 ==> pulse is late
// drift < 0 ==> pulse is early
volatile          long rtc_drift_us;          // Filtered


volatile boolean pps_led_state = true;
volatile boolean sqw_led_state = true;
volatile boolean synced = false;
const int SQW_PIN = 2;
const int PPS_PIN = 3;
const int  PPS_LED = 13;
const int SYNC_LED = 12;
const int  SQW_LED = 11;
const unsigned long  RTC_WRITE_US = 1064;
const uint8_t LAST_UPDATE_DID = 1;

TinyGPS gps;
NewSoftSerial sws(5, 4);

void pps_interrupt(){
  unsigned long  now_us = micros();
  _pps_tick_us = (now_us - pps_start_us);
  if(_pps_tick_us < pps_tick_us / 2 || _pps_tick_us > 3 * pps_tick_us / 2){
    // _pps_tick_us = rtc_tick_us;
  }
  if(pps_led_state){
    pps_led_state = false;
  }
  else{
    pps_led_state = true;
  }
  digitalWrite(PPS_LED, pps_led_state);
  digitalWrite(SQW_LED, sqw_led_state);
  if(now_us > 2e6){
    if(abs(((1000 * _pps_tick_us) / pps_tick_us) - 1000) < 10){
      pps_tick_us = (59 * pps_tick_us + _pps_tick_us) / 60;
    }
  }
  pps_start_us = now_us;
}

void rtc_interrupt(){
  unsigned long  now_us = micros();
  long drift_us;

  if(sqw_led_state){
    sqw_led_state = false;
  }
  else{
    sqw_led_state = true;
  }
  digitalWrite(PPS_LED, pps_led_state);
  digitalWrite(SQW_LED, sqw_led_state);
  // actual - desired
  drift_us = (now_us - pps_start_us) % pps_tick_us;

  rtc_drift_us = (59 * rtc_drift_us + drift_us) / 60;
  rtc_drift_us = drift_us;
}

bool save_last_sync_time(time_t t){
  const uint8_t len = 14;

  char dat[len];
  dat[0] = LAST_UPDATE_DID;
  dat[1] = len;
  Time_to_Serial(t, dat + 2);
  ulong_to_Serial(pps_tick_us, dat + 6);   // millis / pps        use pps_tick_us
  // ulong_to_Serial(rtc_tick_us, dat + 10);   // millis / 1hz        use get_tick_us()
  return did_write(dat);
}

// write 4 bytes of in into char buffer out.
void Time_to_Serial(time_t in, char *out){
  time_t *out_p = (time_t *)out;
  *out_p = in;
}
// write 4 bytes of in into char buffer out.
void ulong_to_Serial(unsigned long in, char *out){
  unsigned long *out_p = (unsigned long *)out;
  *out_p = in;
}

void setup(){
  if(!did_check_eeprom()){
    did_format_eeprom();
  }

  Serial.begin(115200);
  // sws.begin(9600);
  
  Wire.begin();
  pinMode(PPS_LED, OUTPUT);
  pinMode(SYNC_LED, OUTPUT);
  pinMode(SQW_LED, OUTPUT);

  pinMode(PPS_PIN, INPUT);
  pinMode(SQW_PIN, INPUT);

  digitalWrite(SYNC_LED, HIGH);
  digitalWrite(PPS_LED, HIGH);
  digitalWrite(SQW_LED, HIGH);

  delay(100);
  digitalWrite(PPS_LED, LOW);
  digitalWrite(SQW_LED, LOW);
  
  while(digitalRead(PPS_PIN) == LOW){
  }
  delay(0);
  // setRTC(2011, 1, 1, 0, 0, 0);  
  //// time RTC write opration: 1064 uS ~ 1mS
  // unsigned long now_us = micros();

  Serial.println(now());
  attachInterrupt(1, pps_interrupt, RISING);
  set_1Hz_ref(getTime(), SQW_PIN, rtc_interrupt);  // attachInterrupt(0, rtc_interrupt, RISING);
}

void loop(){
  long d;
  time_t next_time;
  // feedgps();

  unsigned long now_us = micros();

  if((pps_start_us > 0) &&                             // pps is active
     (rtc_start_us > 0) &&                             // rtc is active
     (pps_start_us / 2 < now_us) && 
     abs(rtc_drift_us - 500000) > 1000 &&
     (now_us - pps_start_us < 3 * pps_start_us / 2)    // pps is current
     ){
    // Serial.println("not synced");
    long sleep_us;

    // expected = pps_start_us + pps_tick_us / 2
    sleep_us = (((long)pps_start_us + (long)rtc_tick_us) - (long)micros());
    delay(sleep_us / 1000 - 1);
    setRTC(0);
    Serial.print("sleep_us:");
    Serial.println(sleep_us / 1000 - 1);
  }
  Serial.print("G ");
  Serial.print(pps_start_us);
  Serial.print(" ");
  Serial.print(pps_tick_us);
  Serial.print(" ");
  Serial.println(_pps_tick_us);
  Serial.print("R ");
  Serial.print(rtc_start_us);
  Serial.print(" ");
  Serial.print(rtc_tick_us);
  Serial.print(" ");
  Serial.println(_rtc_tick_us);
  Serial.print("D ");
  Serial.print(now_us);
  Serial.print(" ");
  Serial.println(rtc_drift_us - 500000);
  synced = rtc_drift_us - 500000 < 1000;
  digitalWrite(SYNC_LED, !(synced));
  delay(4500);
  // setRTC(0);
}

void do_nothing(){
}
bool feedgps()
{
  while (sws.available())
  {
    if (gps.encode(sws.read()))
      return true;
  }
  return false;
}
