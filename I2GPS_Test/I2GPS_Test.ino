#include <inttypes.h>
#include "I2GPS.h"
#include "Wire.h"

int32_t lat;
uint8_t gps_data[32];
union converter_t {
  long long_dat; 
  unsigned long ulong_dat; 
  uint8_t byte_dat[4];
};
converter_t converter;

void setup(){
  Serial.begin(115200);
  Wire.begin();
}
void loop(){
  uint8_t i;

  gps_raw_read(I2GPS_LAT_ADDR, 4, (uint8_t*)&lat);


  gps_raw_read(0, 32, gps_data);
  // print_gps_data();
  // delay(1000); return
  gps_raw_write1(I2GPS_LOGRATE_ADDR, 1);
  char *filename = "TEST.TXT";
  gps_raw_write(I2GPS_FILENAME_ADDR, 9,	(uint8_t*)filename);

  char out_filename[32];
  gps_raw_read(I2GPS_FILENAME_ADDR, 12, (uint8_t*)out_filename);
  Serial.print("FILE NAME: ");
  for(i = 0; i< 12 && out_filename[i]; i++){
    Serial.print(out_filename[i]);
  }
  Serial.println(" ");

  gps_raw_write1(I2GPS_FILESTAT_ADDR, I2GPS_OPEN_WRITE);

  // WRITE A FILE
  char* dat = "some text\n";
  for(i=0; i < 200; i++){
    gps_raw_write(I2GPS_FILE_DATA_ADDR, strlen(dat), (uint8_t*)dat);
  }
  dat = "last text\n";
  gps_raw_write(I2GPS_FILE_DATA_ADDR, strlen(dat), (uint8_t*)dat);

  gps_raw_write1(I2GPS_FILESTAT_ADDR, I2GPS_FILE_CLOSE);
  
  // READ A FILE
  gps_raw_write(I2GPS_FILENAME_ADDR, 8, (uint8_t*)filename);
  gps_raw_write1(I2GPS_FILESTAT_ADDR, I2GPS_OPEN_READ);

  char file_data[32];
  converter.ulong_dat = 0;
  gps_raw_write(I2GPS_SEEK_ADDR, 4, converter.byte_dat);
  gps_raw_read(I2GPS_FILE_DATA_ADDR, 32, (uint8_t*)file_data);
  Serial.print("FILE DATA: ");
  for(int ii=0; ii<32; ii++){
    Serial.print(file_data[ii]);
  }
  Serial.println("");

  converter.ulong_dat = 8;
  gps_raw_write(I2GPS_SEEK_ADDR, 4, converter.byte_dat);
  gps_raw_read(I2GPS_FILE_DATA_ADDR, 32, (uint8_t*)file_data);
  Serial.print("SEEK DATA 8: ");
  for(int ii=0; ii<32; ii++){
    Serial.print(file_data[ii]);
  }
  Serial.println("");
  gps_raw_write(I2GPS_FILESTAT_ADDR, 1, I2GPS_FILE_CLOSE);

  // FLASH AN LED (Digital Pins)
  gps_raw_write1(I2GPS_DIGITAL_DIR_ADDR, 255); // ALL OUTPUT
  gps_raw_write1(I2GPS_DIGITAL_RW_ADDR, 255); // ALL ON
  delay(100);
  gps_raw_write1(I2GPS_DIGITAL_RW_ADDR, 0); // ALL off
  delay(1000);

  // Analog pins
}

void print_gps_data(){
  uint8_t ymdhms[6];

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
}

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
