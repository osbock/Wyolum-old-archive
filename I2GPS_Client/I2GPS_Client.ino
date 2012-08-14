#include "Wire.h"

// globals
const uint8_t I2GPS_I2C_ADDR = 88; // TODO: get from header
const uint8_t N_DATA_BYTE = 0x20;
uint8_t address = 0;
uint8_t gps_data[N_DATA_BYTE];
unsigned long count = 0;

void setup(){
  Wire.begin();
  Serial.begin(115200);
}

void loop(){
  uint8_t ymdhms[6];

  gps_raw_read((uint8_t)0, (uint8_t)32, gps_data);
#ifdef NOTDEF
  for(int i=0; i<32; i++){
    Serial.print(gps_data[i], HEX);
    Serial.print(" ");
  }
  Serial.println("");
  Serial.println("Breakout");
#endif
  Serial.print("UNIX TIME:");
  Serial.println(unserialize_ulong(gps_data+0));
  Serial.print("LAT:");
  Serial.print(unserialize_long(gps_data+4));
  Serial.println(" 1/1000th DEG");
  Serial.print("LON:");
  Serial.print(unserialize_long(gps_data+8));
  Serial.println(" 1/1000th DEG");
  Serial.print("ALT:");
  Serial.print(unserialize_long(gps_data+12));
  Serial.println(" CM");
  
  gps_raw_read(0x1C, 6, ymdhms);

  Serial.print("CALENDAR TIME:");
  Serial.print(ymdhms[1], DEC);
  Serial.print("/");
  Serial.print(ymdhms[2], DEC);
  Serial.print("/");
  Serial.print(ymdhms[0], DEC);

  Serial.print(" ");
  Serial.print(ymdhms[3], DEC);
  Serial.print(":");
  Serial.print(ymdhms[4], DEC);
  Serial.print(":");
  Serial.print(ymdhms[5], DEC);
  Serial.println("");
  Serial.println("");

  count++;
  delay(1000);

}


bool gps_raw_read(uint8_t addr,
		  uint8_t n_byte,
		  uint8_t *dest){
  
  bool out = false;
  Wire.beginTransmission(I2GPS_I2C_ADDR); 
  Wire.write(addr); 
  Wire.endTransmission();
  Wire.requestFrom((int)I2GPS_I2C_ADDR, (int)n_byte); // request n_byte bytes 
  if(Wire.available()){
    for(uint8_t i = 0; i < n_byte; i++){
      dest[i] = Wire.read();
    }
    out = true;
  }
  return out;
}

union converter_t {
  long long_dat; 
  unsigned long ulong_dat; 
  uint8_t byte_dat[4];
};
converter_t converter;
// extern convert_t converter;

long unserialize_long(uint8_t* source){
  for(int i=0; i<4; i++){
    converter.byte_dat[i] = source[i];
  }
  return converter.long_dat;
}
unsigned long unserialize_ulong(uint8_t* source){
  for(int i=0; i<4; i++){
    converter.byte_dat[i] = source[i];
  }
  return converter.ulong_dat;
}
