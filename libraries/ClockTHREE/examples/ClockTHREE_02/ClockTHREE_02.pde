/*
  Delivery ClockTHREE Word Clock App
  Display time 12:12 PM in words using english template
  Supports different modes:
  Normal
  Mode (Mode to switch modes)
  SetTime
  SetAlarm
  SetColor
  Serial

  Justin Shaw Dec 22, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0
 */
#define CLOCKTWO

#include <avr/pgmspace.h>
#include <EEPROM.h>
#include <Wire.h>
#include <string.h>
#include "Time.h"
#include "TimeAlarms.h"
#include "MsTimer2.h"
#include "ClockTHREE.h"
#include "SPI.h"
#include "english.h"
#include "font.h"
#include "rtcBOB.h"
#include "EDL.h"

// debounce mode button threshold
const uint8_t DEBOUNCE_THRESH = 100;
const uint16_t SERIAL_TIMEOUT_MS = 1000;

// Define modes
typedef void (* CallBackPtr)(); // this is a typedef for callback funtions

inline void do_nothing(void){}

struct Mode{
  uint8_t id;      // Mode ID
  char sym;        // ASCII Symbol for mode
  CallBackPtr setup;  // to be called when Mode is initialized
  CallBackPtr loop;    // to be called as often as possible when mode is active
  CallBackPtr exit;    // to be called when mode is exited.
  CallBackPtr inc; // to be called when increment button is pushed
  CallBackPtr dec; // to be called when decrement button is pushed
  CallBackPtr mode;// to be called when mode button is pushed
};

// Default display -- twice as large as is needed
uint32_t *display = (uint32_t*)calloc(2 * N_COL, sizeof(uint32_t));

Mode *mode_p;

const uint8_t N_MODE = 10;
const uint8_t N_MAIN_MODE = 6;
const uint8_t N_SUB_MODE = 3;

const uint8_t NORMAL_MODE = 0;
const uint8_t SET_TIME_MODE = 1;
const uint8_t SET_COLOR_MODE = 2;
const uint8_t SET_ALARM_MODE = 3;
const uint8_t SERIAL_MODE = 4;
const uint8_t MODE_MODE = 5;

// Sub Modes 
const uint8_t SECONDS_MODE = 6;
const uint8_t ALARM_MODE = 7;
const uint8_t TEMPERATURE_MODE = 8;
const uint8_t SCROLL_MODE = 9;

const uint8_t DEG_C = 0;
const uint8_t DEG_F = 1;

uint8_t last_mode_id = NORMAL_MODE; // the last mode clock was in...

Mode Modes[N_MODE];

typedef enum {YEAR, MONTH, DAY, HOUR, MINUTE, SECOND} unit_t;

// Begin mode declarations

Mode NormalMode = {NORMAL_MODE, 
		   'N', Normal_setup, Normal_loop, Normal_exit, 
		   Normal_inc, Normal_dec, Normal_mode};
Mode SecondsMode = {SECONDS_MODE, 
		    'S', Seconds_setup, Seconds_loop, Seconds_exit, 
		    Seconds_mode, Seconds_mode, Seconds_mode};
Mode AlarmMode = {ALARM_MODE, 
		  'X', Alarm_setup, Alarm_loop, Alarm_exit, 
		  Alarm_mode, Alarm_mode, Alarm_mode};
Mode TemperatureMode = {TEMPERATURE_MODE, 'X', 
			Temperature_setup, Temperature_loop, Temperature_exit, 
			Temperature_inc, Temperature_dec, Temperature_mode};
Mode ScrollMode = {SCROLL_MODE, 'X', 
		   Scroll_setup, Scroll_loop, Scroll_exit, 
		   Scroll_inc, Scroll_dec, Scroll_mode};
Mode SetTimeMode = {SET_TIME_MODE, 
		    'T', SetTime_setup,SetTime_loop,SetTime_exit,
		    SetTime_inc, SetTime_dec, SetTime_mode};
Mode SetColorMode = {SET_COLOR_MODE, 
		     'C', SetColor_setup, SetColor_loop, SetColor_exit, 
		     SetColor_inc, SetColor_dec, SetColor_mode};
Mode SetAlarmMode = {SET_ALARM_MODE, 
		     2, SetAlarm_setup,SetAlarm_loop,SetAlarm_exit,
		     SetAlarm_inc, SetAlarm_dec, SetAlarm_mode};
Mode SerialMode = {SERIAL_MODE, 
	       'P', Serial_setup,Serial_loop,Serial_exit,
	       Serial_inc,Serial_dec,Serial_mode};
Mode ModeMode = {MODE_MODE, 
		 'M', Mode_setup, Mode_loop, Mode_exit, 
		 Mode_inc, Mode_dec, Mode_mode};

/* Event types */
const uint8_t       NO_EVT = 0; // NONE
const uint8_t     MODE_EVT = 1; // Mode Button has been pressed
const uint8_t      INC_EVT = 2; // Increment Button has been pressed
const uint8_t      DEC_EVT = 3; // Decriment Button has been pressed
const uint8_t     TICK_EVT = 4; // Second has ellapsed
const uint8_t EVENT_Q_SIZE = 5; // Max # events.

