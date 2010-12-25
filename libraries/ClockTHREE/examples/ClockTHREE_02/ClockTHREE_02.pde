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
const uint8_t DEBOUNCE_THRESH = 200;

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

// Default display
uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));

// Begin Normal mode declarations

Mode NormalMode = {0, 'N', Normal_setup, Normal_loop, Normal_exit, 
		   Normal_inc, Normal_dec, Normal_mode};
Mode SetTimeMode = {0, 'T', do_nothing,do_nothing,do_nothing,
		    do_nothing,do_nothing,do_nothing};
Mode SetColorMode = {0, 'C', SetColor_setup, SetColor_loop, SetColor_exit, 
		   SetColor_inc, SetColor_dec, SetColor_mode};
Mode SetAlarmMode = {0, 2, do_nothing,do_nothing,do_nothing,
		    do_nothing,do_nothing,do_nothing};
Mode PCMode = {0, 'P', do_nothing,do_nothing,do_nothing,
		    do_nothing,do_nothing,do_nothing};
Mode ModeMode = {0, 'M', Mode_setup, Mode_loop, Mode_exit, 
		 Mode_inc, Mode_dec, Mode_mode};

Mode *mode_p;

const uint8_t N_MODE = 6;
const uint8_t NORMAL_MODE = 0;
const uint8_t SET_TIME_MODE = 1;
const uint8_t SET_COLOR_MODE = 2;
const uint8_t SET_ALARM_MODE = 3;
const uint8_t PC_MODE = 4;
const uint8_t MODE_MODE = 5;

Mode Modes[N_MODE];

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
boolean tick = true;

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

void setup(){
  Wire.begin();
  c3.init();
  setSyncProvider(getTime);      // RTC
  setSyncInterval(3600000);      // update hour (and on boot)
  update_time();

  mode_p = &NormalMode;

  // ensure mode ids are consistant.
  NormalMode.id = NORMAL_MODE;
  Modes[NORMAL_MODE] = NormalMode;

  SetTimeMode.id = SET_TIME_MODE;
  Modes[SET_TIME_MODE] = SetTimeMode;

  SetColorMode.id = SET_COLOR_MODE;
  Modes[SET_COLOR_MODE] = SetColorMode;

  SetAlarmMode.id = SET_ALARM_MODE;
  Modes[SET_ALARM_MODE] = SetAlarmMode;

  PCMode.id = PC_MODE;
  Modes[PC_MODE] = PCMode;

  ModeMode.id = MODE_MODE;
  Modes[MODE_MODE] = ModeMode;
  
  mode_p->setup();

  // attachInterrupt(0, mode_interrupt, FALLING); // Does not work on C2
  // attachInterrupt(1, inc_interrupt, FALLING);  // Does not work on C2

  c3.setdisplay(display);
  c3.set_column_hold(50);

  MsTimer2::set(1000, tick_interrupt); // 1ms period
  MsTimer2::start();

}
void loop(){
  //check button status // C2 hack
  
  if(PIND & 1<<5){
    mode_interrupt();
  }
  if(PIND & 1 << 6){
    inc_interrupt();
  }
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
      }
    }
    event_q[i] = NO_EVT;
  }
  n_evt = 0;
}

// Begin Normal Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
   setup() can assume "display" is clear and ready to go.
*/
void Normal_setup(void){
  tick = true;
}
void Normal_loop(void) {
  if((ss % 6 == 0 || ss % 4 == 0) && tick){
    // minutes hack updates every six seconds
    lang.display_time(YY, MM, DD, hh, mm, ss,
		      c3, COLORS[color_i], 32);
    tick = false;
  }
  else{
    tick = true;
    c3.refresh(32);
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
}
void Normal_dec(void) {
}
void Normal_mode(void) {
  switchmodes(MODE_MODE);
}

// Begin SetColor Mode Code (TODO use one file per mode)
/* 
   Initalize mode.
   setup() can assume "display" is clear and ready to go.
*/
void SetColor_setup(void) {
  tick=true;
}
void SetColor_loop(void) {
  Normal_loop();
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
  if(mode_counter == 0){
    color_i = N_COLOR - 1;// DARK=OFF
  }
  else{
    color_i--;
  }
}
void SetColor_mode(void) {
  switchmodes(NORMAL_MODE);
}

// Begin Mode Mode Code (TODO use one file per mode)
void Mode_setup(void) {
  font.getChar('M', GREENBLUE, display);
  mode_counter = 1;
  font.getChar(Modes[mode_counter].sym, RED, display + 8);
}
void Mode_loop(void) {
  c3.refresh(100);
}
void Mode_exit(void) {
  digitalWrite(DBG, LOW);
}
void Mode_inc(void) {
  digitalWrite(DBG, HIGH);
  mode_counter++;
  mode_counter %= N_MODE - 1; // skip ModeMode
  font.getChar(Modes[mode_counter].sym, RED, display + 8);
}
void Mode_dec(void) {
  digitalWrite(DBG, HIGH);
  if(mode_counter == 0){
    mode_counter = N_MODE - 2;// skip ModeMode
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
}
