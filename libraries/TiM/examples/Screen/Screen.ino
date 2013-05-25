#include "Adafruit_NeoPixel.h"
#include "TiM.h"
#include "SPI.h"
#include "SD.h"

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_RGB     Pixels are wired for RGB bitstream
//   NEO_GRB     Pixels are wired for GRB bitstream
//   NEO_KHZ400  400 KHz bitstream (e.g. FLORA pixels)
//   NEO_KHZ800  800 KHz bitstream (e.g. High Density LED strip)
const uint8_t n_strip = 8;
const uint16_t n_led_per_strip = 64;
const uint8_t n_byte_per_led = 3;
const uint16_t n_byte_per_strip = n_led_per_strip * n_byte_per_led;
const uint8_t UNIFONT_RECLEN = 33;
uint8_t buffer[n_byte_per_strip];

Adafruit_NeoPixel strips[n_strip];
Adafruit_NeoPixel strip; //  = Adafruit_NeoPixel();
uint8_t my_buffer[n_byte_per_strip];
uint8_t unifont_data[UNIFONT_RECLEN - 1];
TiM tim;

// Use Arduino Pins 2-9 for controling the strips of TiM
uint8_t pins[8] = { 
  2,  3,  4,  5,  6,  7,  8,  9,
};

File display_file, unifont_file;


void SD_setPixel(uint8_t x, uint8_t y, uint32_t color){
  uint32_t pos;
  uint16_t row, col;
  uint8_t r, g, b;

#define TRANSLATE
#ifdef TRANSLATE
  // translate if needed
  if((0 <= x && x < 32) && (0 <= y && y < 16)){
    row = y % 8;
    if(y < 8){
      col = x + 16;
    }
    else{
      if(x < 16){
	col = x;
      }
      else{
	col = x + 32;
      }
    }
  }
  else{
    return;
  }
#else
  col = x;
  row = y;
#endif
  if(0 <= col && col < n_led_per_strip && 0 <= row & row < n_strip){
    // xy2tim(x, y, &row, &col);
    pos = (uint16_t)n_byte_per_strip * row + (uint16_t)n_byte_per_led * col;
    display_file.seek(pos);
    r = (color >> 8) & 255;
    g = (color >> 16) & 255;
    b = (color >> 0) & 255;
    
    display_file.write(r);
    display_file.write(g);
    display_file.write(b);
  }
  return;
}
void draw_line(int16_t startx, int16_t starty, int16_t stopx, int16_t stopy, uint32_t color){
  float dx = (stopx - startx);
  float dy = (stopy - starty);
  int16_t l = sqrt(dx * dx + dy * dy);
  int16_t x, y, lastx, lasty;

  lastx = lasty = -1; // impossible value
  SD_setPixel(startx, starty, color); 

  for(uint16_t t = 0; t < l; t++){
    x = startx + dx * t / l;
    y = starty + dy * t / l;
    if(lastx != x || lasty != y){ // don't write to a pix more than once (oops)
      SD_setPixel(x, y, color); 
    }
    lastx = x;
    lasty = y;
  }
  SD_setPixel(stopx, stopy, color); 
}
  

void sd_scroll_left(uint8_t n_byte){
  char tmp[n_byte_per_strip];
  int16_t i, j;
  for(i = 0; i < n_strip; i++){
    // read a row
    display_file.seek(i * n_byte_per_strip);
    for(j = 0; j < n_byte_per_strip; j++){
      tmp[j] = display_file.read();
    }
    // write a row
    display_file.seek(i * n_byte_per_strip);
    for(int i = 0; i < n_byte_per_strip; i++){
      display_file.write(tmp[(i + n_byte) % n_byte_per_strip]);
    }
  }
}
  
void SD_show(){
  display_file.seek(0);
  for(int ii=0; ii < n_strip; ii++){
    for(int jj=0; jj < n_led_per_strip; jj++){
      uint8_t r, g, b;
      r = display_file.read();
      g = display_file.read();
      b = display_file.read();
      tim.setPixel(ii, jj, Color(r, g, b));
    }
    tim.strips[ii].show();
  }
}
void openDisplay(){
  unifont_file = SD.open("unifont.wff");
  if(!unifont_file){
    Serial.print("Could not open unifont.wff");
    while(1) delay(100);
  }
  display_file = SD.open("_.DSP", FILE_WRITE);
  if(!display_file){
    Serial.print("Could not open _.DSP");
    while(1) delay(100);
  }
  display_file.seek(0);
}
void closeDisplay(){
  display_file.close();
  unifont_file.close();
}

