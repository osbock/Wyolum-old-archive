#include <Wire.h>
const unsigned short ABS_MIN_COUNT = 2949;  // 2731;
const unsigned short ABS_MAX_COUNT = 24794; // 21845;
const unsigned short ABS_COUNT_RANGE = ABS_MAX_COUNT; // - ABS_MIN_COUNT;
const unsigned short ABS_MAX_PRESSURE_MB = 2000;
const float ABS_SENSITIVITY = float(ABS_COUNT_RANGE) / ABS_MAX_PRESSURE_MB;

const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;
const byte ABS_ADDR = 0b1111000;

float EUC(unsigned short bits){
  return (bits - ABS_MIN_COUNT) / ABS_SENSITIVITY;
}

void setup(){
  Wire.begin();

  Serial.begin(115200);
  Serial.println("Abs Pressure Unit Test");
  Serial.println("WyoLum 2013");

  pinMode(IO_X, OUTPUT);
  pinMode(DBG, OUTPUT);
  digitalWrite(IO_X, HIGH);
}

void loop(){
  unsigned short bits;

  Wire.requestFrom(ABS_ADDR, (byte)2);
  if(Wire.available() == 2){
    bits = Wire.read() << 8 | Wire.read();
    Serial.print(bits, DEC);
    Serial.print(" ");
    Serial.print(EUC(bits));
    Serial.println(" UNCALIBRATED");
  }
  delay(1000);

}
