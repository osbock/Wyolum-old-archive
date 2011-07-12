/*
  Read and write some data to the I2SD
 */

#include "C3SB.h"
#include "I2SD.h"
#include "SD.h"
#include "Wire.h"

const uint WRITE_TEST = true;

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
    uint8_t msg_back[strlen(msg) + 1];
    i2sd.read(msg_back, strlen(msg));
    msg_back[strlen(msg)] = NULL;
    Serial.println((char*)msg_back);
  }
  i2sd.open("TEST.TXT", FILE_READ);
}

void loop(){
  char big_data[100];
  // i2sd.seek(0);
  i2sd.read((uint8_t*)big_data, 99);
  big_data[99] = NULL;
  Serial.println(big_data);
  delay(500);
}

