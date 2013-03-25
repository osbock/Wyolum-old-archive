#include <SPI.h>
#include <Wire.h>
const unsigned short GAGE_MIN_COUNT = 0xA3D; 
const unsigned short GAGE_MAX_COUNT = 0X5FFF;
const unsigned short GAGE_COUNT_RANGE = GAGE_MAX_COUNT - GAGE_MIN_COUNT;
const unsigned short GAGE_MAX_PRESSURE_MB = 500;
const float GAGE_SENSITIVITY = ((float)GAGE_COUNT_RANGE) / GAGE_MAX_PRESSURE_MB;

const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;
byte clr;

float EUC(unsigned short bits){
  return (bits - GAGE_MIN_COUNT) / GAGE_SENSITIVITY;
}

void setup(){
  Wire.begin();

  Serial.begin(115200);
  Serial.println("Gage Pressure Unit Test");
  Serial.println("WyoLum 2013");
  pinMode(13, OUTPUT);
  pinMode(IO_X, OUTPUT);
  pinMode(DBG, OUTPUT);
  digitalWrite(IO_X, HIGH);
  // pinMode(SS, OUTPUT);
  // pinMode(10, OUTPUT);
  // pinMode(11, OUTPUT);
  // pinMode(12, OUTPUT);
  // digitalWrite(10, HIGH);
  // digitalWrite(11, HIGH);
  // digitalWrite(12, HIGH);
  // digitalWrite(13, HIGH);
  Serial.print("check 3.3V p_MISO, p_MOSI, p_SS voltages,\n<any char> to continue");
  while(false && !Serial.available()){
    delay(100);
  }
  Serial.println("");
  //interrupt disabled,spi enabled,msb 1st,master,clk low when idle,
  //sample on leading edge of clk,system clock/4 rate (fastest)

  SPI.begin();
  SPI.setDataMode(SPI_MODE0);
  SPI.setClockDivider(SPI_CLOCK_DIV32); //  or 2,4,8,16,32,64,128

}

void loop(){

  unsigned short bits;
  // Serial.print("digital value: ");
  unsigned short count = my_spi_transfer();
  Serial.print(count, DEC);
  Serial.println(); return;// TODO: DELETE ME
  Serial.print(" = ");
  Serial.print(EUC(count));
  int sensorValue = analogRead(A3);
  // print out the value you read:
  Serial.print("mmHG, analog value: ");
  Serial.println(sensorValue);
  delay(100);
}

char spi_transfer(){
  SPDR = 0x255;                    // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  }
  return SPDR;                    // return the received byte
}

unsigned long my_spi_transfer(){
  byte dont_care;
  byte byte_msb, byte_lsb;
  short pressure;
  // If your controller does not control the /SS pin, you'll need to configure it yourself
  // Set output value to 1/high state (SPI in idle state)
  digitalWrite(SS, LOW);
  // PORTB &= (0b00000100);//  digitalWrite(SS, LOW);
  /* 
  dont_care = spi_transfer();
  byte_msb = spi_transfer();
  byte_lsb = spi_transfer();
  */

  dont_care = SPI.transfer(255);
  byte_msb = SPI.transfer(255);
  byte_lsb = SPI.transfer(255);
  // PORTB |= (0b00000100);//  digitalWrite(SS, HIGH);
  digitalWrite(SS, HIGH);
  pressure = ((short)byte_msb << 8) | byte_lsb;
  return pressure;
}
