/*
  I2SD.h -- I2C <--> SD interface.

  Justin Shaw
  The hardware and software for I2SD have been enabled by the 
  open souce Adafruit data logging shield.  
  Thanks to the Adafruit Team for making them
  available (http://www.ladyada.net/make/logshield/)
  
  LIBRARY DATED 7/5/2011

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
#ifndef I2SD_H
#define I2SD_H
#include <WProgram.h>
#include <inttypes.h>
#include "C3SB.h"
#include "SD.h"
#include "Wire.h"

const uint8_t I2SD_TX_LED_PIN = 2;
const uint8_t I2SD_RX_LED_PIN = 3;
const uint8_t I2SD_SLAVE_SELECT = 10;

const uint8_t I2SD_INIT_ERROR = 3;
const uint8_t I2SD_OPEN_ERROR = 4;
const uint8_t I2SD_MODE_ERROR = 5;

const uint8_t I2SD_SLAVE_ID = 81;

// message types
const uint8_t I2SD_READ_MSG = 1;
const uint8_t I2SD_WRITE_MSG = 2;
const uint8_t I2SD_SEEK_MSG = 3;
const uint8_t I2SD_OPEN_MSG = 4;

class I2SD{
 public:
  I2SD();
  void init();
  void err_out(uint8_t err_no, char* err_msg);
  void setTX_LED(boolean state);
  void setRX_LED(boolean state);
  void open(char* filename, uint8_t mode);
  void close();
  File file;
  uint8_t file_mode;
  unsigned long cursor;
 private:
};
void I2SD_onRequest();
void I2SD_onReceive(int n_byte);
union Address_t {
  uint32_t dat32; 
  char char4[4];
};

#endif
