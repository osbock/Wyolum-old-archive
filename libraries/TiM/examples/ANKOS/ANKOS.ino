#include "TiM.h"
#include "Adafruit_NeoPixel.h"
TiM tim;

// Use Arduino Pins 2-9 for controling the rows of TiM
uint8_t pins[8] = {2, 3, 4, 5, 6, 7, 8, 9};
uint8_t rule;
const uint16_t n_led_per_row = 32;

void setup(){
  rule = 16; // rainbow one row at a time
  rule = 26; // bad assed psycadelic rain:22 26 82 90 102 126 146 150
  // each Pin has 32 leds
  //    #rows #led pin_ids
  Serial.begin(115200);
  tim.setup(8, n_led_per_row, pins);
  init_rule();
}

uint32_t count = 0;
uint16_t row, col;
const uint16_t n_bit = 24 * n_led_per_row;

// Class BitArray
bool BitArray_get(uint8_t *arr, int16_t idx){
  bool out = false;
  if(idx >= 0){
    out = (bool)((arr[idx / 8] >> (idx % 8)) & 1);
  }
  return out;
}

bool BitArray_set(uint8_t *arr, uint16_t idx, bool bit){
  uint8_t byte_i = idx / 8;
  uint8_t bit_j = (idx % 8);
  if(bit){ // set bit
    arr[byte_i] |= (bit << bit_j);
  }
  else{ // unset bit
    if(arr[byte_i] & (1L << bit_j)){
      arr[byte_i] -= (1L << bit_j);
    }
  }
}

bool compute(uint8_t cells, uint8_t rule){
  return (rule >> cells) & 1;
}

void update(){
  uint8_t cells;
  int16_t bit_idx;
  bool bit;
  for(bit_idx = n_bit / 2; bit_idx < n_bit; bit_idx++){
    cells = 0;
    if(bit_idx > n_bit / 2){
      cells += BitArray_get(tim.strips[1].pixels, bit_idx - 1) << 2;
    }
    cells += BitArray_get(tim.strips[1].pixels, bit_idx + 0) << 1;
    if(bit_idx < n_bit - 1){
      cells += BitArray_get(tim.strips[1].pixels, bit_idx + 1) << 0;
    }
    bit = compute(cells, rule);
    BitArray_set(tim.strips[0].pixels, bit_idx, bit);
  }
}
void init_rule(){
    tim.setall(Color(0, 0, 0));
    BitArray_set(tim.strips[0].pixels, 24 * 24 + 1, true);
}
void scroll_down(){
  for(int8_t row = 8 - 1; row > 0; row--){
    for(uint16_t byte_i = 0; byte_i < 16*3; byte_i++){
      tim.strips[row].pixels[byte_i] = tim.strips[row - 1].pixels[byte_i];
    }
  }
  for(uint16_t byte_i = 0; byte_i < 16*3; byte_i++){
    tim.strips[0].pixels[byte_i] = tim.strips[7].pixels[byte_i + 16*3];
  }
  for(int8_t row = 8 - 1; row > 0; row--){
    for(uint16_t byte_i = 16*3; byte_i < 32*3; byte_i++){
      tim.strips[row].pixels[byte_i] = tim.strips[row - 1].pixels[byte_i];
    }
  }
}
void loop(){
  scroll_down();
  update();
  tim.show();
  count++;
  interact();
}

void interact(){
  if(Serial.available()){
    rule++;
    rule %= 256;
    init_rule();
    Serial.println(rule);
    while(Serial.available()){
      Serial.read();
    }
  }
}
