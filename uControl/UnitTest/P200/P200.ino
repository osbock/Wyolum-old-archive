const byte IO_X = 7;
const byte IO_R = 8;
const byte DBG = 13;

void setup(){
  pinMode(IO_X, OUTPUT);
  pinMode(IO_R, OUTPUT);
  pinMode(DBG, OUTPUT);
  Serial.begin(115200);
  Serial.println("P200 Test");
  Serial.println("WyoLum 2013");
  Serial.println("Check voltage on IO_X and IO_R is 3.3v");
}
void loop(){
  delay(4000);
  digitalWrite(IO_R, LOW);
  digitalWrite(IO_X, HIGH);
  digitalWrite(DBG, HIGH);
  delay(4000);
  digitalWrite(IO_X, LOW);
  digitalWrite(DBG, LOW);
}
