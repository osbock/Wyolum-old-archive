/*
  ClockTHREE Test10 english test
  Display time 12:12 PM in words: "ITS TEN PAST TWELVE NOON"

  Justin Shaw Dec 12, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0
 */

#include <avr/pgmspace.h>
#include <Wire.h>
#include "ClockTHREE.h"
#include "SPI.h"
#include "english.h"

// globals
ClockTHREE c3 = ClockTHREE();
English eng = English();

uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));

void setup(){
  c3.init();
  c3.setdisplay(display);
  c3.set_column_hold(20);
}

uint32_t count = 0;
uint8_t color_i = 1;
const int display_hold = 200;

void loop(){
  eng.display_time(2010, 12, 12, 12, 12, 0, c3, BLUE);
  count++;
  c3.refresh(display_hold);
}