// Messaging
struct MsgDef{
  uint8_t id;
  uint8_t n_byte; // n_byte = MAX_MSG_LEN implies a variable length message
  CallBackPtr cb;
};

union Serial_time_t{
  time_t dat32; 
  uint8_t dat8[4];
};

const uint8_t MAX_MSG_LEN = 100; // official: 100
const uint16_t BAUDRATE = 57600; // official:57600
const uint8_t SYNC_BYTE = 254;   // 0xEF;
const uint8_t VAR_LENGTH = 255;   // 0xFF;
char* EEPROM_ERR = "EE";
char* EEPROM_DELETE_ERR = "ED";
const uint8_t N_MSG_TYPE = 24;
const MsgDef  NOT_USED_MSG = {0x00, 1, do_nothing};
const MsgDef  ABS_TIME_REQ = {0x01, 1, send_time};
const MsgDef  ABS_TIME_SET = {0x02, 5, Serial_time_set};
const MsgDef TOD_ALARM_REQ = {0x03, 1, tod_alarm_get};
const MsgDef TOD_ALARM_SET = {0x04, 6, tod_alarm_set};
const MsgDef      DATA_REQ = {0x05, 2, send_data};
const MsgDef   DATA_DELETE = {0x06, 2, delete_data};
const MsgDef    SCROLL_DATA = {0x07, 2, scroll_data};
const MsgDef     EVENT_REQ = {0x08, 2, do_nothing};
const MsgDef     EVENT_SET = {0x09, 6, do_nothing};
const MsgDef   DISPLAY_REQ = {0x0A, 1, display_send};
const MsgDef   DISPLAY_SET = {0x0B, 2, display_set};
const MsgDef  TRIGGER_MODE = {0x0C, 1, mode_interrupt};
// const MsgDef  TRIGGER_MODE = {0x0C, 1, eeprom_clear};

const MsgDef   TRIGGER_INC = {0x0D, 1, do_nothing};
const MsgDef   TRIGGER_DEC = {0x0E, 1, do_nothing};
const MsgDef TRIGGER_ENTER = {0x0F, 1, do_nothing};
const MsgDef   VERSION_REQ = {0x10, 1, do_nothing};
const MsgDef     ABOUT_REQ = {0x11, 1, do_nothing};
const MsgDef          PING = {0x12, MAX_MSG_LEN, pong};
const MsgDef  EEPROM_CLEAR = {0x43, MAX_MSG_LEN, eeprom_clear}; // 0x43 = ASCII 'C'
const MsgDef   EEPROM_DUMP = {0x44, 1, eeprom_dump}; // 0x44 = ASCII 'D'
const MsgDef   ANNIVERSARY = {0x15, 2, set_did_alarm};
const MsgDef NEXT_ALARM_REQ = {0x16, 1, next_alarm_send};

const MsgDef          SYNC = {SYNC_BYTE, MAX_MSG_LEN, do_nothing}; // must already be in sync
const MsgDef      DATA_SET = {0x70, VAR_LENGTH, receive_data}; // variable length
const MsgDef      ERR_OUT = {0x71, VAR_LENGTH, do_nothing}; // variable length

const MsgDef *MSG_DEFS[N_MSG_TYPE] = {&NOT_USED_MSG,
				      &ABS_TIME_REQ,
				      &ABS_TIME_SET,
				      &TOD_ALARM_REQ,
				      &TOD_ALARM_SET,
				      &DATA_REQ,
				      &DATA_DELETE,
				      &SCROLL_DATA,
				      &EVENT_REQ,
				      &EVENT_SET,
				      &DISPLAY_REQ,
				      &DISPLAY_SET,
				      &TRIGGER_MODE,
				      &TRIGGER_INC,
				      &TRIGGER_DEC,
				      &TRIGGER_ENTER,
				      &VERSION_REQ,
				      &ABOUT_REQ,
				      &EEPROM_CLEAR,
				      &PING,
				      &EEPROM_DUMP,
				      &ANNIVERSARY,
				      &NEXT_ALARM_REQ,
				      &DATA_SET};

char serial_msg[MAX_MSG_LEN];
uint8_t serial_msg_len;

// Globals
uint8_t event_q[EVENT_Q_SIZE];
uint8_t n_evt = 0;
unsigned long last_mode_time = 0;
unsigned long last_inc_time = 0;
unsigned long last_dec_time = 0;
ClockTHREE c3;
English faceplate = English();
Font font = Font();
time_t t;
uint8_t mode_counter;
uint8_t color_i = 3;
unsigned long count = 0;
uint16_t YY;
uint8_t MM, DD, hh, mm, ss;
uint8_t ahh, amm, ass;
AlarmId todAlarm;
boolean tick = true;
unit_t SetTime_unit = YEAR;
uint8_t temp_unit = DEG_C;
boolean alarm_set = false;
uint8_t sync_msg_byte_counter = 0;
uint8_t scroll_did = 0;

/*
 * Called when mode button is pressed
 * Increment mode after debounce check.
 */
void mode_interrupt(){
  unsigned long now = millis();
  if(now - last_mode_time > DEBOUNCE_THRESH){
    // add mode_press event to mode event queue
    if(n_evt < EVENT_Q_SIZE){
      event_q[n_evt++] = MODE_EVT;
    }
  }
  last_mode_time = now;
}

