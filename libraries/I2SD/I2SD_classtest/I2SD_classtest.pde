#include "I2SD.h"
#include "SD.h"

I2SD i2sd = I2SD();
File file;

void setup(){
  i2sd.init();
  file = SD.open("test.txt");
  if(!file){
    i2sd.err_out(OPEN_FILE_FAILED);
  }
}
void loop(){
  i2sd.setLED1(HIGH);
  i2sd.setLED2(LOW);
  delay(1000);
  i2sd.setLED1(LOW);
  i2sd.setLED2(HIGH);
  delay(1000);
}
