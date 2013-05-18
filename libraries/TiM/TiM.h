/*--------------------------------------------------------------------
  This file is part of the TiM library.
  
  TiM is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation, either version 3 of
  the License, or (at your option) any later version.

  TiM is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with TiM.  If not, see
  <http://www.gnu.org/licenses/>.
  --------------------------------------------------------------------*/
#ifndef TIM_H
#define TIM_H

#include <Arduino.h>
#include "Adafruit_NeoPixel.h"

class TiM {
 public:
  // Constructor
  TiM();

  // Setup number of LEDs, pin number, LED type
  void setup(uint16_t n_strip, uint16_t led_per_strip, uint8_t *pins);
  void setup(uint16_t n_strip, uint16_t led_per_strip, uint8_t *pins,
	     uint8_t *_pixels);

  void begin(void);
  void show(void);
  void setPixel(uint16_t strip_i, uint16_t led_j, uint8_t r, uint8_t g, uint8_t b); /*  */
  void setPixel(uint16_t strip_i, uint16_t led_j, uint32_t c);
  void setrow(uint8_t row, uint32_t c);
  void setall(uint32_t c);

  uint16_t numStrip(void);
  uint32_t getPixel(uint16_t strip_i, uint16_t led_j);
  void scroll_down();
  uint16_t led_per_strip;
  Adafruit_NeoPixel strips[8];
  uint16_t n_strip;
private:

  uint8_t *pins;           // Output pins
};
uint32_t Color(uint8_t r, uint8_t g, uint8_t b);
uint32_t Wheel(byte WheelPos, uint8_t imax);
#endif
