/*
  ClockTHREE Test3 Diag Test.
  Assign different colors to each diagonal, rotate

  Justin Shaw Nov 28, 2010
  
  Licenced under Creative Commons Attribution.
  Attribution 3.0 Unported
 */

#include "ClockTHREE.h"
#include "SPI.h"

ClockTHREE c3 = ClockTHREE();
uint32_t *display = (uint32_t*)calloc(N_COL, sizeof(uint32_t));
void setup(){
  int xpos, ypos;

  c3.init();
  c3.setdisplay(display);
  for(xpos=0; xpos<N_COL; xpos++){
    for(ypos=0; ypos<N_RGB_ROW; ypos++){
      c3.setPixel(xpos, ypos, COLORS[(ypos + xpos) % N_COLOR]);
    }
  }
}
uint32_t count = 0;
boolean dbg = true;

void loop(){
  uint8_t color_i, col_j;
  uint32_t tmp_col;
  c3.refresh();
  tmp_col = c3.display[0];
  if(count % 4000 == 0){
    for(col_j=1; col_j < 16; col_j++){
      c3.display[col_j - 1] = c3.display[col_j];
    }
  }
  c3.display[15] = tmp_col;
  count++;
}
