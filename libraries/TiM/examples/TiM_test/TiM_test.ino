#include "TiM.h"
#include "Adafruit_NeoPixel.h"
TiM tim;

// Use Arduino Pins 2-9 for controling the rows of TiM
uint8_t pins[8] = {2, 3, 4, 5, 6, 7, 8, 9};

void setup(){
  // each Pin has 32 leds
  //    #rows #led pin_ids
  tim.setup(8, 32, pins);
}

uint32_t count = 0;
int row, col;

void loop(){
  // grab a color from the color wheel
  //                     HUE 0-255  brightness 0-255
  uint32_t color = Wheel(count % 256, 255);
  
  // turn off column
  for(row = 0; row < 8; row++){
    tim.setPixel(row, col, 0);
  }

  // turn on new column
  col++;
  col %= 32;
  for(row = 0; row < 8; row++){
    tim.setPixel(row, col, color);
  }

  // update the display
  tim.show();
  count++;
  delay(100);
}

