#ifndef ENGLISH_H
#define ENGLISH_H
#include "ClockTHREE.h"

/* char text[12 * 16 + 1] = 
  "ITSXATENRQUARTER"
  "TWENTYFIVEDPASTO"
  "TWELVETWONESEVEN"
  "FOURFIVESIXTHREE"
  "EIGHTENINELEVEN-"
  "BEERCHAIOCLOCKM-"
  "THIRTYUINITHEAT-"
  "MIDNIGHTEVENING-"
  "MORNINGAFTERNOON"
  "IXICLOCKTHREE789"
  "THANKVIWEMNEED17"
  "YOUR!SUPPORT!!89";
*/

class English{
 public:
  // display time on ClockTHREE in words.
  // fade_steps is a parameter for smoothing the transistion
  // 0 -- no smoothing, 50 -- high smoothing.
  void display_time(int YY, int MM, int DD, int hh, int mm, int ss,
		    ClockTHREE c3, uint8_t color, uint8_t fade_steps);
};

#endif
