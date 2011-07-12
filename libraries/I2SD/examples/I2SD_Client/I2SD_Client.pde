/*
  Read and write some data to the I2SD
 */

#include "C3SB.h"
#include "I2SD.h"
#include "SD.h"
#include "Wire.h"

const boolean WRITE_TEST = true;

I2SD i2sd;

void setup(){
  Serial.begin(57600);
  Wire.begin(); // DON'T FORGET THIS!!!!

  // wait for I2SD hardware to start up
  while(!i2sd.ping((uint8_t*)"PING", 4)){
    delay(100);
  }
  Serial.println("PONG validated");

  if(WRITE_TEST){
    i2sd.open("NEW_FILE.TXT", FILE_WRITE);
    i2sd.seek(0);
    char* msg="Hello from I2SD_Client.pde. "
      "Please note this is longer than 32 chararters.";
    i2sd.write((uint8_t*)msg, strlen(msg) + 1);
    i2sd.open("NEW_FILE.TXT", FILE_READ);
    uint8_t msg_back[100];
    unsigned long n_byte = i2sd.read(msg_back, 100);
    msg_back[n_byte] = NULL;
    Serial.println((char*)msg_back);
  }
  i2sd.open("TEST.TXT", FILE_READ);
}

void loop(){
  const int n_byte = 200;
  char big_data[n_byte];
  // i2sd.seek(0);
  i2sd.read((uint8_t*)big_data, n_byte - 1);
  big_data[n_byte - 1] = NULL;
  Serial.print(big_data);
  delay(500);
}

