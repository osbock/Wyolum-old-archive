#include <SoftwareSerial.h>

const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;
const byte VALVE_PIN = 5;
const byte FLOW_TX = 2;
const byte FLOW_RX = 4;
const int MSG_LEN = 200;

//                          328_RX, 328_TX
SoftwareSerial flow_serial(FLOW_TX, FLOW_RX, true);

void setup(){
  Serial.begin(115200);
  flow_serial.begin(19200);
  Serial.println("Flow Meter Unit Test");
  Serial.println("WyoLum 2013");
  // initial setup
  // turn off flow sensor
  while(flow_serial.available()){
    flow_serial.read();
  }
  flow_serial.write("s\n");
  flow_serial.write("s\n");
  flow_serial.write("s\n");
  while(flow_serial.available() < 2){
  }
  pinMode(DBG, OUTPUT);
  digitalWrite(DBG, HIGH);
  flow_serial.write("mod=F");
  delay(100);
  flow_serial.write("res=0");
  delay(100);
  flow_serial.write("s\n");
  delay(100);

  pinMode(IO_X, OUTPUT);
  pinMode(DBG, OUTPUT);
  digitalWrite(IO_X, HIGH);

}
short convert(char *msg){
  unsigned short out;
  for(int i=0; i < MSG_LEN - 3 && msg[i] != 0; i++){
    if(msg[i] == 0x7F && msg[i + 1] == 0x7F){
      out = (short)msg[i + 2] << 8 | (short)msg[i + 3];
      return out;
    }
  }
  return 0;
}
void loop(){
  int i = 0;
  char msg[MSG_LEN + 1];
  short flow;

  if(Serial.available()){
    while(Serial.available()){
      flow_serial.write(Serial.read());
      delay(1);
    }
    flow_serial.write("\n");
    delay(100);
  }

  for(i=0; flow_serial.available() && i < MSG_LEN; i++){
    msg[i] = flow_serial.read();
    delay(1);
  }
  if(i > 0){
    msg[i] = 0;
    for(i = 0; msg[i] != 0 && i < MSG_LEN; i++){
      // Serial.print(" 0x");
      // Serial.print((char)msg[i], HEX);
    }
    //Serial.println();
    Serial.write(msg);
    //flow = convert(msg);
    //if(flow > 0){
    //  Serial.print("Flow: ");
    //  Serial.println(flow);
    //}
  }
  delay(1);
}