void inc_interrupt(){
  unsigned long now = millis();
  if(now - last_inc_time > DEBOUNCE_THRESH){
    // add mode_press event to mode event queue
    if(n_evt < EVENT_Q_SIZE){
      event_q[n_evt++] = INC_EVT;
    }
  }
  last_inc_time = now;
}

void dec_interrupt(){
  unsigned long now = millis();
  if(now - last_dec_time > DEBOUNCE_THRESH){
    // add mode_press event to mode event queue
    if(n_evt < EVENT_Q_SIZE){
      event_q[n_evt++] = DEC_EVT;
    }
  }
  last_dec_time = now;
}

void tick_interrupt(){
  if(n_evt < EVENT_Q_SIZE){
    event_q[n_evt++] = TICK_EVT;
  }
}

void update_time(){
  c3.refresh();
  YY = year();
  c3.refresh();
  MM = month();
  c3.refresh();
  DD = day();
  c3.refresh();
  hh = hour();
  c3.refresh();
  mm = minute();
  c3.refresh();
  ss = second();
  c3.refresh();
}

void setup(void){
  Wire.begin();
  c3.init();

  setSyncProvider(getTime);      // RTC
  setSyncInterval(3600000);      // update every hour (and on boot)
  update_time();
  getRTC_alarm(&ahh, &amm, &ass, &alarm_set);
  TOD_Alarm_Set(todAlarm, ahh, amm, ass, alarm_set);
  // TOD_Alarm_Set(todAlarm, hh, mm, ss + 5, alarm_set);
  // Alarm.timerOnce(5, fire_alarm);
  
  mode_p = &NormalMode;
  mode_p = &SerialMode;

  // ensure mode ids are consistant.
  Modes[NORMAL_MODE] = NormalMode;
  Modes[SET_TIME_MODE] = SetTimeMode;
  Modes[SET_COLOR_MODE] = SetColorMode;
  Modes[SET_ALARM_MODE] = SetAlarmMode;
  Modes[SERIAL_MODE] = SerialMode;
  Modes[MODE_MODE] = ModeMode;

  // Sub Modes
  Modes[SECONDS_MODE] = SecondsMode;
  Modes[ALARM_MODE] = AlarmMode;
  Modes[TEMPERATURE_MODE] = TemperatureMode;
  Modes[SCROLL_MODE] = ScrollMode;
  mode_p->setup();

#ifndef CLOCKTWO
  attachInterrupt(0, mode_interrupt, FALLING); // Does not work on C2
  attachInterrupt(1, inc_interrupt, FALLING);  // Does not work on C2
#endif
  c3.setdisplay(display);
  c3.set_column_hold(50);

  MsTimer2::set(1000, tick_interrupt); // 1ms period
  MsTimer2::start();
  
}

void loop(void){
  //check button status // C2 hack
#ifdef CLOCKTWO
  if(PIND & 1<<5){
    mode_interrupt();
  }
  if(PIND & 1 << 6){
    inc_interrupt();
  }
#endif
  if(PIND & 1 << 7){
    dec_interrupt();
  }

  // process new events before calling mode loop()
  for(uint8_t i = 0; i < n_evt; i++){
    switch(event_q[i]){
    case NO_EVT:
      break;
    case MODE_EVT:
      mode_p->mode();
      break;
    case INC_EVT:
      mode_p->inc();
      break;
    case DEC_EVT:
      mode_p->dec();
      break;
    case TICK_EVT:
      tick = true;
      ss++;
      Alarm.serviceAlarms();
      // if((alarm_set) && (mm == amm) && (hh == ahh) && (ss == ass)){
      // switchmodes(ALARM_MODE); // should not be needed?
      // }
      if(ss >= 60){
	ss %= 60;
	mm++;
	if(mm >= 60){
	  mm %= 60;
	  hh++;
	  if(hh == 24){
	    update_time();
	  }
	}
      }
    }
    event_q[i] = NO_EVT;
  }
  n_evt = 0;

  mode_p->loop(); // finally call mode_p loop()
  count++;        // counts times mode_p->loop() has run since mode start

}

// Begin Normal Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
*/
void Normal_setup(void){
  tick = true;
  if(alarm_set){
    faceplate.display_word(c3, DARK, alarm_off_led);
    faceplate.display_word(c3, MONO, alarm_on_led);
  }
  else{
    faceplate.display_word(c3, DARK, alarm_off_led);
    faceplate.display_word(c3, DARK, alarm_on_led);
  }
}
void Normal_loop(void) {
  if((count == 0 || ss % 6 == 0 || ss % 4 == 0) && tick){
    // minutes hack updates every six seconds 
    faceplate.display_time(YY, MM, DD, hh, mm, ss,
		      c3, getColor(COLORS[color_i]), 16);
    tick = false;
  }
  else{
    tick = true;
    c3.refresh(16);
  }
}
/*
  Get ready for next mode.
 */
void Normal_exit(void) {
}
/*
  Respond to button presses.
 */