void setup() {
  Serial.begin(115200);
  tim.setup(n_strip, n_led_per_strip, pins, my_buffer);
  Serial.println("SD begin");
  if (!SD.begin(10)){
    Serial.println("initialization failed!");
    while(1) delay(100);
  }
}

uint16_t put_char(uint16_t x, uint16_t y, uint16_t unic, uint32_t color){
  uint32_t pos;
  uint8_t char_width;
  uint8_t out = 16;

  char_width = unifont_read_char(unifont_file, unic, unifont_data) / 16;
  for(uint16_t i = 0; i < 16; i++){
    for(byte j = 0; j < char_width; j++){
      byte b = unifont_data[char_width * i + j];
      for(byte bit_k = 0; bit_k < 8; bit_k++){
	if(b >> bit_k & 1){
	  SD_setPixel(x + j * 8 + bit_k, y + i, color);
	  SD_setPixel(x + j * 8 + bit_k + 1, y + i, color);
	}
	else{
	  // SD_setPixel(x + j * 8 + bit_k, y + i, 0);
	}
      }
    }
  }
  out = char_width * 8;
  return out;
}

uint8_t unifont_read_char(File unifont_file, uint32_t i, uint8_t *dest){
  uint8_t n_byte;
  // expects unifont file to be open

  unifont_file.seek(i * UNIFONT_RECLEN);
  n_byte = (uint8_t)unifont_file.read();

  for(uint8_t i = 0; i < n_byte; i++){
    dest[i] = (uint8_t)unifont_file.read();
  }

  return n_byte;
}

bool char_is_blank(uint32_t unic){
  // expects unifont_file to be open
  bool out = true;
  uint8_t n_byte;
  uint8_t i;
  n_byte = unifont_read_char(unifont_file, unic, unifont_data);
  for(i = 0; i < n_byte && out; i++){
    if(unifont_data[i] > 0){
      out = false;
    }
  }
  return out;
}

uint16_t put_ascii(uint16_t x, uint16_t y, char * ascii, bool color){
  char c = 'A';
  for(uint8_t i = 0; ascii[i] > 0; i++){
    x += put_char(x, y, ascii[i], color);
  }
  return x;
}

uint16_t put_unicode(uint16_t x, uint16_t y, uint16_t *unicode, bool color){
  for(uint8_t i = 0; unicode[i] > 0; i++){
    x += put_char(x, y, unicode[i], color);
  }
  return x;
}

uint32_t loop_count = 32;
int16_t row = 0;
int16_t col = 0;
void loop() {
  // Some example procedures showing how to display to the pixels:
  uint8_t i, j, r, g, b;
  uint32_t c1, c2, c3;
  Serial.println();
  Serial.println();
  r = random(0, 50);
  g = random(0, 50);
  b = random(0, 50);
  c1 = Color(0, 0, 50);
  c2 = Color(0, 50, 0);
  c3 = Color(50, 0, 0);
  openDisplay();
  colorWipe(0);
  //put_char( 0, 0, (uint16_t)loop_count + 0, c1);
  //put_char( 8, 0, (uint16_t)loop_count + 1, c1);
  //put_char(16, 0, (uint16_t)loop_count + 2, c1);
  //put_char(24, 0, (uint16_t)loop_count + 3, c1);
  //put_char(32, 0, (uint16_t)loop_count + 4, c1);
  
  float theta1 = loop_count * 2 * (3.14159) / 32;
  float theta2 = loop_count * 3.231231 * (3.14159) / 32;
  float theta3 = loop_count * 5.81 * (3.14159) / 32;
  draw_line( cos(theta1) * 18 + 16.5,  sin(theta1) * 18 + 8.5, 
	    -cos(theta1) * 18 + 16.5, -sin(theta1) * 18 + 8.5, c1);
  draw_line( cos(theta2) * 18 + 16.5,  sin(theta2) * 18 + 8.5, 
	    -cos(theta2) * 18 + 16.5, -sin(theta2) * 18 + 8.5, c2);
  draw_line( cos(theta3) * 18 + 16.5,  sin(theta3) * 18 + 8.5, 
	    -cos(theta3) * 18 + 16.5, -sin(theta3) * 18 + 8.5, c3);
  SD_show();
  closeDisplay();
  loop_count++;
}

// Fill the dots one after the other with a color
void colorWipe(uint32_t c) {
  uint8_t r, g, b;
  r = (c >> 8) & 255;
  g = (c >> 16) & 255;
  b = (c >> 0) & 255;
  for(int ii = 0; ii < n_led_per_strip * n_strip; ii++){
    display_file.write(r);
    display_file.write(g);
    display_file.write(b);
  }
}

