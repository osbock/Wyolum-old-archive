#include <Adafruit_NeoPixel.h>
#include "SPI.h"
#include "SD.h"

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_RGB     Pixels are wired for RGB bitstream
//   NEO_GRB     Pixels are wired for GRB bitstream
//   NEO_KHZ400  400 KHz bitstream (e.g. FLORA pixels)
//   NEO_KHZ800  800 KHz bitstream (e.g. High Density LED strip)
const uint8_t n_strip = 1;
const uint16_t n_led_per_strip = 16;
const uint8_t n_byte_per_led = 3;
const uint16_t n_byte_per_strip = n_led_per_strip * n_byte_per_led;
uint8_t buffer[n_byte_per_strip];

Adafruit_NeoPixel strips[n_strip];
Adafruit_NeoPixel strip; //  = Adafruit_NeoPixel();

// Use Arduino Pins 2-9 for controling the strips of TiM
uint8_t pins[8] = {2, 3, 4, 5, 6, 7, 8, 9};

File display_file;

void SD_setPixel(uint8_t x, uint8_t y, uint32_t color){
  uint32_t pos;
  uint16_t row, col;
  uint8_t r, g, b, brightness=20;
  return;
  col = x;
  row = y;
  // xy2tim(x, y, &row, &col);
  pos = (uint16_t)n_byte_per_strip * row + (uint16_t)n_byte_per_led * col;
  Serial.print("pos:");
  Serial.println(pos);
  display_file.seek(pos);
  display_file.write((color >> 8) & 255);
  display_file.write((color >> 16) & 255);
  display_file.write((color >> 0) & 255);

  // read back to check
  display_file.seek(pos);
  Serial.print("saved color: ");
  Serial.print(display_file.read(), DEC);
  Serial.print(", ");
  Serial.print(display_file.read(), DEC);
  Serial.print(", ");
  Serial.print(display_file.read(), DEC);
  Serial.println("");
}

void SD_show(){
  // display_file.seek(0);
  for(uint8_t i = 0; i < n_strip; i++){
    for(uint8_t j = 0; j < n_byte_per_strip; j++){
      for(uint8_t k = 0; k < 3; k++){
	buffer[j + k] = random(0, 16);
      }
      //buffer[j] = display_file.read();
    }
    strip = strips[i];
    strip.begin();
    strips[i].show();
  }
  Serial.print("retrieved color: ");
  Serial.print(buffer[0], DEC);
  Serial.print(", ");
  Serial.print(buffer[1], DEC);
  Serial.print(", ");
  Serial.print(buffer[2], DEC);
  Serial.println("");
}

void setup() {
  Serial.begin(115200);
  pinMode(10, OUTPUT);
  for(uint8_t i=0; i < n_strip; i++){
    strips[i].setup(n_led_per_strip, pins[i], NEO_GRB + NEO_KHZ800, buffer);
    strip = strips[i];
    strip.begin();
    strip.show(); // Initialize all pixels to 'off'
    display_file.write(buffer, n_byte_per_strip);
    Serial.println(display_file.position());
  }
  if (!SD.begin(10)){
    Serial.println("initialization failed!");
    while(1) delay(100);
  }
  else{
    Serial.println("SD initialized!");
  }
  
  display_file = SD.open("_.DSP", FILE_WRITE);
  SD_setPixel(0, 0, strip.Color(25, 0, 0));
  SD_show();
}

void loop() {
  // Some example procedures showing how to display to the pixels:
  uint8_t i, j, r, g, b;

  i = random(0, 7);
  j = random(0, 16);
  r = random(0, 16);
  g = random(0, 16);
  b = random(0, 16);
  // SD_setPixel(0, 7, strip.Color(r, g, b));
  SD_show();
  delay(200);
  Serial.println("loop()");
}

// Fill the dots one after the other with a color
void colorWipe(uint32_t c) {
  for(uint16_t i=0; i<strip.numPixels(); i++){
    for(uint16_t j=0; j<strip.numPixels(); j++){
      // SD_setPixel(i, j, c);
      // strip.setPixelColor(i, c);
    }
  }
}

