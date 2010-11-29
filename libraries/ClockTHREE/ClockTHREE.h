/*
  ClockTHREE.h -- ClockTHREE RGB LED Matrix library for Arduino

  Justin Shaw
  The hardware and software for ClockTHREE have been enabled by the 
  open souce Peggy2.  Thanks to the Evil Mad Science Team for making them
  available.
  
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
  0b001001001001001001001001001001, // RED
  0b010010010010010010010010010010, // GREEN
  0b100100100100100100100100100100, // BLUE
  0b111111111111111111111111111111  // WHITE
};

const uint8_t       OFF = 0b000;
const uint8_t     GREEN = 0b001;
const uint8_t      BLUE = 0b010;
const uint8_t       RED = 0b100;
const uint8_t GREENBLUE = 0b011;
const uint8_t  REDGREEN = 0b101;
const uint8_t   REDBLUE = 0b110;
const uint8_t     WHITE = 0b111;

const uint8_t MONO = BLUE;

const uint8_t COLORS[] = {
  OFF,
  RED,
  GREEN,
  BLUE,
  REDGREEN,
  REDBLUE,
  GREENBLUE,
  WHITE
};

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
  void setPixel(uint8_t xpos, uint8_t ypos, uint8_t color);

  // Determine color value of pixel at xpos, ypos
  uint8_t getPixel(uint8_t xpos, uint8_t ypos); 
		
  //Draw a line from (x1,y1) to (x2,y2)
  void line(int8_t x1, int8_t y1, int8_t x2, int8_t y2, uint8_t color);

  //Set cursor position to (xpos,ypos)
  void moveto(int8_t xpos, int8_t ypos);
	
  //Draw line from cursor position to (xpos,ypos)
  // updating cursor position
  void lineto(int8_t xpos, int8_t ypos, uint8_t color);
  
  // Replace current display buffer
  void setdisplay(uint32_t *display);
  
  // Fill the display with single color
  void displayfill(uint8_t color);
  uint32_t* display;
  uint8_t xpos;
  uint8_t ypos;
 private:
};

void _delay(unsigned int n);
#endif


