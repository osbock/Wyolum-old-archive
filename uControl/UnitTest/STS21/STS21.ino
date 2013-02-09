#include <Wire.h>

const byte STS_ADDR = 0b1001010;
const byte STS_HOLD_MASTER = 0b11100011;
const byte STS_NOHOLD_MASTER = 0b11110011;
const byte STS_WRITE_USER_REG = 0b11100110;
const byte STS_READ_USER_REG = 0b11100111;
const byte STS_SOFT_RESET = 0b11111110;
const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;
const float STS_T0 = -46.85;
const float STS_GAIN = 175.72;

float EUC(short bits){
  return STS_T0 + (STS_GAIN * bits) / ((unsigned long)1l << 16);
}

float CtoF(float c){
  return c * 9 / 5 + 32.;
}

void setup(){
  Wire.begin();
  Serial.begin(115200);
  Serial.println("STS Unit Test");
  Serial.println("WyoLum 2013");

  pinMode(IO_X, OUTPUT);
  digitalWrite(IO_X, HIGH);
  Wire.beginTransmission(STS_ADDR);
  Wire.write(STS_HOLD_MASTER);
  Wire.endTransmission();
}
void loop(){
  short bits;
  byte dat;

  Wire.requestFrom(STS_ADDR, (byte)3);
  Serial.print("MEAS: ");
  if(Wire.available() > 2){
    bits = Wire.read() << 8 | Wire.read();
    Serial.print(bits, DEC);
    Serial.print(" ");
    Serial.print(EUC(bits));
    Serial.print(" deg C, ");
    Serial.print(CtoF(EUC(bits)));
    Serial.println(" deg F.");
  }
  delay(1000);
}