void Normal_inc(void) {
  switchmodes(SECONDS_MODE);
}
void Normal_dec(void) {
  switchmodes(TEMPERATURE_MODE);
}
void Normal_mode(void) {
  switchmodes(MODE_MODE);
}

// Sub mode of normal mode ** display seconds
void Seconds_setup(void){
  tick = true;
}
void Seconds_loop(){
  if(tick){
    tick = false;
    two_digits(ss);
  }
  c3.refresh(16);
}
void Seconds_exit(void) {
}
void Seconds_mode(){
  switchmodes(last_mode_id);
}

// Sub mode of normal mode ** scoll message ID stored in first byte of serial_msg scroll_did;
void Scroll_setup(){
  // Display is 2x as large as screen.  Use larger indeces to stage display.
  // if(scroll_did && did_read(scroll_did, serial_msg, &serial_msg_len)){
  /* two_digits(serial_msg[0]); */
  /* c3.refresh(10000); */
  if(serial_msg[0] && did_read(serial_msg[0], serial_msg, &serial_msg_len)){
    for(uint8_t i = 2; i < serial_msg_len; i++){
      serial_msg[i - 2] =  serial_msg[i];
    }
    serial_msg_len -= 2;
    if(serial_msg_len > 0){
      font.getChar(serial_msg[0], getColor(COLORS[color_i]), display + 15);
    }
    serial_msg[0] = 0; // clear out scroll_didx

  }
  else{
    Scroll_mode();// hit the mode button to exit out of this mode, no mesage to scroll
  }
}
void Scroll_loop(){
  c3.refresh(16);
  if(count % 12 == 0){
    for(uint8_t i = 0; i < 2 * N_COL - 1; i++){
      display[i] = display[i + 1];
    }
  }
  if(count % (7 * 12) == 0){
    uint8_t i = (count / (7 * 12));
    if(i < serial_msg_len){
      font.getChar(serial_msg[i], getColor(COLORS[color_i]), display + N_COL - 1);
    }
    else{
      Scroll_mode();// hit the mode button to exit out of this mode, no mesage to scroll
    }
  }
}
void Scroll_exit() {
}

void Scroll_inc(){
}
void Scroll_dec(){
}
void Scroll_mode(){
  switchmodes(last_mode_id);
}

// Sub mode of normal mode ** display temp
void Temperature_setup(void){
  if(temp_unit == DEG_C){
    faceplate.display_word(c3, MONO, c_led);
  }
  else{
    faceplate.display_word(c3, MONO, f_led);
  }
}
void Temperature_loop(){
  int8_t temp = getTemp();
  if(temp_unit == DEG_F){
    temp = toF(temp);
  }
  two_digits(temp);
  c3.refresh(16);
}
void Temperature_exit(void) {
}
// toggle temp_unit
void Temperature_inc(){
  if(temp_unit == DEG_F){
    temp_unit = DEG_C;
    faceplate.display_word(c3, DARK, f_led);
    faceplate.display_word(c3, MONO, c_led);
  }
  else{
    temp_unit = DEG_F;
    faceplate.display_word(c3, DARK, c_led);
    faceplate.display_word(c3, MONO, f_led);
  }
}
void Temperature_dec(){
  switchmodes(last_mode_id);
}
void Temperature_mode(){
  switchmodes(last_mode_id);
}

// Sub mode of normal mode ** sound the alarm!
void Alarm_setup(void){
  MsTimer2::stop(); // tone() interfers with MsTimer2
  font.getChar('X', RED, display + 2);
  font.getChar('X', RED, display + 9);
}
void Alarm_loop(){
  if((count % (6 * 24) < (3 * 24)) && (count % 12) < 6){
    tone(SPEAKER_PIN, 880);
  }
  else{
    noTone(SPEAKER_PIN);
  }
  // c3.refresh(16);
}
void Alarm_exit(void) {
  // resync with RTC and start ticking again
  update_time();
  MsTimer2::set(1000, tick_interrupt); // 1ms period
  MsTimer2::start();
  digitalWrite(SPEAKER_PIN, HIGH);
}
void Alarm_mode(){
  switchmodes(last_mode_id);
}

// Begin SetTime Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
*/
void SetTime_setup(void){
  MsTimer2::stop(); // Ticks stop while setting time
  getTime(); // sync with rtcBOB
  SetTime_unit = YEAR;
  faceplate.display_word(c3, MONO, year_led);
}
void SetTime_loop(void) {
  switch(SetTime_unit){
  case YEAR:
    two_digits(YY % 100);
    break;
  case MONTH:
    two_digits(MM);
    break;
  case DAY:
    two_digits(DD);
    break;
  case HOUR:
    two_digits(hh);
    break;
  case MINUTE:
    two_digits(mm);
    break;
  default:
    break;
  }
  c3.refresh(16);
}
/*
  Get ready for next mode.
 */
void SetTime_exit(void) {
  setRTC(YY, MM, DD, hh, mm, ss);
  MsTimer2::start();
}
/*
  Respond to button presses.
 */
