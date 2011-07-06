/*
  I2SD.cpp -- I2C <--> SD interface.

  Justin Shaw
  The hardware and software for I2SD have been enabled by the 
  open souce Adafruit data logging shield.  
  Thanks to the Adafruit Team for making them
  available (http://www.ladyada.net/make/logshield/)
  
  LIBRARY VERSION: 0.01, DATED 7/5/2011

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
#include "I2SD.h"
#include "SD.h"

I2SD::I2SD(){
}
void I2SD::init(){
  pinMode(I2SD_LED1_PIN, OUTPUT);
  pinMode(I2SD_LED2_PIN, OUTPUT);
  pinMode(I2SD_SLAVE_SELECT, OUTPUT);
  if(!SD.begin(I2SD_SLAVE_SELECT)){
    err_out(INIT_FAILED);
  }
}
void I2SD::err_out(uint8_t err_no){
  digitalWrite(I2SD_LED1_PIN, HIGH); 
  digitalWrite(I2SD_LED2_PIN, LOW); 
  while(true){
    delay(1000);
    for(int i=0; i < err_no; i++){
      digitalWrite(I2SD_LED2_PIN, HIGH); 
      delay(200);
      digitalWrite(I2SD_LED2_PIN, LOW); 
      delay(200);
    }
  }
}
void I2SD::setLED1(boolean state){
  digitalWrite(I2SD_LED1_PIN, state);
}
void I2SD::setLED2(boolean state){
  digitalWrite(I2SD_LED2_PIN, state);
}
