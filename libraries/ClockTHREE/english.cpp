#include "ClockTHREE.h"
#include "english.h"

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
uint8_t its[3] = {0, 0, 3};
uint8_t a[3] = {0, 4, 1};
uint8_t mten[3] = {0, 5, 3};
uint8_t quarter[3] = {0, 9, 7};
uint8_t twenty[3] = {1, 0, 6};
uint8_t mfive[3] = {1, 6, 4};
uint8_t past[3] = {1, 11, 4};
uint8_t to[3] = {1, 14, 2};
uint8_t twelve[3] = {2, 0, 6};
uint8_t two[3] = {2, 6, 3};
uint8_t one[3] = {2, 8, 3};
uint8_t seven[3] = {2, 11, 5};
uint8_t four[3] = {3, 0, 4};
uint8_t hfive[3] = {3, 4, 4};
uint8_t six[3] = {3, 8, 3};
uint8_t three[3] = {3, 11, 5};
uint8_t eight[3] = {4, 0, 5};
uint8_t hten[3] = {4, 4, 3};
uint8_t nine[3] = {4, 6, 4};
uint8_t eleven[3] = {4, 9, 6};
uint8_t roman_i[3] = {4, 15, 1};
uint8_t beer[3] = {5, 0, 4};
uint8_t chai[3] = {5, 4, 4};
uint8_t oclock[3] = {5, 8, 6};
uint8_t roman_ii[3] = {5, 15, 1};
uint8_t thirty[3] = {6, 0, 6};
uint8_t in_the[3] = {6, 7, 5};
uint8_t in[3] = {6, 7, 2};
uint8_t the[3] = {6, 10, 3};
uint8_t at[3] = {6, 13, 2};
uint8_t roman_iii[3] = {6, 15, 1};
uint8_t midnight[3] = {7, 0, 8};
uint8_t night[3] = {7, 3, 5};
uint8_t evening[3] = {7, 8, 7};
uint8_t roman_iiii[3] = {7, 15, 1};
uint8_t morning[3] = {8, 0, 7};
uint8_t after[3] = {8, 7, 5};
uint8_t afternoon[3] = {8, 7, 9};
uint8_t noon[3] = {8, 12, 4};
uint8_t clocktwo[3] = {9, 3, 10};
uint8_t thank[3] = {10, 0, 5};
uint8_t we[3] = {10, 7, 2};
uint8_t need[3] = {10, 10, 4};
uint8_t you[3] = {11, 0, 4};
uint8_t your[3] = {11, 0, 4};
uint8_t support[3] = {11, 5, 7};
uint8_t emphasize[3] = {11, 12, 2};

static inline void display_word(ClockTHREE c3, uint8_t color, uint8_t *w){
  c3.fill_consecutive(w[0], w[1], w[2], color);
}

void English::display_time(int YY, int MM, int DD, int hh, int mm, int ss, 
			   ClockTHREE c3, uint8_t color){
  uint8_t hour = 0;
  uint8_t hour24 = 0;
  uint8_t h_offset = 0;
  
  display_word(c3, color, its);
  if (0 <= mm and mm < 5){
    display_word(c3, color, oclock);
    h_offset = 0;
  }
  else if(5 <= mm && mm < 10){
    display_word(c3, color, mfive);
    display_word(c3, color, past);
    h_offset = 0;
  }
  else if( 10 <= mm && mm < 15){
    display_word(c3, color, mten);
    display_word(c3, color, past);
    h_offset = 0;
  }
  else if( 15 <= mm && mm < 20){
    display_word(c3, color, a);
    display_word(c3, color, quarter);
    display_word(c3, color, past);
    h_offset = 0;
  }
  else if( 20 <= mm && mm < 25){
    display_word(c3, color, twenty);
    display_word(c3, color, past);
    h_offset = 0;
  }
  else if( 25 <= mm && mm < 30){
    display_word(c3, color, mfive);
    display_word(c3, color, twenty);
    display_word(c3, color, past);
    h_offset = 0;
  }
  else if( 30 <= mm && mm < 35){
    display_word(c3, color, thirty);
    h_offset = 0;
  }
  else if( 35 <= mm && mm < 40){
    display_word(c3, color, mfive);
    display_word(c3, color, twenty);
    display_word(c3, color, to);
    h_offset = 1;
  }
  else if( 40 <= mm && mm < 45){
    display_word(c3, color, twenty);
    display_word(c3, color, to);
    h_offset = 1;
  }
  else if( 45 <= mm && mm < 50){
    display_word(c3, color, a);
    display_word(c3, color, quarter);
    display_word(c3, color, to);
    h_offset = 1;
  }
  else if( 50 <= mm && mm < 55){
    display_word(c3, color, mten);
    display_word(c3, color, to);
    h_offset = 1;
  }
  else if( 55 <= mm && mm < 60){
    display_word(c3, color, mfive);
    display_word(c3, color, to);
    h_offset = 1;
  }
  else{
    // ValueError('mm: %s' % mm);
  }
  hour = (hh + h_offset) % 12;
  if(hour == 0){
    display_word(c3, color, twelve);
  }
  else if(hour == 1){
    display_word(c3, color, one);
  }
  else if(hour == 2){
    display_word(c3, color, two);
  }
  else if(hour == 3){
    display_word(c3, color, three);
  }
  else if(hour == 4){
    display_word(c3, color, four);
  }
  else if(hour == 5){
    display_word(c3, color, hfive);
  }
  else if(hour == 6){
    display_word(c3, color, six);
  }
  else if(hour == 7){
    display_word(c3, color, seven);
  }
  else if(hour == 8){
    display_word(c3, color, eight);
  }
  else if(hour == 9){
    display_word(c3, color, nine);
  }
  else if(hour == 10){
    display_word(c3, color, hten);
  }
  else if(hour == 11){
    display_word(c3, color, eleven);
  }
  
  hour24 = (hh + h_offset) % 24;
  if(0 <= hour24  && hour24 < 1){
    if(30 <= mm && mm < 35){
      display_word(c3, color, in);
      display_word(c3, color, the);
      display_word(c3, color, morning);
    }
    else{
      display_word(c3, color, midnight);
    }
  }
  else if(1 <= hour24  && hour24 < 12){
    display_word(c3, color, in);
    display_word(c3, color, the);
    display_word(c3, color, morning);
  }
  else if( 12 <= hour24  && hour24 < 13){
    if (30 <= mm && mm < 35){
      display_word(c3, color, in);
      display_word(c3, color, the);
      display_word(c3, color, morning);
    }
    else{
      display_word(c3, color, noon);
    }
  }
  else if( 13 <= hour24  && hour24 < 17){
    display_word(c3, color, in);
    display_word(c3, color, the);
    display_word(c3, color, afternoon);
  }
  else if( 17 <= hour24  && hour24 < 20){
    display_word(c3, color, in);
    display_word(c3, color, the);
    display_word(c3, color, evening);
  }
  else if( 20 <= hour24  && hour24 < 24){
    display_word(c3, color, at);
    display_word(c3, color, night);
  }
}
