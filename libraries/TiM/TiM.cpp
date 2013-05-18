/*--------------------------------------------------------------------
  
  --------------------------------------------------------------------*/

#include "TiM.h"
TiM::TiM(){
}
void TiM::setup(uint16_t _n_strip, uint16_t _led_per_strip, uint8_t *pins) {
  uint16_t i, j;
  n_strip = _n_strip;
  led_per_strip = _led_per_strip;
  for(i = 0; i < n_strip; i++){
    strips[i].setup(led_per_strip, pins[i], NEO_GRB + NEO_KHZ800);
  }
  setall(Color(0, 0, 0));
  show();
}

void TiM::setup(uint16_t _n_strip, uint16_t _led_per_strip, uint8_t *pins,
		uint8_t *_pixels){
  uint16_t i, j;
  n_strip = _n_strip;
  led_per_strip = _led_per_strip;
  for(i = 0; i < n_strip; i++){
    strips[i].setup(led_per_strip, pins[i], NEO_GRB + NEO_KHZ800,
		    _pixels);
  }
  setall(Color(0, 0, 0));
  show();
}

void TiM::show(void) {
  uint16_t i;
  for(i = 0; i < n_strip; i++){
    strips[i].show();
  }
}

// Set pixel color from separate R,G,B components:
void TiM::setPixel(uint16_t strip_i, uint16_t led_i, uint8_t r, uint8_t g, uint8_t b){
  strips[strip_i].setPixelColor(led_i, r, g, b);
}
void TiM::setPixel(uint16_t strip_i, uint16_t led_i, uint32_t c) {
  strips[strip_i].setPixelColor(led_i, c);
}
void TiM::setrow(uint8_t row, uint32_t c){
  uint16_t led_j;
  for(led_j = 0; led_j < led_per_strip; led_j++){
    strips[row].setPixelColor(led_j, c);
  }
}
void TiM::setall(uint32_t c){
  uint16_t strip_i;
  for(strip_i = 0; strip_i < n_strip; strip_i++){
    setrow(strip_i, c);
  }
}

// Query color from previously-set pixel (returns packed 32-bit RGB value)
uint32_t TiM::getPixel(uint16_t strip_i, uint16_t led_j) {
  return strips[strip_i].getPixelColor(led_j);
}

void TiM::scroll_down(){
  for(int8_t row = n_strip - 1; row > 0; row--){
    for(uint16_t byte_i = 0; byte_i < strips[0].numBytes; byte_i++){
      strips[row].pixels[byte_i] = strips[row - 1].pixels[byte_i];
    }
  }
}

// Convert separate R,G,B into packed 32-bit RGB color.
// Packed format is always RGB, regardless of LED strand color order.
uint32_t Color(uint8_t r, uint8_t g, uint8_t b) {
  return ((uint32_t)r << 16) | ((uint32_t)g <<  8) | b;
}

uint32_t Wheel(byte WheelPos, uint8_t imax) {
  uint32_t r, g, b;
  if(WheelPos < 85) {
    r = WheelPos * 3;
    g = 255 - WheelPos * 3;
    b = 0;
  } else if(WheelPos < 170) {
    WheelPos -= 85;
    r = 255 - WheelPos * 3;
    g = 0;
    b = WheelPos * 3;
  } else {
    WheelPos -= 170;
    r = 0;
    g = WheelPos * 3;
    b = 255 - WheelPos * 3;
  }
  r = r * imax / 255;
  g = g * imax / 255;
  b = b * imax / 255;
  return Color(r, g, b);
}

