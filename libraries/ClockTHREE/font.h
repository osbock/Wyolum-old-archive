#include <avr/pgmspace.h>
const uint8_t N_CHAR = 128;
class Font{
 public:
  void getChar(char letter, uint8_t color, uint32_t* out);

 private:
};
