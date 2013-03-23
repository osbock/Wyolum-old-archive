#include "TiM.h"
#include "Adafruit_NeoPixel.h"
TiM tim;

uint8_t pins[8] = {2, 3, 4, 5, 6, 7, 8, 9};
void setup(){
  tim.setup(8, 32, pins);
}

uint32_t count = 0;
int row, col;

void loop(){
  uint32_t color = Wheel(count % 256, 255);
  for(row = 0; row < 8; row++){
    tim.setPixel(row, col, 0);
  }
  col++;
  col %= 32;
  for(row = 0; row < 8; row++){
    tim.setPixel(row, col, color);
  }
  tim.show();
  count++;
}

