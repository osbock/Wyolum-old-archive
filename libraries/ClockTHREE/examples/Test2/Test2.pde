/*
  ClockTHREE Test2 -- Color Test
  Justin Shaw Nov 28, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0 Unported
 */

#include "ClockTHREE.h"
#include "SPI.h"
#include "Wire.h"
#include "Time.h"

ClockTHREE c3 = ClockTHREE();
uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));
void setup(){
  c3.init();
  c3.setdisplay(display);
  c3.displayfill(RED);
}
uint32_t count = 4000;
boolean dbg = true;
const int hold = 500;
void loop(){
  uint8_t color_i;
  
  if(count % hold == 0){
    color_i = count / hold;
    color_i %=  N_COLOR;
    c3.displayfill(COLORS[color_i]);
    // c3.displayfill(WHITE);
    dbg = !dbg;
    digitalWrite(DBG, dbg);
  }
  
  c3.refresh();
  count++;
}
