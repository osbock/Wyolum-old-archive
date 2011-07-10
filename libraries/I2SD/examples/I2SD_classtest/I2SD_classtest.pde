#include <inttypes.h>
#include "I2SD.h"
#include "SD.h"
#include "Wire.h"
#include "C3SB.h"

I2SD i2sd = I2SD();
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
