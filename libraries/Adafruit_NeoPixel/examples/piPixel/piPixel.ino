#include <Adafruit_NeoPixel.h>

uint16_t N_PIX = 250; // number of pixels
uint8_t D0 = A5;      // Data pin

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_RGB     Pixels are wired for RGB bitstream
//   NEO_GRB     Pixels are wired for GRB bitstream
//   NEO_KHZ400  400 KHz bitstream (e.g. FLORA pixels)
//   NEO_KHZ800  800 KHz bitstream (e.g. High Density LED strip)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(N_PIX, D0, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(115200);
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}


void loop(){
  if(serial_interact()){
    strip.show();
  }
}


/*
 * read serial stream into command buffer.  First byte is offset
 * return true if valid command is sent
 */
boolean serial_interact(){
  unsigned int pos = 0;
  boolean out = false;
  if(Serial.available()){
    if(Serial.available() > 1){
      pos = Serial.read();
      pos += Serial.read() * 256;
      delay(1); // wait for rest of message (BUG ALERT!!!)
      while(Serial.available() && (pos < strip.numBytes)){
	out = true; // new data
	strip.pixels[pos] = Serial.read();
	pos++;
	if(!Serial.available()){
	  delay(1); // wait for more chars (BUG ALERT!!!)
	}
      }
    }
  }
  return out;
}
