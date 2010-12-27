/*
  Delivery ClockTHREE Word Clock App
  Display time 12:12 PM in words using english template
  Supports different modes:
  Normal
  Mode (Mode to switch modes)
  SetTime
  SetAlarm
  SetColor
  PC

  Justin Shaw Dec 22, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0
 */
#define CLOCKTWO

#include <avr/pgmspace.h>
#include <Wire.h>
#include <Time.h>
#include "MsTimer2.h"
#include "ClockTHREE.h"
#include "SPI.h"
#include "english.h"
#include "font.h"
#include "rtcBOB.h"

// debounce mode button threshold
const uint8_t DEBOUNCE_THRESH = 100;

// Define modes
typedef void (* SetupPtr)(); // this is a typedef for setup funtions
typedef void (* LoopPtr)(); // this is a typedef for loop funtions
typedef void (* ExitPtr)(); // this is a typedef for exit funtions
typedef void (* CallBackPtr)(); // this is a typedef for callback funtions

inline void do_nothing(void){}

struct Mode{
  uint8_t id;      // Mode ID
  char sym;        // ASCII Symbol for mode
  SetupPtr setup;  // to be called when Mode is initialized
  LoopPtr loop;    // to be called as often as possible when mode is active
  ExitPtr exit;    // to be called when mode is exited.
  CallBackPtr inc; // to be called when increment button is pushed
  CallBackPtr dec; // to be called when decrement button is pushed
  CallBackPtr mode;// to be called when mode button is pushed
};

// Default display -- twice as large as is needed
uint32_t *display = (uint32_t*)calloc(2 * N_COL, sizeof(uint32_t));
Mode *mode_p;

const uint8_t N_MODE = 9;
const uint8_t N_MAIN_MODE = 6;
const uint8_t N_SUB_MODE = 3;

const uint8_t NORMAL_MODE = 0;
const uint8_t SET_TIME_MODE = 1;
const uint8_t SET_COLOR_MODE = 2;
const uint8_t SET_ALARM_MODE = 3;
const uint8_t PC_MODE = 4;
const uint8_t MODE_MODE = 5;

// Sub Modes get ID > N_MODE
const uint8_t SECONDS_MODE = 6;
const uint8_t ALARM_MODE = 7;
const uint8_t TEMPERATURE_MODE = 8;

Mode Modes[N_MODE];

typedef enum {YEAR, MONTH, DAY, HOUR, MINUTE, SECOND} unit_t;
typedef enum {DEG_C, DEG_F} temp_unit_t;

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
Mode SetTimeMode = {SET_TIME_MODE, 
		    'T', SetTime_setup,SetTime_loop,SetTime_exit,
		    SetTime_inc, SetTime_dec, SetTime_mode};
Mode SetColorMode = {SET_COLOR_MODE, 
		     'C', SetColor_setup, SetColor_loop, SetColor_exit, 
		     SetColor_inc, SetColor_dec, SetColor_mode};
Mode SetAlarmMode = {SET_ALARM_MODE, 
		     2, SetAlarm_setup,SetAlarm_loop,SetAlarm_exit,
		     SetAlarm_inc, SetAlarm_dec, SetAlarm_mode};
Mode PCMode = {PC_MODE, 
	       'P', PC_setup,PC_loop,PC_exit,
	       PC_inc,PC_dec,PC_mode};
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

