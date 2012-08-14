/*
 * This code should be loaded onto an I2GPS driver (GPS not used, SD not used).  
 * This allows the PEGGY2 to continue to refresh while the driver does time look up and calculations.
 * 
 * This code is released to the public domain.
 */
#include <Wire.h>
#include "SPI.h"
#include "rtcBOB.h"
#include "Time.h"
#include "MsTimer2.h"
#include "ClockTHREE.h"
#include "Peggy2_Slave.h"
#include "Peggy2_memory_map.h"
#include "messaging.h"

union data{
  uint8_t bytes[4];
  uint16_t uint16_vals[2];
  int int_val;
  float float_val;
} _converter;
  
//******************************************************************************
// I2GPS constants
#include <SD.h>
const int chipSelect = 10;
const int D1_PIN = 2;
const int D2_PIN = 3;
File myFile;

volatile uint16_t valid_msg = 0;
volatile unsigned long pulse_start = 0;
const int BIT_BUFFER_LEN = 16;
volatile boolean bits[BIT_BUFFER_LEN];
volatile unsigned long pws[BIT_BUFFER_LEN];
volatile uint16_t buffer = 1;
volatile uint16_t msg = 1;
volatile int bit_i = 0;
const short pw_thresh = 1000;
const uint16_t START_SEQ = 0x00ff;
const uint16_t STOP_SEQ = 0x005f;
const uint16_t STOP_SEQ_LEN = 8;
const uint16_t MSG_LEN = 10;
const uint16_t STARTING = 1;
const uint16_t MSG_STATE = 2;
const uint16_t STOPPING = 3;
volatile uint16_t state = STARTING;

long i = 1;

// Clear peggy2
void clear(){
  for(int slave=0; slave < 3; slave++){
    Wire.beginTransmission(PEGGY2_BASE_ADDR);
    Wire.write(PEGGY2_CLEAR_MSG);
    Wire.endTransmission();
  }
}

// Set EMSL asterisk PWM
void set_emsl(uint8_t pwm){
  Wire.beginTransmission(PEGGY2_BASE_ADDR);
  Wire.write(PEGGY2_SET_EMSL_PWM_MSG);
  Wire.write(255 - pwm);
  Wire.endTransmission();
}

// set a pixel on Peggy2
void set_pixel(uint8_t x, uint8_t y, bool on){
  if(on){
    y |= (1<<7) * on;
  }
  Wire.beginTransmission(PEGGY2_BASE_ADDR);
  Wire.write(PEGGY2_SET_PIXEL_MSG);
  Wire.write(y);
  Wire.write(x);
  Wire.endTransmission();
}

void set_row(uint8_t y, uint32_t state){
  Wire.beginTransmission(PEGGY2_BASE_ADDR);
  Wire.write(PEGGY2_SET_ROW_MSG);
  Wire.write(y);
  Wire.write((uint8_t)(state>>8 * 0));
  Wire.write((uint8_t)(state>>8 * 1));
  Wire.write((uint8_t)(state>>8 * 2));
  Wire.write((uint8_t)(state>>8 * 3));
  Wire.endTransmission();
}

void setup(){
  Serial.begin(57600);
  Serial.println("Peggy2 WordClock 1.0!");
  Serial.println("WyoLum, LLC, 2012");
  Serial.print("Using Peggy2 I2C Address: ");
  Serial.println(PEGGY2_BASE_ADDR);

  // LED are output
  pinMode(D1_PIN, OUTPUT);
  pinMode(D2_PIN, OUTPUT);

#ifdef SDINIT // NOT USED
  Serial.print("Initializing SD card...");
  pinMode(10, OUTPUT);
  digitalWrite(D1_PIN, HIGH); 
  if (!SD.begin(chipSelect)) {
    digitalWrite(D1_PIN, LOW); 
    Serial.println("SD initialization failed!");
    return;
  }
  Serial.println("SD initialization done.");
#endif
  Wire.begin();
  clear();
  delay(200);
  Serial.print("RTC Unix Time:");
  Serial.println(getTime(), DEC);
  
  // blink LEDs on I2GPS
  for(int i=0; i < 5; i++){
    digitalWrite(D1_PIN, LOW);
    digitalWrite(D2_PIN, HIGH);
    delay(200);
    digitalWrite(D1_PIN, HIGH);
    digitalWrite(D2_PIN, LOW);
    delay(200);
  }
  
}

unsigned long count = 0;

// ClockTHREE c3;                      // ClockTHREE singleton
uint32_t rows[25];               // 2X display (16 columns per display) for swapping back and forth

