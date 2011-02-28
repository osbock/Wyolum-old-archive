const int DBG = 16;

void setup(){
  pinMode(DBG, OUTPUT);
}

void loop(){
  digitalWrite(DBG, HIGH);
  delay(500);
  digitalWrite(DBG, LOW);
  delay(500);
}
