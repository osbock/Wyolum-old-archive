/*
  I2SD_Slave class handles all of the I2C events.  Load this code
  directly onto the I2SD device.  


  This is slave code.
  For client code, see
  
 */

#include <inttypes.h>
#include "I2SD_Slave.h"
#include "SD.h"
#include "Wire.h"
#include "C3SB.h"

I2SD_Slave i2sd = I2SD_Slave();
// File file;

void setup(){
  Serial.begin(57600);
  Wire.begin(I2SD_SLAVE_ID);
  i2sd.init();
}
void loop(){
  // alternate LEDs to show it made it here.
  delay(1000);
}
