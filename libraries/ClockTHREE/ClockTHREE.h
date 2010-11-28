/*
  ClockTHREE.h -- ClockTHREE RGB LED Matrix library for Arduino
  LIBRARY VERSION: 0.01, DATED 26/11/2010

Licenced under Creative Commons Attribution.
Attribution 3.0 Unported
This license is acceptable for Free Cultural Works.
You are free:

    * to Share — to copy, distribute and transmit the work
    * to Remix — to adapt the work
    *

Under the following conditions:

    *

      Attribution — You must attribute the work in the manner specified by 
the author or licensor (but not in any way that suggests that they endorse
you or your use of the work).

      Attribute this work:
      Information
      What does "Attribute this work" mean?
      The page you came from contained embedded licensing metadata, including
how the creator wishes to be attributed for re-use. You can use the HTML here 
to cite the work. Doing so will also include metadata on your page so that 
others can find the original work as well.

With the understanding that:
    * Waiver — Any of the above conditions can be waived if you get permission 
      from the copyright holder.
    * Public Domain — Where the work or any of its elements is in the public 
      domain under applicable law, that status is in no way affected by the 
      license.
    * Other Rights — In no way are any of the following rights affected by the
      license:
          o Your fair dealing or fair use rights, or other applicable copyright
	    exceptions and limitations;
          o The author's moral rights;
          o Rights other persons may have either in the work itself or in how 
            the work is used, such as publicity or privacy rights.
    * Notice — For any reuse or distribution, you must make clear to others 
     the license terms of this work. The best way to do this is with a link 
     to this web page.
*/
#ifndef ClockTHREE_h
#define ClockTHREE_h
#include <inttypes.h>

const int     N_ROW = 12;
const int N_RGB_ROW = 10;
const int     N_COL = 16;
const int   N_COLOR = 8;

const int               DBG = 12;
const int COL_DRIVER_ENABLE = 17;

// bitmasks for the colors
const unsigned long RGBW_MASKS[] = {
  0b00001001001001001001001001001001, // RED
  0b00010010010010010010010010010010, // GREEN
  0b11100100100100100100100100100100, // BLUE
  0b00111111111111111111111111111111  // WHITE
};

const uint8_t colors[] = {
  0b00000000,
  0b00000001,
  0b00000010,
  0b00000100,
  0b00000011,
  0b00000101,
  0b00000110,
  0b00000111,
};
const uint8_t OFF = colors[0];
const uint8_t RED = colors[1];
const uint8_t GREEN = colors[2];
const uint8_t BLUE = colors[3];
const uint8_t REDGREEN = colors[4];
const uint8_t REDBLUE = colors[5];
const uint8_t GREENBLUE = colors[6];
const uint8_t WHITE = colors[7];

class ClockTHREE
{ 
 public:
  ClockTHREE(); 
    
  // Hardware initialization
  void init();

  // Refresh this frame
  void refresh();

  // Clears the display: LEDs set to OFF
  void clear(void);

  void setcol(uint8_t xpos, uint32_t col);
  uint32_t getcol(uint8_t xpos);

  // Turn a pixel to color (0 == off)
  void setpoint(uint8_t xpos, uint8_t ypos, uint8_t color);

  // Determine color value of pixel at xpos, ypos
  uint8_t getpoint(uint8_t xpos, uint8_t ypos); 
		
  //Draw a line from (x1,y1) to (x2,y2)
  void line(int8_t x1, int8_t y1, int8_t x2, int8_t y2, uint8_t color);

  //Set cursor position to (xpos,ypos)
  void moveto(int8_t xpos, int8_t ypos);
	
  //Draw line from cursor position to (xpos,ypos)
  // updating cursor position
  void lineto(int8_t xpos, int8_t ypos, uint8_t color);
  
  // Replace current display buffer
  void setdisplay(uint32_t *display);
  
  uint32_t* display;
  uint8_t _xcursor;
  uint8_t _ycursor;
 private:
};

void displayfill(uint32_t *display, uint8_t color);
#endif


