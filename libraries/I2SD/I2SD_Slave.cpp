/*
  I2SD_Slave.cpp -- I2C <--> SD interface.

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
#include "I2SD_Slave.h"
#include "SD.h"

I2SD_Slave* i2sd_p;

I2SD_Slave::I2SD_Slave(){
}
void I2SD_Slave::init(){
  pinMode(I2SD_TX_LED_PIN, OUTPUT);
  pinMode(I2SD_RX_LED_PIN, OUTPUT);
  pinMode(I2SD_SLAVE_SELECT, OUTPUT);
  i2sd_p = this;
  Wire.begin(I2SD_SLAVE_ID);
  Wire.onReceive(I2SD_Slave_onReceive);
  Wire.onRequest(I2SD_Slave_onRequest);
  if(!SD.begin(I2SD_SLAVE_SELECT)){
    err_out(I2SD_INIT_ERROR, "Cannot initialize SD card");
  }
  open("DEFAULT.TXT", FILE_READ);
  // open("TEST.TXT", FILE_READ);
  next_pong = false;
}

void I2SD_Slave::open(char* filename, uint8_t mode){
  if(mode == FILE_WRITE){
    SD.remove(filename);
  }
  file_mode = mode;
  file = SD.open(filename, mode);
  if(!file){
    err_out(I2SD_OPEN_ERROR, "Cannot open file");
  }
}

void I2SD_Slave::close(){
  file.close();
}
boolean status_ok = true;

void I2SD_Slave::err_out(uint8_t err_no, char* err_msg){
  if(status_ok == false){
    // ignore, already in error state
  }
  else{
    status_ok = false;
    Serial.print("ERROR OUT.  err_no: ");
    Serial.println(err_no, DEC);
    Serial.println(err_msg);
    digitalWrite(I2SD_TX_LED_PIN, HIGH); 
    digitalWrite(I2SD_RX_LED_PIN, LOW); 
    while(true){
      delay(1000);
      for(int i=0; i < err_no; i++){
	digitalWrite(I2SD_RX_LED_PIN, HIGH); 
	delay(200);
	digitalWrite(I2SD_RX_LED_PIN, LOW); 
	delay(200);
      }
    }
  }
}
void I2SD_Slave::setTX_LED(boolean state){
  digitalWrite(I2SD_TX_LED_PIN, state);
}
void I2SD_Slave::setRX_LED(boolean state){
  digitalWrite(I2SD_RX_LED_PIN, state);
}

// Slave event handler
void I2SD_Slave_onRequest(){
  uint8_t buffer[I2C_BUFFER_LEN];

  if(i2sd_p->next_pong){
    i2sd_p->next_pong = false;
    Wire.send(i2sd_p->pong_data, I2C_BUFFER_LEN);
  }
  else if(i2sd_p->file_mode){
    i2sd_p->setTX_LED(HIGH);
    for(uint8_t i = 0; i < I2C_BUFFER_LEN && i2sd_p->file.available(); i++){
      buffer[i] = i2sd_p->file.read();
    }
    Wire.send(buffer, I2C_BUFFER_LEN);
    i2sd_p->setTX_LED(LOW);
    Serial.print((char*)buffer);
  }
}

// Slave event handler
void I2SD_Slave_onReceive(int n_byte){

  i2sd_p->setRX_LED(HIGH);

  uint8_t msg_type = Wire.receive();
  // Serial.print("MSG_TYPE: ");
  // Serial.print(msg_type, DEC);
  if(msg_type == I2SD_SEEK_MSG){
    // grab address
    Address_t Address;
    uint8_t i;
    for(i = 0; 
	i < sizeof(i2sd_p->cursor) && Wire.available(); 
	i++){
      Address.char4[i] = Wire.receive();
    }
    if(i == 4){
      i2sd_p->file.seek(Address.dat32);
      // Serial.print("SEEK: ");
      // Serial.println(Address.dat32);
    }
  }
  else if(msg_type == I2SD_PING_MSG){
    for(uint8_t i = 0; Wire.available(); i++){
      i2sd_p->pong_data[i] = Wire.receive();
    }
    // reply PING data in next request
    i2sd_p->next_pong = true;
  }
  else if(msg_type == I2SD_WRITE_MSG){
    if(i2sd_p->file_mode == FILE_WRITE){
      while(Wire.available()){
	i2sd_p->file.write(Wire.receive());
      }
    }
    else{
      i2sd_p->err_out(I2SD_MODE_ERROR, "File not in FILE_WRITE mode");
    }
  }
  else if(msg_type == I2SD_OPEN_MSG){
    uint8_t mode, i;
    mode = Wire.receive();

    char filename[I2C_BUFFER_LEN - 1]; // one extra char reserved for 
                                        // null terminator
    for(i = 0; Wire.available() && i < I2C_BUFFER_LEN - 2; i++){
      filename[i] = Wire.receive();
    }
    if(i > 0){
      filename[i] = NULL; // terminate string just in case
      Serial.print("Open:");
      Serial.print(filename);
      Serial.print(", mode:");
      Serial.println(mode, DEC);
      i2sd_p->close();
      i2sd_p->open(filename, mode);
    }
  }
  i2sd_p->setRX_LED(LOW);
}

