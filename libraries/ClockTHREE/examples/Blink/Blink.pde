const int DBG = 16;

void setup(){
  Serial.begin(57600); // for debugging
  Serial.println("Begin Blink test");
  pinMode(DBG, OUTPUT);
}

void loop(){
  digitalWrite(DBG, HIGH);
  delay(500);
  digitalWrite(DBG, LOW);
  delay(500);
}
