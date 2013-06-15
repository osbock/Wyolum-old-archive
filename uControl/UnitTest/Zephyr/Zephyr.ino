const int ZEPHYR_ADDR = 0x78; //0x49;
const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;


#include <Wire.h>
// #include <I2C.h>

int x = 0;
int y = 0;
int z = 0;


void setup()
{
  Serial.begin(115200);
  pinMode(13, OUTPUT);
  pinMode(IO_X, OUTPUT);
  pinMode(DBG, OUTPUT);
  digitalWrite(IO_X, HIGH);
  Wire.begin();
  probe_I2C();
  // while(1) delay(100);
  // I2c.begin();
}
/*
void loop()
{
  Serial.print("x:");
  //I2c.read(ZEPHYR_ADDR,0x0, 2); //read 2 bytes from the device
  // x = I2c.receive() << 8;
  // x |= I2c.receive();
  Serial.println(x, BIN);
}
*/

/*
void setup(){
  Wire.begin();
  Serial.begin(115200);
  pinMode(13, OUTPUT);
  pinMode(IO_X, OUTPUT);
  pinMode(DBG, OUTPUT);
  digitalWrite(IO_X, HIGH);

  Serial.println("Zephyr Test");
  Serial.println("WyoLum 2013");
  // probe_I2C();  
  //Wire.beginTransmission(ZEPHYR_ADDR); 
  //Wire.write(0);
  //Wire.endTransmission();
  //delay(10);
  if(false){
    Wire.requestFrom(ZEPHYR_ADDR, 2); // request n_bytes bytes 
    Serial.println(Wire.available());
    while(Wire.available()){
      Wire.read();
    }
    Wire.requestFrom(ZEPHYR_ADDR, 2); // request n_bytes bytes 
    Serial.println(Wire.available());
    while(Wire.available()){
      Wire.read();
    }
  }
}
*/

uint8_t loop_count;
const int FULL_SCALE_FLOW = 750;
const int n = 2;
void loop(){
  if(loop_count > 100){
    // Serial.println("Quit");
    // while(1) delay(100);
  }
  uint8_t dest[n];
  uint16_t flow_count;
  float flow = 0;

  // Wire.beginTransmission(ZEPHYR_ADDR); 
  // Wire.write(13);// no lock up
  // Wire.endTransmission();
  // Serial.print(loop_count, DEC);
  // Serial.print(" -- ");
  // digitalWrite(IO_X, loop_count++ % 50 > 24);
  Wire.requestFrom(ZEPHYR_ADDR, n); // request n_bytes bytes 
  if(Wire.available()){
    if(loop_count % 256 < 10){
      Serial.print("  ");
    }
    else if(loop_count % 256 < 100){
      Serial.print(" ");
    }
    Serial.print(loop_count++, DEC);

    Serial.print("-- ");
    for(uint8_t i = 0; i < n; i++){
      dest[i] = Wire.read();
    }
    for(uint8_t i = 0; i < n; i++){
      Serial.print(" ");
      Serial.print(dest[i], BIN);
    }
    flow_count = (uint16_t)dest[0] * 256L + (uint16_t)dest[1];
    Serial.print(" fc:");
    Serial.print(flow_count);
    // flow = FULL_SCALE_FLOW * ((flow_count / 16384.) - 0.5)/0.4;
    flow = FULL_SCALE_FLOW * ((flow_count / 16384.) - 0.5) / 0.4;
    Serial.print(" flow:");
    Serial.print(flow);
    Serial.println();
  }

  //delay(10);
}

/*******************************************************************************
 * RTC code
 ******************************************************************************/

/*
bool flow_raw_read(uint8_t addr,
		   uint8_t n_bytes,
		   uint8_t *dest){

  bool out = false;
  Wire.beginTransmission(ZEPHYR_ADDR); 
  Wire.write(addr);
  Wire.endTransmission();
  Wire.requestFrom(ZEPHYR_ADDR, (int)n_bytes); // request n_bytes bytes 
  if(Wire.available()){
    for(uint8_t i = 0; i < n_bytes; i++){
      dest[i] = Wire.read();
    }
    out = true;
  }
  return out;
}
*/

/*
bool testFlow(){
  bool status = true;
  uint8_t flow[2];
  delay(10);
  if(flow_raw_read(0, 2, flow)){
    Serial.print("FLOW: ");
    Serial.print(flow[0], DEC);
    Serial.print(":");
    Serial.print(flow[1], DEC);
    Serial.println("");
  }
  else{
    Serial.println("FLOW FAIL");
    status = false;
  }
  return status;
}
*/

/******************************************************************************
 * END FLOW code
 *****************************************************************************/

void probe_I2C(){
  Serial.println("I2C Probe");
  int count = 0;
  for (byte i = 1; i < 120; i++){
    Wire.beginTransmission (i);
    if (Wire.endTransmission () == 0){
      Serial.print ("Found address: ");
      Serial.print (i, DEC);
      Serial.print (" (0x");
      Serial.print (i, HEX);
      Serial.println (")");
      count++;
      delay (1);  // maybe unneeded?
    } // end of good response
  } // end of for loop
  Serial.println ("Done.");
  Serial.print ("Found ");
  Serial.print (count, DEC);
  Serial.println (" device(s).");
}  // end of setup

