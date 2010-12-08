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

void setup(){
  int xpos, ypos;

  c3.init();
  delay(100);
  c3.setdisplay(display);
}
uint32_t count = 0;
boolean dbg = true;
double x0 = 0, y0 = 0, x1 = 8, y1 = 10;
double vx0 = .4, vy0 = .15, vx1 = -.4, vy1 = -.3;
uint8_t color_i = 1;
const int hold = 100;

void loop(){
  if(count % hold == 0){
    c3.line(x0, y0, x1, y1, DARK);
    x0 += vx0;
    if(x0 > N_COL){
      color_i++;
      color_i %= N_COLOR;
      x0 = N_COL;
      vx0 *= -1;
    }
    if(x0 < 0){
      color_i++;
      color_i %= N_COLOR;
      x0 = 0;
      vx0 *= -1;
    }

    if(x1 > N_COL){
      color_i++;
      color_i %= N_COLOR;
      x1 = N_COL;
      vx1 *= -1;
    }
    if(x1 < 0){
      color_i++;
      color_i %= N_COLOR;
      x1 = 0;
      vx1 *= -1;
    }
    if(y0 > N_RGB_ROW){
      color_i++;
      color_i %= N_COLOR;
      y0 = N_RGB_ROW;
      vy0 *= -1;
    }
    if(y0 < 0){
      color_i++;
      color_i %= N_COLOR;
      y0 = 0;
      vy0 *= -1;
    }

    if(y1 > N_RGB_ROW){
      color_i++;
      color_i %= N_COLOR;
      y1 = N_RGB_ROW;
      vy1 *= -1;
    }
    if(y1 < 0){
      color_i++;
      color_i %= N_COLOR;
      y1 = 0;
      vy1 *= -1;
    }
    if(color_i == 0){
      color_i = 1;
    }
    x0 += vx0;
    y0 += vy0;
    x1 += vx1;
    y1 += vy1;
    c3.line(x0, y0, x1, y1, COLORS[color_i]);
  }
  c3.refresh();
  count++;
}
