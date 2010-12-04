/*
  ClockTHREE Test4 Diag Test.
  Draw a some lines

  Justin Shaw Nov 28, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0 Unported
 */

#include "ClockTHREE.h"
#include "SPI.h"

ClockTHREE c3 = ClockTHREE();
uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));

void bin32Print(uint32_t num){
  for(int i=31; i >= 0; i--){
    if(num >= (1LU << i)){
      Serial.print('1');
      num -= (1LU << i);
    }
    else{
      Serial.print("0");
    }
  }
  Serial.println("");
}
void printData(){
  Serial.println("");
  for(int i=0; i < N_COL; i++){
    bin32Print(display[i]);
  }
}
void setup(){
  int xpos, ypos;

  c3.init();
  Serial.begin(9600);
  delay(100);
  c3.setdisplay(display);
  c3.displayfill(DARK);
  // c3.setPixel(0, 0, WHITE);
  // c3.setPixel(0, 0, WHITE);
  // c3.setPixel(0, 4, WHITE);
  //for(int i = 0; i <= 12; i++){
  //    c3.setPixel(i, 12-i, BLUE);
  //}
  //for(int i = 0; i < 12; i++){
  //  c3.setPixel(i+6, i, WHITE);
  //}
  
  // c3.setPixel(0, 0, WHITE);

  
  // c3.setPixel(1, 0, WHITE);
  // c3.setPixel(1, 1, BLUE);
  c3.line(0, 0, 15, 1, WHITE);
  c3.line(0, 11, 15, 0, BLUE);
  c3.line(5, 0, 9, 12, RED);
  c3.moveto(5, 5);
  c3.lineto(10, 10, WHITE);
  c3.lineto(10, 3, WHITE);
  c3.lineto(3, 3, WHITE);
  printData();
  //c3.line(0, 4, 1, 3, RED);

}
uint32_t count = 0;
boolean dbg = true;

void loop(){
  c3.refresh();
  count++;
}
