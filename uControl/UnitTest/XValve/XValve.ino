const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;
const byte VALVE_PIN = 5;

void setup(){
  Serial.begin(115200);
  Serial.println("X-Valve Unit Test");
  Serial.println("WyoLum 2013");

  pinMode(IO_X, OUTPUT);
  pinMode(DBG, OUTPUT);
  digitalWrite(IO_X, HIGH);
}

void loop(){
  digitalWrite(VALVE_PIN, HIGH);
  digitalWrite(DBG, HIGH);
  Serial.println("HIGH");
  delay(1000);
  digitalWrite(VALVE_PIN, LOW);
  digitalWrite(DBG, LOW);
  Serial.println("LOW");
  delay(1000);
}