// Globals
uint8_t event_q[EVENT_Q_SIZE];
uint8_t n_evt = 0;
unsigned long last_mode_time = 0;
unsigned long last_inc_time = 0;
unsigned long last_dec_time = 0;
ClockTHREE c3;
English lang = English();
Font font = Font();
time_t t;
uint8_t mode_counter;
uint8_t color_i = 3;
unsigned long count = 0;
uint16_t YY;
uint8_t MM, DD, hh, mm, ss;
uint8_t ahh, amm, ass;
boolean tick = true;
unit_t SetTime_unit = YEAR;
temp_unit_t temp_unit = DEG_C;
boolean alarm_set = false;

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
  setSyncInterval(3600000);      // update hour (and on boot)
  update_time();
  getRTC_alarm(&ahh, &amm, &ass, &alarm_set, &temp_unit);

  mode_p = &NormalMode;

  // ensure mode ids are consistant.
  Modes[NORMAL_MODE] = NormalMode;
  Modes[SET_TIME_MODE] = SetTimeMode;
  Modes[SET_COLOR_MODE] = SetColorMode;
  Modes[SET_ALARM_MODE] = SetAlarmMode;
  Modes[PC_MODE] = PCMode;
  Modes[MODE_MODE] = ModeMode;

  // Sub Modes
  Modes[SECONDS_MODE] = SecondsMode;
  Modes[ALARM_MODE] = AlarmMode;
  Modes[TEMPERATURE_MODE] = TemperatureMode;
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
  
  mode_p->loop();
  count++;

  // process new events
  for(int i = 0; i < n_evt; i++){
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
	if((alarm_set) && (mm == amm) && (hh == ahh)){
	  switchmodes(ALARM_MODE);
	}
      }
    }
    event_q[i] = NO_EVT;
  }
  n_evt = 0;
}

// Begin Normal Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
*/
void Normal_setup(void){
  tick = true;
}
void Normal_loop(void) {
  if((count == 0 || ss % 6 == 0 || ss % 4 == 0) && tick){
    // minutes hack updates every six seconds 
    if(alarm_set){
      lang.display_word(c3, DARK, alarm_off_led);
      lang.display_word(c3, MONO, alarm_on_led);
    }
    else{
      lang.display_word(c3, DARK, alarm_off_led);
      lang.display_word(c3, DARK, alarm_on_led);
    }
    lang.display_time(YY, MM, DD, hh, mm, ss,
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
  switchmodes(NORMAL_MODE);
}

// Sub mode of normal mode ** display seconds
void Temperature_setup(void){
  if(temp_unit == DEG_C){
    lang.display_word(c3, MONO, c_led);
  }
  else{
    lang.display_word(c3, MONO, f_led);
  }
}
void Temperature_loop(){
  int temp = getTemp();
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
    lang.display_word(c3, DARK, f_led);
    lang.display_word(c3, getColor(COLORS[color_i]), c_led);
  }
  else{
    temp_unit = DEG_F;
    lang.display_word(c3, DARK, c_led);
    lang.display_word(c3, getColor(COLORS[color_i]), f_led);
  }
}
void Temperature_dec(){
  switchmodes(NORMAL_MODE);
}
void Temperature_mode(){
  switchmodes(NORMAL_MODE);
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
  c3.refresh(16);
}
void Alarm_exit(void) {
  // resync with RTC and start ticking again
  update_time();
  MsTimer2::set(1000, tick_interrupt); // 1ms period
  MsTimer2::start();
  digitalWrite(SPEAKER_PIN, HIGH);
}
void Alarm_mode(){
  switchmodes(NORMAL_MODE);
}

// Begin SetTime Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
*/
void SetTime_setup(void){
  MsTimer2::stop(); // Ticks stop while setting time
  getTime(); // sync with rtcBOB
  SetTime_unit = YEAR;
  lang.display_word(c3, MONO, year_led);
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
    lang.display_word(c3, MONO, month_led);
    break;
  case MONTH:
    SetTime_unit = DAY;
    lang.display_word(c3, MONO, day_led);
    break;
  case DAY:
    SetTime_unit = HOUR;
    lang.display_word(c3, MONO, hour_led);
    break;
  case HOUR:
    SetTime_unit = MINUTE;
    lang.display_word(c3, MONO, minute_led);
    break;
  default:
    switchmodes(NORMAL_MODE);
    break;
  }
}

