/*
  ClockTHREE.cpp -- ClockTHREE RGB LED Matrix library for Arduino
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
  display = NULL;
  PORTD = 0U;
  DDRD = 255U;

  
  ////SET MOSI, SCK Output, all other SPI as input: 
  DDRB |= _BV(5) | _BV(3) | _BV(2) | _BV(1);
  
  //ENABLE SPI, MASTER, CLOCK RATE fck/4:  
  SPCR =  _BV(SPE) |  _BV(MSTR) ;
  SPI.transfer(0);
  SPI.transfer(0);
  SPI.transfer(0);
  SPI.transfer(0);

}

// Refresh this frame
void ClockTHREE::refresh(){
  uint8_t col_j;

  union Column_t {
    uint32_t dat32; 
    uint8_t dat8[4];
  } Column;
  col_j = 0;

  while (col_j < N_COL){
    PORTD = col_j;
    Column.dat32 = display[col_j];
    // transfer column to row drivers
#ifdef NOTDEF
    Serial.print("Col");
    Serial.print(col_j, DEC);
    Serial.print(" data");
    Serial.print(Column.dat8[0], BIN);
    Serial.print(" ");
    Serial.print(Column.dat8[1], BIN);
    Serial.print(" ");
    Serial.print(Column.dat8[2], BIN);
    Serial.print(" ");
    Serial.print(Column.dat8[3], BIN);
    Serial.println(" ");
#endif
    SPI.transfer(Column.dat8[3]);
    SPI.transfer(Column.dat8[2]);
    SPI.transfer(Column.dat8[1]);
    SPI.transfer(Column.dat8[0]);
    PORTB |= 2U;    //Latch-Pulse 
    PORTB &= 253U;
    // delay(200); // SLOW scan rate down. 
    col_j++;
  }
}

// Clears the display: LEDs set to OFF
void ClockTHREE::clear(void){
}

void ClockTHREE::setcol(uint8_t xpos, uint32_t col){
}

uint32_t ClockTHREE::getcol(uint8_t xpos){
}

// Turn a pixel to color (0 == off)
void ClockTHREE::setpoint(uint8_t xpos, uint8_t ypos, uint8_t color){
}

// Determine color value of pixel at xpos, ypos
uint8_t ClockTHREE::getpoint(uint8_t xpos, uint8_t ypos){
}
		
//Draw a line from (x1,y1) to (x2,y2)
void ClockTHREE::line(int8_t x1, int8_t y1, int8_t x2, int8_t y2, 
		      uint8_t color){
}

//Set cursor position to (xpos,ypos)
void ClockTHREE::moveto(int8_t xpos, int8_t ypos){
}
	
//Draw line from cursor position to (xpos,ypos)
// updating cursor position
void ClockTHREE::lineto(int8_t xpos, int8_t ypos, uint8_t color){
}
  
// Replace current display buffer
void ClockTHREE::setdisplay(uint32_t *_display){
  display = _display;
}


void displayfill(uint32_t *display, uint8_t color){
  uint32_t col;
  int i;
  color &= 0b00000111; // ensure 3 bit color
  col = 0;
  for(i = 0; i < N_RGB_ROW; i++){
    col |= (color << (3 * i));
  }
  for(i = 0; i < N_COL; i++){
    display[i] = col;
  }
}
