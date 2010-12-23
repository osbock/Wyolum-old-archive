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

#include <avr/pgmspace.h>
#include <Wire.h>
#include <Time.h>
#include "ClockTHREE.h"
#include "SPI.h"
#include "english.h"

// debounce mode button threshold
const uint8_t DEBOUNCE_THRESH = 200;

// Define modes
typedef void (* SetupPtr)(); // this is a typedef for setup funtions
typedef void (* LoopPtr)(); // this is a typedef for loop funtions
typedef void (* ExitPtr)(); // this is a typedef for exit funtions
typedef void (* CallBackPtr)(); // this is a typedef for callback funtions

inline void do_nothing(void){};

struct Mode{
  uint8_t id;
  SetupPtr setup;
  LoopPtr loop;
  ExitPtr exit;
  CallBackPtr inc;
  CallBackPtr dec;
  CallBackPtr mode;
};

// Begin Normal Mode Code 
void Normal_setup(void);
void Normal_loop(void);
void Normal_exit(void);
void Normal_inc(void);
void Normal_dec(void);
void Normal_mode(void);

Mode NormalMode = {0, Normal_setup, Normal_loop, Normal_exit, 
		   Normal_inc, Normal_dec, Normal_mode};

void switchmodes(uint8_t new_mode_id);
Mode *mode_p;

const uint8_t N_MODE = 5;
const uint8_t NORMAL_MODE = 0;
const uint8_t MODE_MODE = 1;
const uint8_t SET_TIME_MODE = 2;
const uint8_t SET_ALARM_MODE = 3;
const uint8_t SET_COLOR_MODE = 4;
const uint8_t PC_MODE = 5;

Mode Modes[N_MODE];

/* Event types */
const uint8_t NO_EVT = 0;
const uint8_t MODE_EVT = 1;
const uint8_t INC_EVT = 2;
const uint8_t DEC_EVT = 3;
const uint8_t EVENT_Q_SIZE = 5;

// Globals
uint8_t event_q[EVENT_Q_SIZE];
uint8_t n_evt = 0;
unsigned long last_mode_time = 0;
ClockTHREE c3;

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

void setup(){
  c3.init();
  
  mode_p = &NormalMode;
  
  // ensure mode ids are consistant.
  // NormalMode.id = NORMAL_MODE;
  // Modes[NORMAL_MODE] = NormalMode;

  
  event_q[0] = MODE_EVT;
  event_q[1] = INC_EVT;
  event_q[2] = MODE_EVT;
  n_evt = 3;

  Serial.begin(9600);
}
void loop(){
  mode_p->loop();

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
    }
    event_q[i] = NO_EVT;
  }
  n_evt = 0;
  delay(1000);
}

// Begin Normal Mode Code (TODO use one file per mode)
void Normal_setup(void) {
  Serial.println("Normal_setup()");
};
void Normal_loop(void) {
  Serial.println("Normal_loop()");
};
void Normal_exit(void) {
  Serial.println("Normal_exit()");
};
void Normal_inc(void) {
  Serial.println("Normal_inc()");
};
void Normal_dec(void) {
  Serial.println("Normal_dec()");
};
void Normal_mode(void) {
  Serial.println("Normal_mode()");
  switchmodes(MODE_MODE);
};

// Begin Mode Mode Code (TODO use one file per mode)
void Mode_setup(void) {
  Serial.println("Mode_setup()");
};
void Mode_loop(void) {
  Serial.println("Mode_loop()");
};
void Mode_exit(void) {
  Serial.println("Mode_exit()");
};
void Mode_inc(void) {
  Serial.println("Mode_inc()");
};
void Mode_dec(void) {
  Serial.println("Mode_dec()");
};
void Mode_mode(void) {
  Serial.println("Mode_mode()");
  switchmodes(NORMAL_MODE);
};

void switchmodes(uint8_t new_mode_id){
  mode_p->exit();
  mode_p = &Modes[new_mode_id];
  mode_p->setup();
}
