/*
  ClockTHREE Test5
  Draw a circle and an ellipse

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
  c3.circle(8, 5, 4, WHITE);
  // c3.ellipse(7.5, 5.5, 8, 6, 0, BLUE);
  c3.ellipse(9, 3, 8, 6, PI / 4, BLUE);
  c3.ellipse(5, 3, 4, 2, -PI / 4, RED);
  printData();
  c3.displayfill(BLUE);
  c3.ellipse(7.5, 5.5, 8, 6, 0, DARK);
  Serial.println("");
  printData();
}
uint32_t count = 0;
boolean dbg = true;

void loop(){
  //   c3.refresh();
  count++;
}
