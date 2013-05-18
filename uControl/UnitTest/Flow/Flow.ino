#include <SoftwareSerial.h>

const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;
const byte VALVE_PIN = 5;
const byte FLOW_TX = 2;
const byte FLOW_RX = 4;
const int MSG_LEN = 100;
const int N_FLOW_RATE = 10;
// global
char msg[MSG_LEN + 1];
int cursor = 0;
int last_end = 0;
bool new_data = false;

short flow_rates[N_FLOW_RATE];

//                          328_RX, 328_TX
SoftwareSerial flow_serial(FLOW_TX, FLOW_RX, true);

void run_command(char *cmd){
  while(flow_serial.available()){
    Serial.print(flow_serial.read());
  }
  Serial.println(cmd);

  flow_serial.write(cmd);
  int tries = 0;
  while(flow_serial.read() != 'O' && tries < 100){
    delay(100);
    flow_serial.write(cmd);
    tries++;
    Serial.println(tries);
  }
  Serial.print("tries:");
  Serial.print(tries);
}
void setup(){
  pinMode(IO_X, OUTPUT);
  pinMode(DBG, OUTPUT);

  Serial.begin(115200);
  flow_serial.begin(19200);
  flow_serial.listen();
  Serial.println("Flow Meter Unit Test");
  Serial.println("WyoLum 2013");
  // initial setup
  // turn off flow sensor
  pinMode(VALVE_PIN, OUTPUT);
  pinMode(IO_X, OUTPUT);
  digitalWrite(IO_X, HIGH);
  if(true){
    run_command("s\n");
    run_command("mod=f\n");
    run_command("res=7\n");
  }
  digitalWrite(VALVE_PIN, LOW);
  Serial.println("Staring");
  
  // delay(2000);
  // pinMode(VALVE_PIN, LOW);
  pinMode(DBG, OUTPUT);
  digitalWrite(DBG, HIGH);


}
short convert(){
  short out;
  int flow_count = 0;

  if(last_end > cursor){//  move data to start of buffer.
    for(int i = 0; i < cursor; i++){ // copy start of dat over to make room for tail
      msg[MSG_LEN - last_end + i] = msg[i];
    }
    for(int i = 0; i < MSG_LEN - last_end; i++){ // copy tail over to start
      msg[i] = msg[last_end + i];
    }
    cursor += MSG_LEN - last_end;
    last_end = 0;
  }
  // if(last_end + 4 < cursor){
  //  for(int i = last_end; i < cursor; i++){
  //     Serial.print(msg[i]);
  //   }
  // }

  for(int i=last_end; i < cursor - 3; i++){
    if(msg[i] == 0x7F && msg[i + 1] == 0x7F){
      out = (short)msg[i + 2] << 8 | (short)msg[i + 3];
      flow_rates[flow_count++] = out;
    }
    last_end++;
  }
  return flow_count;
}

int read_flow(){
  int out, i;
  char c, two[2];
  new_data = false;

  if(flow_serial.overflow()){
    Serial.println("FLOW SERIAL OVERFLOW");
  }
  if(flow_serial.available() > 1){
    Serial.print("flow_serial.available(): ");
    Serial.println(flow_serial.available());
  }
  out = 0;

  while(flow_serial.available()){
    new_data = true;
    msg[cursor++] = flow_serial.read();
    cursor %= MSG_LEN;
  }
  return cursor;
}

void loop(){
  int i, n_flow;
  short flow;
  
  read_flow();
  if(new_data){
    Serial.println(cursor - last_end);
    for(i=0; i < 30; i++){
      Serial.print(msg[(last_end + i) % MSG_LEN]);
    }
    Serial.println();
  }
  n_flow = convert();
  for(i = 0; i < n_flow; i++){
    Serial.print("Flow[");
    Serial.print(i);
    Serial.print("] = ");
    Serial.print(flow_rates[i]);
    Serial.println("");
  }

  
  if(Serial.available()){
    Serial.print("Echo");
    while(Serial.available()){
      char c = Serial.read();
      Serial.print(c);
      flow_serial.write(c);
    }
  }
}