void SetTime_inc(void) {
  switch(SetTime_unit){
  case YEAR:
    YY++;
    two_digits(YY % 100);
    break;
  case MONTH:
    MM = (MM + 1) % 13;
    if(MM == 0){
      MM = 1;
    }
    two_digits(MM);
    break;
  case DAY:
    DD = (DD + 1) % (MONTHS[MM] + LEAP_YEAR(YY) + 1);
    if(DD == 0){
      DD = 1;
    }
    two_digits(DD);
    break;
  case HOUR:
    hh = (hh + 1) % 24;
    two_digits(hh);
    break;
  case MINUTE:
    mm = (mm + 1) % 60;
    ss = 0;
    two_digits(mm);
    break;
  }
}
void SetTime_dec(void) {
  switch(SetTime_unit){
  case YEAR:
    YY--;
    two_digits(YY % 100);
    break;
  case MONTH:
    MM = (MM - 1) % 13;
    if(MM == 0){
      MM = 12;
    }
    two_digits(MM);
    break;
  case DAY:
    DD = (DD - 1) % (MONTHS[MM] + LEAP_YEAR(YY) + 1);
    if(DD == 0){
      DD = 1;
    }
    two_digits(DD);
    break;
  case HOUR:
    if(hh == 1){
      hh = 23; // uint cannot go neg
    }
    else{
      hh--;
    }
    two_digits(hh);
    break;
  case MINUTE:
    if(mm == 0){
      mm = 59; // uint cannot go neg
    }
    else{
      mm--;
    }
    ss = 0;
    two_digits(mm);
    break;
  }
}
void SetTime_mode(void) {
  c3.clear();
  switch(SetTime_unit){
  case YEAR:
    SetTime_unit = MONTH;
    faceplate.display_word(c3, MONO, month_led);
    break;
  case MONTH:
    SetTime_unit = DAY;
    faceplate.display_word(c3, MONO, day_led);
    break;
  case DAY:
    SetTime_unit = HOUR;
    faceplate.display_word(c3, MONO, hour_led);
    break;
  case HOUR:
    SetTime_unit = MINUTE;
    faceplate.display_word(c3, MONO, minute_led);
    break;
  default:
    switchmodes(last_mode_id);
    break;
  }
}

// Begin SetAlarm Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
*/
void SetAlarm_setup(void){
  faceplate.display_word(c3, MONO, alarm);
  faceplate.display_time(YY, MM, DD, ahh, amm, ass,
		    c3, getColor(COLORS[color_i]), 0, false, false);
  faceplate.display_word(c3, MONO, hour_led);
  SetTime_unit = HOUR;
}
void SetAlarm_loop(void){
  c3.refresh(16);
}
/*
  Get ready for next mode.
 */
void SetAlarm_exit(void){
  setRTC_alarm(ahh, amm, ass, alarm_set);
  TOD_Alarm_Set(todAlarm, ahh, amm, ass, alarm_set);
}
/*
  Respond to button presses.
 */
void SetAlarm_inc(void){
  switch(SetTime_unit){
  case HOUR:
    ahh = (ahh + 1) % 24;
    faceplate.display_time(YY, MM, DD, ahh, amm, ass,
		      c3, getColor(COLORS[color_i]), 0, false, false);
    break;
  case MINUTE:
    amm = (amm + 5) % 60;
    ass = 0;
    faceplate.display_time(YY, MM, DD, ahh, amm, ass,
		      c3, getColor(COLORS[color_i]), 0, false, false);
    break;
  case SECOND:
    if(!alarm_set){
      alarm_set = true;
      faceplate.display_word(c3, DARK, alarm_off_led);
      faceplate.display_word(c3, MONO, alarm_on_led);
    }
    else{
      alarm_set = false;
      faceplate.display_word(c3, DARK, alarm_on_led);
      faceplate.display_word(c3, MONO, alarm_off_led);
    }
    break;
  default:
    switchmodes(last_mode_id); // Error?! get out of here.
  }
}

void SetAlarm_dec(void){
  switch(SetTime_unit){
  case HOUR:
    if(ahh == 0){
      ahh = 23; // uint cannot go neg
    }
    else{
      ahh--;
    }
    faceplate.display_time(YY, MM, DD, ahh, amm, ass,
		      c3, getColor(COLORS[color_i]), 0, false, false);
    break;
  case MINUTE:
    if(amm < 5){
      amm = 55; // uint cannot go neg
    }
    else{
      amm -= 5;
    }
    ass = 0;
    faceplate.display_time(YY, MM, DD, ahh, amm, ass,
		      c3, getColor(COLORS[color_i]), 0, false, false);
    break;
  case SECOND:
    if(!alarm_set){
      alarm_set = true;
      faceplate.display_word(c3, DARK, alarm_off_led);
      faceplate.display_word(c3, MONO, alarm_on_led);
    }
    else{
      alarm_set = false;
      faceplate.display_word(c3, DARK, alarm_on_led);
      faceplate.display_word(c3, MONO, alarm_off_led);
    }
    break;
  default:
    switchmodes(last_mode_id); // Error?! get out of here.
  }
}
void SetAlarm_mode(void){
  switch(SetTime_unit){
  case HOUR:
    SetTime_unit = MINUTE;
    faceplate.display_word(c3, DARK, hour_led);
    faceplate.display_word(c3, MONO, minute_led);
    break;
  case MINUTE:
    SetTime_unit = SECOND;
    c3.clear();
    if(alarm_set){
      faceplate.display_word(c3, MONO, alarm_on_led);
    }
    else{
      faceplate.display_word(c3, MONO, alarm_off_led);
    }
    break;
  case SECOND:
    // fall though to default
  default:
    switchmodes(last_mode_id);
    break;
  }
}

