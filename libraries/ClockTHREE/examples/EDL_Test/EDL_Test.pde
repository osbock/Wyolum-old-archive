/*
  WARNING!!!! will delete everything in EEPROM!!!
  WARNING!!!! will delete everything in EEPROM!!!
  WARNING!!!! will delete everything in EEPROM!!!
  WARNING!!!! will delete everything in EEPROM!!!

  ClockTHREE EDL Test

  Justin Shaw Jan 11, 2011
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0
 */

#include <SPI.h>
#include <Wire.h>
#include "Time.h"
#include "MsTimer2.h"
#include "EDL.h"
#include "EEPROM.h"

const uint16_t BAUDRATE = 57600;
// const uint16_t MAX_EEPROM_ADDR = 1023;

// msg should be at least 100 chars long;
void get_test_record(uint8_t did, char *payload, char *msg){
  msg[0] = did;
  msg[1] = strlen(payload) + 2;
  strcpy(msg + 2, payload);
  msg[msg[1] - 2] = did;
 }

void setup(){
  uint8_t b;

  Serial.begin(BAUDRATE);

  Serial.println("EDL test begin");
  // clear EEPROM
  for(uint16_t i = 0; i <= MAX_EEPROM_ADDR; i++){
    EEPROM.write(i, 0);
  }
  
  char did;
  char msg[100];
  char *payload = "THIS IS TEST X";
  
  char retrieved[100];
  uint8_t out_len;
  uint8_t n_record;

  for(n_record = 4; n_record >= 1; n_record--){
    // write some records
    Serial.print(n_record, DEC);
    Serial.println(" records:");
    for(did = 1; did < n_record + 1; did++){
      get_test_record(did, payload, msg);
      if(!did_write(msg)){
	Serial.println("Trouble writing message with did ");
	Serial.print(did, DEC);
      }
    }
    // read them back
    for(did = 1; did < n_record + 1; did++){
      get_test_record(did, payload, msg);
      did_read(did, retrieved, &out_len);
      if(out_len != msg[1]){
	Serial.print("   not the same length: ");
	Serial.print(msg[1], DEC);
	Serial.print(" != ");
	Serial.println(out_len, DEC);
      }
      else{
	for(uint8_t i = 0; i < msg[1]; i++){
	  if(retrieved[i] != msg[i]){
	    Serial.print("    ERROR, retrieved != msg in byte ");
	    Serial.print(i, DEC);
	    Serial.print(", ");
	    Serial.print(retrieved[i], DEC);
	    Serial.print(" != ");
	    Serial.println(msg[i], DEC);
	  }
	}
      }
    }
    for(did = 1; did < n_record + 1; did++){
      // Delete them
      if(!did_delete(did)){
	Serial.print("Trouble deleting did ");
	Serial.println(did, BYTE);
      }
    }
  
    // check EEPROM IS ALL ZEROS
    for(uint16_t i = 0; i <= MAX_EEPROM_ADDR; i++){
      b = EEPROM.read(i);
      
      if(b != 0){
	Serial.print("    DID not deleted, b=");
	Serial.print(b, DEC);
	Serial.print(", @ addr i=");
	Serial.println(i, DEC);
      }
    }
  }

  // check delete does not effect other records
  Serial.println("Independence test");
  get_test_record(1, payload, msg);
  if(!did_write(msg)){
    Serial.println("Trouble writing message 1 with did ");
    Serial.print(did, DEC);
  }
  get_test_record(2, payload, msg);
  if(!did_write(msg)){
    Serial.println("Trouble writing message 2 with did ");
    Serial.print(did, DEC);
  }
  
  if(!did_delete(2)){
    Serial.print("Trouble deleting did 2");
  }

  get_test_record(1, payload, msg);

  // see if msg 1 is ok
  did_read(1, retrieved, &out_len);
  for(uint8_t i = 0; i < msg[1]; i++){
    if(retrieved[i] != msg[i]){
      Serial.print("    ERROR, retrieved != msg in byte ");
      Serial.print(i, DEC);
      Serial.print(", ");
      Serial.print(retrieved[i], DEC);
      Serial.print(" != ");
      Serial.println(msg[i], DEC);
    }
  }

  // clear EEPROM
  for(uint16_t i = 0; i <= MAX_EEPROM_ADDR; i++){
    EEPROM.write(i, 0);
  }
  Serial.println("EDL test end");
  Serial.println("");
}
void loop(){
}
