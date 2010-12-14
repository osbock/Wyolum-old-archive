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
English lang = English();

uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));

void setup(){
  c3.init();
  c3.setdisplay(display);
  c3.set_column_hold(20);
}

uint32_t count = 0;
uint8_t color_i = 1;
const int display_hold = 50;
int YY = 2010;
int MM = 1;
int DD = 1;
int hh = 0;
int mm = 0;
int ss = 0;

void loop(){
  mm += 5;
  if(mm == 60){
    hh += 1;
    mm = 0;
    if(hh == 24){
      DD += 1;
      hh = 0;
    }
  }
  lang.display_time(YY, MM, DD, hh, mm, ss, c3, BLUE, 50);
}