// Begin SetColor Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
*/
void SetColor_setup(void) {
}
void SetColor_loop(void) {
  if(color_i == DARK){
    c3.displayfill(DARK);
    c3.moveto(        0,         0);
    c3.lineto(N_COL - 1,         0, MONO);
    c3.lineto(N_COL - 1, N_ROW - 1, MONO);
    c3.lineto(        0, N_ROW - 1, MONO);
    c3.lineto(        0,         0, MONO);
  }
  else{
    c3.clear();
    font.getChar('0' + color_i, getColor(COLORS[color_i]), display + 5);
  }
  c3.refresh(16);
}
/*
  Get ready for next mode.
 */
void SetColor_exit(void) {
}
/*
  Respond to button presses.
 */
void SetColor_inc(void) {
  color_i++;
  color_i %= N_COLOR; // DARK=OFF
}

void SetColor_dec(void) {
  if(color_i == 0){
    color_i = N_COLOR - 1;// DARK=OFF
  }
  else{
    color_i--;
  }
}

void SetColor_mode(void) {
  switchmodes(last_mode_id);
}

// Begin Serial Modes
/* 
   Initalize mode.
*/
void Serial_setup(void){
  faceplate.display_word(c3, MONO, usb_led);
  c3.refresh();
  pinMode(DBG, OUTPUT);
  Serial.begin(BAUDRATE);
  for(uint8_t i = 0; i < 4; i++){
    digitalWrite(DBG, HIGH);
    delay(50);
    digitalWrite(DBG, LOW);
    delay(50);
  }
  digitalWrite(DBG, HIGH);
  // SPCR &= ~_BV(SPE); // try to keep DBG from dimming! (FAIL)

}

void Serial_loop(void) {
  uint8_t val;
  boolean resync_flag = true;

  if(Serial.available()){
    val = Serial.read();
    // find msg type
    for(uint8_t msg_i = 0; msg_i < N_MSG_TYPE; msg_i++){
      if(MSG_DEFS[msg_i]->id == val){
	if(Serial_get_msg(MSG_DEFS[msg_i]->n_byte)){
	  /*
	   * Entire payload (n_byte - 1) bytes 
	   * is stored in serial_msg: callback time.
	   */
	  
#ifdef LISTEN // define LISTEN to listen for protocal errors
	  pinMode(SPEAKER_PIN, OUTPUT);
	  tone(SPEAKER_PIN, 554);
	  delay(100);
	  noTone(SPEAKER_PIN);
	  */
#endif
	  MSG_DEFS[msg_i]->cb();
#ifdef LISTEN // define LISTEN to listen for protocal errors
	  pinMode(SPEAKER_PIN, OUTPUT);
	  tone(SPEAKER_PIN, 689);
	  delay(100);
	  noTone(SPEAKER_PIN);
#endif
	}
	else{
#ifdef LISTEN // define LISTEN to listen for protocal errors
	  pinMode(SPEAKER_PIN, OUTPUT);
	  tone(SPEAKER_PIN, 466);
	  delay(100);
	  noTone(SPEAKER_PIN);
#endif
	  // Got a sync message unexpectedly. Get ready for new message.
	  // no callback
	  // or timeout
	}
	resync_flag = false;
	break;
	// return;
      }
    }
    if(resync_flag){
      Serial_sync_wait();
    }
  }
}

void Serial_sync_wait(){
  // wait for SYNC message;
  uint8_t val;
  uint8_t n = 0;
  digitalWrite(DBG, LOW);
  while(n < SYNC.n_byte){
    if(Serial.available()){
      val = Serial.read();
      if(val == SYNC_BYTE){
	n++;
      }
      else{
	n = 0;
      }
    }
  }
  digitalWrite(DBG, HIGH);
  // SPCR |= _BV(SPE); // try to keep DBG from dimming! (FAIL)
}

void pong(){
  for(uint8_t i=0; i < MAX_MSG_LEN - 1; i++){
    Serial.print(serial_msg[i],BYTE);
  }
}

void send_time(){
  Serial_time_t data;
  
  Serial.print(ABS_TIME_SET.id, BYTE);
  data.dat32 = now();
  for(uint8_t i = 0; i < 4; i++){
    Serial.print(data.dat8[i], BYTE);
  }
}

void Serial_time_set(){
  Serial_time_t data;

  for(uint8_t i = 0; i < 4; i++){
    data.dat8[i] = serial_msg[i];
  }
  setTime(data.dat32);
  YY = year();
  MM = month();
  DD = day();
  hh = hour();
  mm = minute();
  ss = second();
  setRTC(YY, MM, DD, hh, mm, ss);
}
void tod_alarm_set(){
  Serial_time_t data;
  tmElements_t tm;

  for(uint8_t i = 0; i < 4; i++){
    data.dat8[i] = serial_msg[i];
  }
  breakTime(data.dat32, tm);
  ahh = tm.Hour;
  amm = tm.Minute;
  ass = tm.Second;
  alarm_set = serial_msg[4];
  
  TOD_Alarm_Set(todAlarm, ahh, amm, ass, alarm_set);
  setRTC_alarm(ahh, amm, ass, alarm_set);
}

