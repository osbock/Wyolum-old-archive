#include "ClockTHREE.h"
#include "SPI.h"

ClockTHREE c3 = ClockTHREE();
uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));
void setup(){
  c3.init();
  displayfill(display, RED);
  c3.setdisplay(display);
  Serial.begin(9600);
}
uint32_t count = 0;
void loop(){
  uint8_t color_i;
  
  if(count % 4000 == 0){
    color_i = count / 4000;
    color_i %=  N_COLOR;
    displayfill(display, colors[color_i]);
    if(color_i == 1){
      delay(500);
    }
  }
  
  c3.refresh();
  count++;
}
