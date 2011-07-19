/*
  Read and write some data to the I2SD
 */

#include "C3SB.h"
#include "I2SD.h"
#include "SD.h"
#include "Wire.h"

const boolean WRITE_TEST = true;
const int DBG = 13;

I2SD i2sd;

void setup(){
  Serial.begin(57600);
  Wire.begin(); // DON'T FORGET THIS!!!!
  
  Serial.println("Clear error...");
  i2sd.clear_error(); // just in case
  Serial.println("Error cleared.");

  // wait for I2SD hardware to start up
  Serial.println("PING...");
  while(!i2sd.ping((uint8_t*)"PING", 4)){
    delay(100);
  }
  Serial.println("PONG received");

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
  const int n_byte = 32 * 7 + 1;
  char big_data[n_byte];
  unsigned long now = millis();
  // i2sd.seek(51);
  uint8_t n_byte_back = i2sd.read((uint8_t*)big_data, n_byte);
  // Serial.print("n_byte_back: ");
  // Serial.println(n_byte_back, DEC);
  /*
    for(int i =0; i < 5; i++){
    Serial.print(big_data[i]);
    Serial.print(" ");
    Serial.println(big_data[i], DEC); all are 255 ==> end of file!
  }
  */
  // big_data[n_byte] = NULL;
  Serial.print(big_data);
  // delay(1);
  // speed test: 248000 bytes per second!
  // Serial.println((float)n_byte / (millis() - now)); 
  if(false){
    digitalWrite(DBG, HIGH);
    delay(1);
    digitalWrite(DBG, LOW);
    delay(1);
  }
  // delay(100);
}

