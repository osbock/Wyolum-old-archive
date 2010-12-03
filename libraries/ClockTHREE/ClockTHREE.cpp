/*
  ClockTHREE.cpp -- ClockTHREE RGB LED Matrix library for Arduino

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

#include "ClockTHREE.h"
#include "SPI.h"

ClockTHREE::ClockTHREE(){
}
    
// Hardware initialization
void ClockTHREE::init(){
  SPI.begin(); // start SPI communications

  pinMode(DBG, OUTPUT);
  pinMode(COL_DRIVER_ENABLE, OUTPUT);

  // digitalWrite(COL_DRIVER_ENABLE, LOW); // Enable col driver (slower)
  PORTC &= 0b11110111; // Enable col driver
  // PORTC |= 0b00001000; // Disable col driver (here for reference)

  display = NULL;

  // set column driver outputs.
  DDRD |= 0b00001111;
  
  ////SET MOSI, SCK Output, all other SPI as input: 
  DDRB |= 0b00101110;
  
  //ENABLE SPI, MASTER, CLOCK RATE fck/4:  
  SPCR =  _BV(SPE) |  _BV(MSTR) ;
  SPI.transfer(0);
  SPI.transfer(0);
  SPI.transfer(0);
  SPI.transfer(0);

}

// Scan current display if it is not NULL
void ClockTHREE::refresh(){
  uint8_t col_j;

  union Column_t {
    uint32_t dat32; 
    uint8_t dat8[4];
  } Column;
  col_j = 0;
  
  if(display != NULL){
    // PORTC &= 0b11110111; // Enable col driver
    // for(col_j=0; col_j < N_COL; col_j++){
    while (col_j < N_COL){
      Column.dat32 = display[col_j];
      // transfer column to row drivers
      SPI.transfer(Column.dat8[3]);
      SPI.transfer(Column.dat8[2]);
      SPI.transfer(Column.dat8[1]);
      PORTC |= 0b00001000; // Disable col driver 
      SPI.transfer(Column.dat8[0]);
      PORTB |= 0b00000010; // Start latch pulse 
      PORTB &= 0b11111101; // End latch pulse 
      PORTD = (PORTD & 0b11110000) | col_j; //only impacts lower 4 bits of PORTD
      PORTC &= 0b11110111; // Enable col driver
      col_j++;
      _delay(500);
    }
    // PORTC |= 0b00001000; // Disable col driver
  }
}

// Clears the display: LEDs set to OFF
void ClockTHREE::clear(void){
  displayfill(DARK);
}

// Set column at xpos to col.  Use setPixel to set an individual pixel.
void ClockTHREE::setcol(uint8_t xpos, uint32_t col){
  if(display != NULL){
    display[xpos] = col;
  }
}

// Return column value at xpos.  Use getPixel to get an individual pixel.
uint32_t ClockTHREE::getcol(uint8_t xpos){
  uint32_t out;
  if(display != NULL){
    out = display[xpos];
  }
  else{
    out = 0;
  }
  return out;
}

/* 
 * Turn a pixel to color (0 == off)
 * for rows 10 and 11:
 *   if color is not MONO turn pixel off
 *   if color is MONO turn pixel on
 */
void ClockTHREE::setPixel(uint8_t xpos, uint8_t ypos, uint8_t color){
  if(display != NULL){
    // RGB pixels
    color &= (uint8_t)0b111; // ensure 3 bit color
    if(ypos < N_RGB_ROW and xpos < N_COL){
      // clear pixel
      display[xpos] &= ~((uint32_t)0b111 << (3 * ypos)); 

      // set pixel to color
      display[xpos] |= ((uint32_t)color << (3 * ypos)); 
    }
    // MONO pixels
    else if(ypos < N_ROW){ // ROW 10 or 11
      if(ypos == 10){
	if(color == MONO){
	  display[xpos] |= 0b01000000000000000000000000000000; // set
	}
	else{
	  display[xpos] &= 0b10111111111111111111111111111111; // clear
	}
      }
      else{ // ypos == 11
	if(color == MONO){
	  display[xpos] |= 0b10000000000000000000000000000000; // set
	}
	else{
	  display[xpos] &= 0b01111111111111111111111111111111; // clear
	}
      }
    }
  }
}

/*
 * Return color value of pixel at xpos, ypos
 * For rows 10 and 11, return 0b000 if MONO pixel is set
 * Otherwise return MONO
 */
uint8_t ClockTHREE::getPixel(uint8_t xpos, uint8_t ypos){
  uint8_t out = 0;

  if(display != NULL){
    // RGB pixels
    if(ypos < N_RGB_ROW){
      out = (display[xpos] >> (3 * ypos)) & 0b00000111;
    }
    // MONO pixels
    else if(ypos < N_ROW){ // ROW 10 or 11
      if(ypos == 10){ // ROW 10
	if((display[xpos] >> 30) & 0b01){
	  out = MONO;
	}
      }
      else{ // ROW 11
	if((display[xpos] >> 30) & 0b10){
	  out = MONO;
	}
      }
    }
  }
}
		
//Draw a line from (x0,y0) to (x1,y1)
void ClockTHREE::line(int8_t x0, int8_t y0, int8_t x1, int8_t y1, 
		      uint8_t color){
  double t;
  double d;
  uint8_t x, y, i;
    
  if(display != NULL){
    // determine how many steps we need
    d = abs(x1 - x0) > abs(y1 - y0) ? abs(x1 - x0): abs(y1 - y0);
    for(i = 0; i <= d; i++){
      x = round(x0 + i * (x1 - x0) / d);
      y = round(y0 + i * (y1 - y0) / d);
      setPixel(x, y, color);
    }
  }
}

//Set cursor position to (xpos,ypos)
void ClockTHREE::moveto(int8_t _xpos, int8_t _ypos){
  xpos = _xpos;
  ypos = _ypos;
}
	
//Draw line from cursor position to (xpos,ypos)
// updating cursor position
void ClockTHREE::lineto(int8_t _xpos, int8_t _ypos, uint8_t color){
  line(xpos, ypos, _xpos, _ypos, color);
  moveto(_xpos, _ypos);
}
  
// Replace current display buffer
void ClockTHREE::setdisplay(uint32_t *_display){
  display = _display;
}


void ClockTHREE::displayfill(uint8_t color){
  uint32_t col;
  int i;
  if(display != NULL){
    color &= 0b111; // ensure 3 bit color
    col = 0;
    for(i = 0; i < N_RGB_ROW; i++){
      col |= (color << (3 * i));
    }
    if(color == MONO){
      col |= 0b11 << 30;
    }
    for(i = 0; i < N_COL; i++){
      display[i] = col;
    }
  }
}

void _delay(unsigned int n){
  unsigned int delayvar;
  delayvar = 0; 
  while (delayvar <=  n){ 
    asm("nop");  
    delayvar++;
  }
}
