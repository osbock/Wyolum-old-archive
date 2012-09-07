/*
  ClockTHREE Test01_LEDTest
  Light LEDs sequentially

  Justin Shaw March 11, 2012
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0 Unported
 */

#include "SD.h"
#include "Wire.h"

const unsigned long BAUDRATE = 115200;
const int chipSelect = 10;
const int D1_PIN = 4;
const int D2_PIN = 7;
void setup(){
  Serial.begin(BAUDRATE);
  Serial.println("I2GPS stand alone test.");
  Serial.println("WyoLum, LLC, 2012");

  // enable and flash LEDS
  pinMode(D1_PIN, OUTPUT); 
  pinMode(D2_PIN, OUTPUT);
  digitalWrite(D1_PIN, HIGH);
  digitalWrite(D2_PIN, HIGH);
  delay(100);
  digitalWrite(D1_PIN, LOW);
  digitalWrite(D2_PIN, LOW);
  
  if(!testSD()){
    // fail SD
  }
  else{
    Serial.println("SD PASS");
    digitalWrite(D2_PIN, HIGH);
  }
  Wire.begin();
  if(!testRTC()){
    // fail rtc
  }
  else{
    Serial.println("RTC PASS");
    digitalWrite(D1_PIN, HIGH);
  }
  while(1){
    delay(1000);
  }
}

void loop(){
}

/********************************************************************************
 * RTC code
 ********************************************************************************/
#define IS_BCD true
#define IS_DEC false
#define IS_BYTES false
const int DS3231_ADDR = 104;

// decimal to binary coded decimal
uint8_t dec2bcd(int dec){
  uint8_t t = dec / 10;
  uint8_t o = dec - t * 10;
  return (t << 4) + o;
}

// binary coded decimal to decimal
int bcd2dec(uint8_t bcd){
  return (((bcd & 0b11110000)>>4)*10 + (bcd & 0b00001111));
}


bool rtc_raw_read(uint8_t addr,
		  uint8_t n_bytes,
		  bool is_bcd,
		  uint8_t *dest){

  bool out = false;
  Wire.beginTransmission(DS3231_ADDR); 
  // Wire.send(addr); 
  Wire.write(addr);
  Wire.endTransmission();
  Wire.requestFrom(DS3231_ADDR, (int)n_bytes); // request n_bytes bytes 
  if(Wire.available()){
    for(uint8_t i = 0; i < n_bytes; i++){
      dest[i] = Wire.read();
      if(is_bcd){ // needs to be converted to dec
	dest[i] = bcd2dec(dest[i]);
      }
    }
    out = true;
  }
  return out;
}

bool testRTC(){
  bool status = true;
  uint8_t date[7];
  if(rtc_raw_read(0, 7, true, date)){
    Serial.print("DATE: ");
    // date[2], date[1], date[0], date[4], date[5], date[6]
    //      hr,     min,     sec,     day,   month,  yr;
      Serial.print(date[2], DEC);
      Serial.print(":");
      Serial.print(date[1], DEC);
      Serial.print(":");
      Serial.print(date[0], DEC);
      Serial.print("  ");

      Serial.print(date[4], DEC);
      Serial.print("/");
      Serial.print(date[5], DEC);
      Serial.print("/");
      Serial.print(date[6], DEC);
      Serial.print(".");

    Serial.println("");
  }
  else{
    Serial.print("RTC FAIL");
    status = false;
  }
  return status;
}
/********************************************************************************
 * END RTC code
 ********************************************************************************/

boolean testSD(){
  boolean status = true;
  File myFile;
  Serial.print("Initializing SD card...");
  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
   pinMode(10, OUTPUT);
  if (!SD.begin(chipSelect)) {
    Serial.println("initialization failed!");
    status = false;
    return status;
  }
  Serial.println("initialization done.");
  SD.remove("test.txt");
  myFile = SD.open("test.txt", FILE_WRITE);

  // if the file opened okay, write to it:
  if (myFile) {
    delay(300);
    Serial.println("Writing to test.txt...");
    myFile.print("testing 1,2,3: ");
    myFile.close();
  } 
  else {
    // if the file didn't open, print an error:
    status = false;
  }

  // re-open the file for reading:
  myFile = SD.open("test.txt");
  if (myFile) {
    Serial.println("test.txt:");
    
    // read from the file until there's nothing else in it:
    while (myFile.available()) {
      Serial.write(myFile.read());
    }
    // close the file:
    myFile.close();
  } else {
    status = false;
  }
  return status;
}
