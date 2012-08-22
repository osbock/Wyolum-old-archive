
/*
B = PD2 = 2
F = PD3 = 3
A = PD4 = 4
E = PD5 = 5
D = PD6 = 6
DP = PD7= 7
C = PB0 = 8
G = PB1 = 9
d1 = PB2 = 10
d2 = PB3 = 11
d3 = PB4 = 12
d4 = PB5 = 13
*/
unsigned char digits[][7] = {
  {4,2,8,5,6,3,0}, // zero
  {2,8,0,0,0,0,0}, // one
  {4,2,9,6,5,0,0}, // two
  {4,2,9,8,6,0,0}, //three
  {3,2,9,8,0,0,0}, //four
  {4,3,9,8,6,0,0}, //five
  {4,3,5,6,8,9,0}, //six
  {4,2,8,0,0,0,0}, //seven
  {2,3,4,5,6,8,9}, //eight
  {3,4,9,2,8,0,0}, //nine
};

int displayRegister =9999; // this is read and displayed constantly  
void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
  for (int i = 2; i < 14; i++){
    pinMode(i,OUTPUT);
  }
  for (int x = 10 ;x < 14; x++)
    digitalWrite(x,LOW);
}
long lastMillis =0;
#define INTERVAL 200
void loop() {
  long currentMillis = millis();
  if (currentMillis-lastMillis > INTERVAL){
     lastMillis = currentMillis;
     int reading = analogRead(A0);
     Serial.println(reading);
     displayRegister=(int)(((long)analogRead(A0)*1000L)/540L);
     
  }
   runDisplay();
 }
 
void runDisplay(){
  displayNumber(displayRegister);
  
}
void displayNumber(int i){
  if (i > 9999) return;
   blankdisplay();
   displayDigit(i %10,0);
   blankdisplay();
   displayDigit((i%100/10),1);
   blankdisplay();
   displayDigit((i%1000)/100,2);
   blankdisplay();
   displayDigit((i%10000)/1000,3);
   blankdisplay();


}
void blankdisplay(){
  for (int i =2; i < 10; i++)
    digitalWrite(i,LOW);
  for(int x = 10; x < 14; x++)
    digitalWrite(x, LOW);
}
void displayDigit(int num, int col){
  if (num > 9999) return;
  if (col > 3) return;
 
  digitalWrite(col+10,HIGH);
  if (col == 2)
    digitalWrite(7,HIGH);
  for (int i =0; (i< 8) ; i++){
    if (digits[num][i] ==0) return;
    digitalWrite(digits[num][i],HIGH);
  }
}