void tod_alarm_get(){
  Serial_time_t data;
  tmElements_t tm;

  tm.Hour = ahh;
  tm.Minute = amm;
  tm.Second = ass;
  data.dat32 = makeTime(tm);
  data.dat32 %= 86400;

  Serial.print(TOD_ALARM_SET.id, BYTE);
  for(uint8_t i = 0; i < 4; i++){
    Serial.print(data.dat8[i], BYTE);
  }
  Serial.print(alarm_set, BYTE);
}

void eeprom_dump(){
  for(uint16_t i = 0; i <= MAX_EEPROM_ADDR; i++){
    Serial.print(EEPROM.read(i), BYTE);
  }
}

void next_alarm_send(){
  Serial_time_t data;
  Serial.print(ABS_TIME_SET.id, BYTE);
  data.dat32 = Alarm.nextTrigger;
  for(uint8_t i = 0; i < 4; i++){
    Serial.print(data.dat8[i]);
  }
}
void set_did_alarm(){
  Serial_time_t data;
  tmElements_t tm;
  uint8_t len;
  bool status = true;

  // did stored in serial_msg[0] (MID pealed off already)
  // record stored in eeprom
  if(did_read(serial_msg[0], serial_msg, &len)){
    for(uint8_t i = 2; i < 6; i++){
      data.dat8[i - 2] = serial_msg[i];
    }
    // countdown bits: MSb     -->                  LSb
    // blank, blank, blank, day, hour, 5min, min, 10sec, 
    uint8_t countdown = serial_msg[6];
    uint8_t repeat = serial_msg[7];
    //                time        callback  alarm_f cd_f      rp_f     alarm_did
    /* uint8_t o_color = color_i; */
    /* color_i = 7; */
    /* Serial.end(); */
    /* two_digits(serial_msg[0]); // DEBUGGING */
    /* c3.refresh(10000);         // DEBUGGING */
    /* Serial.begin(BAUDRATE); */
    /* color_i = o_color; */
    /* delay(200); */
    //                time        cb       alarm  cd rp  alarm_did
    if(!Alarm.create(data.dat32, fire_alarm, true, 0, 0, serial_msg[0])){
      status = false;
    }
  }
  else{
    status = false;
  }
  if(!status){
    // error
    Serial_send_err("AL");
  }
}

void receive_data(){
  int16_t tmp_addr;
  uint8_t tmp_l;

  if(!did_write(serial_msg + 1)){
    Serial_send_err(EEPROM_ERR);
  }
}

void delete_data(){
  uint8_t did = serial_msg[0];
  if(!did_delete(did)){
    Serial_send_err(EEPROM_DELETE_ERR);
  }
}

void scroll_data(){
  switchmodes(SCROLL_MODE);
}

void Serial_send_err(char *err){
  uint8_t len = strlen(err);
  Serial.print(ERR_OUT.id, BYTE);
  // Serial.print(len + 2 + MAX_MSG_LEN, BYTE);
  Serial.print(len + 2, BYTE);
  Serial.print(err);
  c3.tone(55, 500);
  // Serial.print(serial_msg);
}

void send_data(){

  uint8_t did = serial_msg[0];
  uint8_t n_byte;

  if(did_read(did, serial_msg, &n_byte)){
    Serial.print(DATA_SET.id, BYTE);
    Serial.print(n_byte + 2, BYTE);
    for(uint8_t i=0; i < n_byte; i++){
      Serial.print(serial_msg[i]);
    }
  }
  else{
    Serial_send_err(EEPROM_ERR);
  }
}

void display_send(){
  uint8_t *display_p = (uint8_t *)display;
  Serial.print(DISPLAY_SET.id, BYTE);
  for(uint8_t i = 0; i < N_COL * sizeof(uint32_t); i++){
    Serial.print(display_p[i], BYTE);
  }
}

void display_set(){
  uint8_t did = serial_msg[0];
  uint8_t *display_p = (uint8_t *)display;
  for(uint8_t i = 0; i < N_COL * sizeof(uint32_t); i++){
    display_p[i] = EEPROM.read(did * MAX_MSG_LEN + i + 2);
  }
}

void eeprom_clear(){
  bool confirmed = true;					

  // make sure entire message is filled with EEPROM_CLEAR bytes.
  for(uint8_t i = 0; i < EEPROM_CLEAR.n_byte - 1; i++){
    if(serial_msg[i] != EEPROM_CLEAR.id){
      confirmed = false;
      break;
    }
  }
  // do the deed
  if(confirmed){
    for(uint16_t i = 0; i <= MAX_EEPROM_ADDR; i++){
      EEPROM.write(i, 0);
    }
  }
}

void trigger_mode(){
  
}