// language constants
uint8_t n_minute_led;               // number of minute hack leds
uint8_t n_minute_state = 30;             // number of minute hack states to cycle through
uint8_t n_byte_per_display = 4;         // number of bytes used for each 5 minunte time incriment

// globals
int display_idx;                  // display index (0 or 1)
uint8_t last_min_hack_inc = 0;    // last mininte hack incriment (to know when it has changed)
uint8_t last_time_inc = 289;        // last time incriment (to know when it has changed)
uint8_t last_pwm = 0;

void loop(){
  Serial_loop();
  time_t now = getTime();

  uint8_t word[3];                // will store start_x, start_y, length of word
  time_t spm = getTime() % 86400; // seconds past midnight
  uint16_t time_inc = spm / 300;  // 5-minute time increment are we in
  
  // which mininute hack incriment are we on?

  uint8_t minute_hack_inc = (spm % 300) / (300. / float(n_minute_state));

  // if minute hack or time has changed, update the display
  if(minute_hack_inc != last_min_hack_inc || time_inc != last_time_inc){
    // read display for next time incement
    for(uint8_t i = 0; i < 25; i++){ // clear the display
      rows[i] = 0;
    }
    getdisplay(time_inc, rows);
  
    // read minutes hack for next time incement
    rows[24] = minutes_hack(minute_hack_inc);
    for(uint8_t row_i=0; row_i<25; row_i++){
      set_row(row_i, rows[row_i]);
    }
    last_min_hack_inc = minute_hack_inc;
    last_time_inc = time_inc;
  }
  // Keep active LEDs lit
  delay(10);
  int pwm = (int)(5 * sin(count / 100.) + 6) * 5;
  if (pwm  > 255){
    pwm = 255;
  }
  if (pwm  < 0){
    pwm = 0;
  }
  if(last_pwm != pwm){
    set_emsl((uint8_t)pwm);
    last_pwm = pwm;
  }
  count++;
}

/*
 * DISPLAYS: 288 32 bit settings.  one for each 5-minute period.  up to 32 words per setting.
 * To turn on word one in ith display: 10000000000000000000000000000000
 *
 * WORDS:  3 * n + 1 bytes.  first byte is # words followed by ordered words.
 *                                    x         y       l
 *        Each word is defined by startcol, startrow, len
 */

void getword(int i, uint8_t* out){
  out[0] = pgm_read_byte(WORDS + 3 * i + 1);
  out[1] = pgm_read_byte(WORDS + 3 * i + 2);
  out[2] = pgm_read_byte(WORDS + 3 * i + 3);
}

/*
 * Prepare out to display ith time increment
 *   i -- 0 to 287 time increment indexa
 * out -- points to column data to prepare
 */
void getdisplay(int i, uint32_t* rows){
  uint8_t bits;     // holds the on off state for 8 words at a time
  uint8_t word[3];  // start columm, start row, length of the current word
  uint8_t x, y, len;

  for(uint8_t j = 0; j < n_byte_per_display; j++){ // j is a byte index 

    // read the state for the next set of 8 words
    bits = pgm_read_byte(DISPLAYS + 1 + (i * n_byte_per_display) + j);
    for(uint8_t k = 0; k < 8; k++){                     // k is a bit index
      if((bits >> k) & 1){                              // check to see if word is on or off
	getword(j * 8 + k, word);                       // if on, read location and length
	x = word[0];
	y = word[1];
	len = word[2];
	for(int m=x; m < x + len; m++){ // and display it
	  rows[2 * y    ] |= (uint32_t)1 << (2 * m);                       // rows/cols swapped
	  rows[2 * y + 1] |= (uint32_t)1 << (2 * m) ;                  // double up
	  
	  rows[2 * y    ] |= (uint32_t)1 << (2 * m + 1);                   // double up
	  rows[2 * y + 1] |= (uint32_t)1 << (2 * m + 1);               // double up
	}
      }
    }
  } 
}

/*
 * minutes_hack -- prepare display to show ith minute hack intrement
 *   i -- minute hack index
 * out -- display to prepare
 */
uint32_t minutes_hack(uint8_t i){
  // 0 <= i < 26 , 26 states
  // out, the display
  uint32_t out = 0;
  uint8_t start;

  if(i < 5){
    start = 0;
  }
  else{
    start = i - 5;
  }
  for(uint8_t j = start; j < i && j < 24; j++){
    out |= (((uint32_t)1) << j) * (j < i);
  }
  return out;
}
