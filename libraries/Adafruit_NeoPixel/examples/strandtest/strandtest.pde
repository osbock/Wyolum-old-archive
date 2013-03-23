#include <Adafruit_NeoPixel.h>

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_RGB     Pixels are wired for RGB bitstream
//   NEO_GRB     Pixels are wired for GRB bitstream
//   NEO_KHZ400  400 KHz bitstream (e.g. FLORA pixels)
//   NEO_KHZ800  800 KHz bitstream (e.g. High Density LED strip)
// Adafruit_NeoPixel strip = Adafruit_NeoPixel(250, A5, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel strips[8];

void setup() {
  uint32_t c;
  for(int i = 2; i < 10; i++){
    strips[i - 2].setup(32, i, NEO_GRB + NEO_KHZ800);
    strips[i - 2].begin();
    for(int j = 0; j < 16; j++){
      c = strips[i - 2].Color(25, 25, 25);
      strips[i - 2].setPixelColor(j, c);
    }
    strips[i - 2].show(); // Initialize all pixels to 'off'
  }
  Serial.begin(115200);
  pinMode(7, OUTPUT);
  digitalWrite(7, HIGH);
  // pinMode(A2, OUTPUT);
  // pinMode(A3, OUTPUT);

  
}
void setall(uint32_t color){
  for(uint8_t k = 2; k < 10; k++){
    for(uint8_t i = 0; i < strips[k - 2].numPixels(); i++){
      strips[k - 2].setPixelColor(i, color);
    }
    strips[k - 2].show();
  }
}
int count = 0;
void loop() {
  count++;
  count %=255;
  
  // Some example procedures showing how to display to the pixels:
  uint8_t val = 255;
  int jj = 0, kk;
  uint32_t c;
  while(1){
    val++;
    for(kk = 2; kk < 10; kk++){
      jj++;
      for(uint8_t i = 0; i < strips[kk - 2].numPixels(); i++){
	strips[kk - 2].setPixelColor(i, Wheel((val  %  16) * 16 + jj % 16, 15));
      }
      strips[kk - 2].show();
      // delay(10);
    }
  }
}


uint32_t Wheel(byte WheelPos, uint8_t imax) {
  uint32_t r, g, b;
  if(WheelPos < 85) {
    r = WheelPos * 3;
    g = 255 - WheelPos * 3;
    b = 0;
  } else if(WheelPos < 170) {
    WheelPos -= 85;
    r = 255 - WheelPos * 3;
    g = 0;
    b = WheelPos * 3;
  } else {
    WheelPos -= 170;
    r = 0;
    g = WheelPos * 3;
    b = 255 - WheelPos * 3;
  }
  r = r * imax / 255;
  g = g * imax / 255;
  b = b * imax / 255;
  return strips[0].Color(r, g, b);
}