// store serial data into serial_msg staring from first byte AFTER MID
// to be clear MID is not in serial_msg
boolean Serial_get_msg(uint8_t n_byte) {
  /*
   n_byte = message length including 1 byte MID
   */
  uint16_t i = 0;
  unsigned long start_time = millis();

  uint8_t val, next;
  boolean out;

#ifdef LISTEN // define LISTEN to listen for protocal errors
  pinMode(SPEAKER_PIN, OUTPUT);
  tone(SPEAKER_PIN, 880);
  delay(100);
  noTone(SPEAKER_PIN);
#endif

  digitalWrite(DBG, LOW);
  if(n_byte == VAR_LENGTH){
    // variable length message
    while(!Serial.available()){/* && 
				  ((millis() - start_time) < SERIAL_TIMEOUT_MS)){*/
      delay(1);
    }
    n_byte = Serial.peek();
  }
  while((i < n_byte - 1)){/* && 
			     ((millis() - start_time) < SERIAL_TIMEOUT_MS)){*/
    if(Serial.available()){
      val = Serial.read();
      if (val == SYNC_BYTE){
	sync_msg_byte_counter++;
	if(sync_msg_byte_counter == MAX_MSG_LEN){
	  // no other valid msg combination can have MAX_MSG_LEN sync bytes.
	  // sync msg recieved! break out, next char is start of new message
	  sync_msg_byte_counter = 0;
	  break;
	}
      }
      else{
	sync_msg_byte_counter = 0;
      }
      serial_msg[i++] = val;
    }
  }
  digitalWrite(DBG, HIGH);
  if(i == n_byte - 1){
    out = true;
  }
  else{
    out = false;
  }
#ifdef LISTEN // define LISTEN to listen for protocal errors
  tone(SPEAKER_PIN, 440);
  delay(100);
  noTone(SPEAKER_PIN);
#endif
  return out;
}

/*
  Get ready for next mode.
 */
void Serial_exit(void) {
  digitalWrite(DBG, LOW);
  Serial.end();
}
/*
  Respond to button presses.
 */
void Serial_inc(void) {
}
void Serial_dec(void) {
}
void Serial_mode(void) {
  switchmodes(NORMAL_MODE);  // or maybe just go back to NORMAL_MODE? or last_mode?
}

// Begin Mode Mode Code (TODO use one file per mode)
void Mode_setup(void) {
  font.getChar('M', BLUE, display);
  mode_counter = 1;
  font.getChar(Modes[mode_counter].sym, BLUE, display + 8);
}
void Mode_loop(void) {
  c3.refresh(16);
}
void Mode_exit(void) {
  digitalWrite(DBG, LOW);
}
void Mode_inc(void) {
  digitalWrite(DBG, HIGH);
  mode_counter++;
  mode_counter %= N_MAIN_MODE - 1; // skip ModeMode
  font.getChar(Modes[mode_counter].sym, BLUE, display + 8);
}
void Mode_dec(void) {
  digitalWrite(DBG, HIGH);
  if(mode_counter == 0){
    mode_counter = N_MAIN_MODE - 2;// skip ModeMode
  }
  else{
    mode_counter--;
  }
  font.getChar(Modes[mode_counter].sym, BLUE, display + 8);
}
void Mode_mode(void) {
  switchmodes(mode_counter);
}

void switchmodes(uint8_t new_mode_id){
  // only switch if we are not in this mode already
  if(new_mode_id != mode_p->id){
    last_mode_id = mode_p->id;
    c3.clear();
    mode_p->exit();
    mode_p = &Modes[new_mode_id];
    mode_p->setup();
    count = 0;
  }
}

void fire_alarm(uint8_t did){
  Serial_time_t data;
  uint8_t len;
  /* if did is 0, just sound the alarm.
   * otherwise -- look up record at did and follow perscription!
   */
  bool status = true;
  if(did && did_read(did, serial_msg, &len)){
    /* Serial.end(); */
    /* two_digits(serial_msg[0]); // DEBUGGING */
    /* c3.refresh(10000);         // DEBUGGING */
    /* two_digits(serial_msg[8]); // DEBUGGING */
    /* c3.refresh(10000);         // DEBUGGING */
    /* Serial.begin(BAUDRATE); */
    /* delay(200); */
    if(len == 11){
      /*if(serial_msg[7] == 0){ // this is a non repeating alarm, delete it from eeprom
	//TO SAVE SPACE THIS WAS MOVED TO PC SIDE
	if(!did_delete(did)){
	  Serial_send_err(EEPROM_ERR);
	  status = false;
	}
      }*/
      if(status){
	if(serial_msg[8]){ // scroll_did
	  serial_msg[0] = serial_msg[8];
	  switchmodes(SCROLL_MODE);
	}
      }
    }
  }
  else{// if(status){
    switchmodes(ALARM_MODE);
  }
}
void two_digits(uint8_t val){
  font.getChar('0' + val / 10, getColor(COLORS[color_i]), display + 2);
  font.getChar('0' + val % 10, getColor(COLORS[color_i]), display + 9);
}

void TOD_Alarm_Set(AlarmId id, uint8_t ahh, uint8_t amm, uint8_t ass, boolean alarm_set){
  Alarm.free(todAlarm);
  todAlarm = Alarm.alarmRepeat(ahh, amm, ass, fire_alarm);
  if(alarm_set){
    Alarm.enable(todAlarm);
  }
  else{
    Alarm.disable(todAlarm);
  }
}