// Begin SetAlarm Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
*/
void SetAlarm_setup(void){
  lang.display_word(c3, MONO, alarm);
  lang.display_time(YY, MM, DD, ahh, amm, ass,
		    c3, getColor(COLORS[color_i]), 0, false, false);
  lang.display_word(c3, MONO, hour_led);
  SetTime_unit = HOUR;
}
void SetAlarm_loop(void){
  c3.refresh(16);
}
/*
  Get ready for next mode.
 */
void SetAlarm_exit(void){
  setRTC_alarm(ahh, amm, ass, alarm_set, temp_unit);
}
/*
  Respond to button presses.
 */
void SetAlarm_inc(void){
  switch(SetTime_unit){
  case HOUR:
    ahh = (ahh + 1) % 24;
    lang.display_time(YY, MM, DD, ahh, amm, ass,
		      c3, getColor(COLORS[color_i]), 0, false, false);
    break;
  case MINUTE:
    amm = (amm + 5) % 60;
    ass = 0;
    lang.display_time(YY, MM, DD, ahh, amm, ass,
		      c3, getColor(COLORS[color_i]), 0, false, false);
    break;
  case SECOND:
    if(!alarm_set){
      alarm_set = true;
      lang.display_word(c3, DARK, alarm_off_led);
      lang.display_word(c3, MONO, alarm_on_led);
    }
    else{
      alarm_set = false;
      lang.display_word(c3, DARK, alarm_on_led);
      lang.display_word(c3, MONO, alarm_off_led);
    }
    break;
  default:
    switchmodes(NORMAL_MODE); // Error?! get out of here.
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
    lang.display_time(YY, MM, DD, ahh, amm, ass,
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
    lang.display_time(YY, MM, DD, ahh, amm, ass,
		      c3, getColor(COLORS[color_i]), 0, false, false);
    break;
  case SECOND:
    if(!alarm_set){
      alarm_set = true;
      lang.display_word(c3, DARK, alarm_off_led);
      lang.display_word(c3, MONO, alarm_on_led);
    }
    else{
      alarm_set = false;
      lang.display_word(c3, DARK, alarm_on_led);
      lang.display_word(c3, MONO, alarm_off_led);
    }
    break;
  default:
    switchmodes(NORMAL_MODE); // Error?! get out of here.
  }
}
void SetAlarm_mode(void){
  switch(SetTime_unit){
  case HOUR:
    SetTime_unit = MINUTE;
    lang.display_word(c3, DARK, hour_led);
    lang.display_word(c3, getColor(COLORS[color_i]), minute_led);
    break;
  case MINUTE:
    SetTime_unit = SECOND;
    c3.clear();
    if(alarm_set){
      lang.display_word(c3, MONO, alarm_on_led);
    }
    else{
      lang.display_word(c3, MONO, alarm_off_led);
    }
    break;
  case SECOND:
    // fall though to default
  default:
    switchmodes(NORMAL_MODE);
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
  digitalWrite(DBG, HIGH);
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
  switchmodes(NORMAL_MODE);
}

// Begin PC Mode
/* 
   Initalize mode.
*/
void PC_setup(void){
  tick = true;
  lang.display_word(c3, MONO, usb_led);
  Serial.begin(9600);
}
void PC_loop(void) {
  while(Serial.available()){
    Serial.print(Serial.read(), BYTE);
  }
}
/*
  Get ready for next mode.
 */
void PC_exit(void) {
  Serial.end();
}
/*
  Respond to button presses.
 */
void PC_inc(void) {
}
void PC_dec(void) {
}
void PC_mode(void) {
  switchmodes(NORMAL_MODE);
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
  c3.clear();
  mode_p->exit();
  mode_p = &Modes[new_mode_id];
  mode_p->setup();
  count = 0;
}

void two_digits(uint8_t val){
  font.getChar('0' + val / 10, getColor(COLORS[color_i]), display + 2);
  font.getChar('0' + val % 10, getColor(COLORS[color_i]), display + 9);
}
