/*
 * This code should be loaded onto an I2GPS driver (GPS not used, SD not used).  
 * This allows the PEGGY2 to continue to refresh while the driver does time look up and calculations.
 * 
 * This code is released to the public domain.
 */
#include <Wire.h>
#include "SPI.h"
#include "rtcBOB.h"
#include "Time.h"
#include "MsTimer2.h"
#include "ClockTHREE.h"
#include "Peggy2_Slave.h"
#include "Peggy2_memory_map.h"
#include "messaging.h"
#include "avr/pgmspace.h"

union data{
  uint8_t bytes[4];
  uint16_t uint16_vals[2];
  int int_val;
  float float_val;
} _converter;
  
//******************************************************************************
// I2GPS constants
#include <SD.h>
const int chipSelect = 10;
const int D1_PIN = 2;
const int D2_PIN = 3;
File myFile;

volatile uint16_t valid_msg = 0;
volatile unsigned long pulse_start = 0;
const int BIT_BUFFER_LEN = 16;
volatile boolean bits[BIT_BUFFER_LEN];
volatile unsigned long pws[BIT_BUFFER_LEN];
volatile uint16_t buffer = 1;
volatile uint16_t msg = 1;
volatile int bit_i = 0;
const short pw_thresh = 1000;
const uint16_t START_SEQ = 0x00ff;
const uint16_t STOP_SEQ = 0x005f;
const uint16_t STOP_SEQ_LEN = 8;
const uint16_t MSG_LEN = 10;
const uint16_t STARTING = 1;
const uint16_t MSG_STATE = 2;
const uint16_t STOPPING = 3;
volatile uint16_t state = STARTING;

long i = 1;

PROGMEM  prog_uint32_t USA_DST[]  = {
//       start,       stop,      // year
     952840800,  973404000,      // 2000
     984290400, 1004853600,      // 2001
    1015740000, 1036303200,      // 2002
    1047189600, 1067752800,      // 2003
    1079244000, 1099807200,      // 2004
    1110693600, 1131256800,      // 2005
    1142143200, 1162706400,      // 2006
    1173592800, 1194156000,      // 2007
    1205042400, 1225605600,      // 2008
    1236492000, 1257055200,      // 2009
    1268546400, 1289109600,      // 2010
    1299996000, 1320559200,      // 2011
    1331445600, 1352008800,      // 2012
    1362895200, 1383458400,      // 2013
    1394344800, 1414908000,      // 2014
    1425794400, 1446357600,      // 2015
    1457848800, 1478412000,      // 2016
    1489298400, 1509861600,      // 2017
    1520748000, 1541311200,      // 2018
    1552197600, 1572760800,      // 2019
    1583647200, 1604210400,      // 2020
    1615701600, 1636264800,      // 2021
    1647151200, 1667714400,      // 2022
    1678600800, 1699164000,      // 2023
    1710050400, 1730613600,      // 2024
    1741500000, 1762063200,      // 2025
    1772949600, 1793512800,      // 2026
    1805004000, 1825567200,      // 2027
    1836453600, 1857016800,      // 2028
    1867903200, 1888466400,      // 2029
    1899352800, 1919916000,      // 2030
    1930802400, 1951365600,      // 2031
    1962856800, 1983420000,      // 2032
    1994306400, 2014869600,      // 2033
    2025756000, 2046319200,      // 2034
    2057205600, 2077768800,      // 2035
    2088655200, 2109218400,      // 2036
    2120104800, 2140668000,      // 2037
    2152159200, 2172722400,      // 2038
    2183608800, 2204172000,      // 2039
    2215058400, 2235621600,      // 2040
    2246508000, 2267071200,      // 2041
    2277957600, 2298520800,      // 2042
    2309407200, 2329970400,      // 2043
    2341461600, 2362024800,      // 2044
    2372911200, 2393474400,      // 2045
    2404360800, 2424924000,      // 2046
    2435810400, 2456373600,      // 2047
    2467260000, 2487823200,      // 2048
    2499314400, 2519877600,      // 2049
    2530764000, 2551327200,      // 2050
    2562213600, 2582776800,      // 2051
    2593663200, 2614226400,      // 2052
    2625112800, 2645676000,      // 2053
    2656562400, 2677125600,      // 2054
    2688616800, 2709180000,      // 2055
    2720066400, 2740629600,      // 2056
    2751516000, 2772079200,      // 2057
    2782965600, 2803528800,      // 2058
    2814415200, 2834978400,      // 2059
    2846469600, 2867032800,      // 2060
    2877919200, 2898482400,      // 2061
    2909368800, 2929932000,      // 2062
    2940818400, 2961381600,      // 2063
    2972268000, 2992831200,      // 2064
    3003717600, 3024280800,      // 2065
    3035772000, 3056335200,      // 2066
    3067221600, 3087784800,      // 2067
    3098671200, 3119234400,      // 2068
    3130120800, 3150684000,      // 2069
    3161570400, 3182133600,      // 2070
    3193020000, 3213583200,      // 2071
    3225074400, 3245637600,      // 2072
    3256524000, 3277087200,      // 2073
    3287973600, 3308536800,      // 2074
    3319423200, 3339986400,      // 2075
    3350872800, 3371436000,      // 2076
    3382927200, 3403490400,      // 2077
    3414376800, 3434940000,      // 2078
    3445826400, 3466389600,      // 2079
    3477276000, 3497839200,      // 2080
    3508725600, 3529288800,      // 2081
    3540175200, 3560738400,      // 2082
    3572229600, 3592792800,      // 2083
    3603679200, 3624242400,      // 2084
    3635128800, 3655692000,      // 2085
    3666578400, 3687141600,      // 2086
    3698028000, 3718591200,      // 2087
    3730082400, 3750645600,      // 2088
    3761532000, 3782095200,      // 2089
    3792981600, 3813544800,      // 2090
    3824431200, 3844994400,      // 2091
    3855880800, 3876444000,      // 2092
    3887330400, 3907893600,      // 2093
    3919384800, 3939948000,      // 2094
    3950834400, 3971397600,      // 2095
    3982284000, 4002847200,      // 2096
    4013733600, 4034296800,      // 2097
    4045183200, 4065746400,      // 2098
    4076632800, 4097196000,      // 2099
};

// Clear peggy2
void clear(){
  for(int slave=0; slave < 3; slave++){
    Wire.beginTransmission(PEGGY2_BASE_ADDR);
    Wire.write(PEGGY2_CLEAR_MSG);
    Wire.endTransmission();
  }
}

// Set EMSL asterisk PWM
void set_emsl(uint8_t pwm){
  Wire.beginTransmission(PEGGY2_BASE_ADDR);
  Wire.write(PEGGY2_SET_EMSL_PWM_MSG);
  Wire.write(255 - pwm);
  Wire.endTransmission();
}

// set a pixel on Peggy2
void set_pixel(uint8_t x, uint8_t y, bool on){
  if(on){
    y |= (1<<7) * on;
  }
  Wire.beginTransmission(PEGGY2_BASE_ADDR);
  Wire.write(PEGGY2_SET_PIXEL_MSG);
  Wire.write(y);
  Wire.write(x);
  Wire.endTransmission();
}

void set_row(uint8_t y, uint32_t state){
  Wire.beginTransmission(PEGGY2_BASE_ADDR);
  Wire.write(PEGGY2_SET_ROW_MSG);
  Wire.write(y);
  Wire.write((uint8_t)(state>>8 * 0));
  Wire.write((uint8_t)(state>>8 * 1));
  Wire.write((uint8_t)(state>>8 * 2));
  Wire.write((uint8_t)(state>>8 * 3));
  Wire.endTransmission();
}

void setup(){
  Serial.begin(57600);
  Serial.println("Peggy2 WordClock 1.0!");
  Serial.println("WyoLum, LLC, 2012");
  Serial.print("Using Peggy2 I2C Address: ");
  Serial.println(PEGGY2_BASE_ADDR);
  Serial.println(is_usa_dst(getTime()));
  // LED are output
  pinMode(D1_PIN, OUTPUT);
  pinMode(D2_PIN, OUTPUT);

#ifdef SDINIT // NOT USED
  Serial.print("Initializing SD card...");
  pinMode(10, OUTPUT);
  digitalWrite(D1_PIN, HIGH); 
  if (!SD.begin(chipSelect)) {
    digitalWrite(D1_PIN, LOW); 
    Serial.println("SD initialization failed!");
    return;
  }
  Serial.println("SD initialization done.");
#endif
  Wire.begin();
  clear();
  delay(200);
  Serial.print("RTC Unix Time:");
  Serial.println(getTime(), DEC);
  
  // blink LEDs on I2GPS
  for(int i=0; i < 5; i++){
    digitalWrite(D1_PIN, LOW);
    digitalWrite(D2_PIN, HIGH);
    delay(200);
    digitalWrite(D1_PIN, HIGH);
    digitalWrite(D2_PIN, LOW);
    delay(200);
  }
  
}

unsigned long count = 0;

// ClockTHREE c3;                      // ClockTHREE singleton
uint32_t rows[25];               // 2X display (16 columns per display) for swapping back and forth

// language constants
uint8_t n_minute_led;               // number of minute hack leds
uint8_t n_minute_state = 30;             // number of minute hack states to cycle through
uint8_t n_byte_per_display = 4;         // number of bytes used for each 5 minunte time incriment

// globals
int display_idx;                  // display index (0 or 1)
uint8_t last_min_hack_inc = 0;    // last mininte hack incriment (to know when it has changed)
uint8_t last_time_inc = 289;        // last time incriment (to know when it has changed)
uint8_t last_pwm = 0;

void loop(){
  Serial_loop();
  time_t now = getTime();
  if(is_usa_dst(now)){
    now += 3600; // dailight savings time
  }
  else{
    // standard time
  }
  uint8_t word[3];                // will store start_x, start_y, length of word
  time_t spm = now % 86400; // seconds past midnight
  uint16_t time_inc = spm / 300;  // 5-minute time increment are we in
  
  // which mininute hack incriment are we on?

  uint8_t minute_hack_inc = (spm % 300) / (300. / float(n_minute_state));

  // if minute hack or time has changed, update the display
  if(minute_hack_inc != last_min_hack_inc || time_inc != last_time_inc){
    // read display for next time incement
    for(uint8_t i = 0; i < 25; i++){ // clear the display
      rows[i] = 0;
    }
    getdisplay(time_inc, rows);
  
    // read minutes hack for next time incement
    rows[24] = minutes_hack(minute_hack_inc);
    for(uint8_t row_i=0; row_i<25; row_i++){
      set_row(row_i, rows[row_i]);
    }
    last_min_hack_inc = minute_hack_inc;
    last_time_inc = time_inc;
  }
  // Keep active LEDs lit
  delay(10);
  int pwm = (int)(5 * sin(count / 100.) + 6) * 5;
  if (pwm  > 255){
    pwm = 255;
  }
  if (pwm  < 0){
    pwm = 0;
  }
  if(last_pwm != pwm){
    set_emsl((uint8_t)pwm);
    last_pwm = pwm;
  }
  count++;
}

/*
 * DISPLAYS: 288 32 bit settings.  one for each 5-minute period.  up to 32 words per setting.
 * To turn on word one in ith display: 10000000000000000000000000000000
 *
 * WORDS:  3 * n + 1 bytes.  first byte is # words followed by ordered words.
 *                                    x         y       l
 *        Each word is defined by startcol, startrow, len
 */

void getword(int i, uint8_t* out){
  out[0] = pgm_read_byte(WORDS + 3 * i + 1);
  out[1] = pgm_read_byte(WORDS + 3 * i + 2);
  out[2] = pgm_read_byte(WORDS + 3 * i + 3);
}

/*
 * Prepare out to display ith time increment
 *   i -- 0 to 287 time increment indexa
 * out -- points to column data to prepare
 */
void getdisplay(int i, uint32_t* rows){
  uint8_t bits;     // holds the on off state for 8 words at a time
  uint8_t word[3];  // start columm, start row, length of the current word
  uint8_t x, y, len;

  for(uint8_t j = 0; j < n_byte_per_display; j++){ // j is a byte index 

    // read the state for the next set of 8 words
    bits = pgm_read_byte(DISPLAYS + 1 + (i * n_byte_per_display) + j);
    for(uint8_t k = 0; k < 8; k++){                     // k is a bit index
      if((bits >> k) & 1){                              // check to see if word is on or off
	getword(j * 8 + k, word);                       // if on, read location and length
	x = word[0];
	y = word[1];
	len = word[2];
	for(int m=x; m < x + len; m++){ // and display it
	  rows[2 * y    ] |= (uint32_t)1 << (2 * m);                       // rows/cols swapped
	  rows[2 * y + 1] |= (uint32_t)1 << (2 * m) ;                  // double up
	  
	  rows[2 * y    ] |= (uint32_t)1 << (2 * m + 1);                   // double up
	  rows[2 * y + 1] |= (uint32_t)1 << (2 * m + 1);               // double up
	}
      }
    }
  } 
}

/*
 * minutes_hack -- prepare display to show ith minute hack intrement
 *   i -- minute hack index
 * out -- display to prepare
 */
uint32_t minutes_hack(uint8_t i){
  // 0 <= i < 26 , 26 states
  // out, the display
  uint32_t out = 0;
  uint8_t start;

  if(i < 5){
    start = 0;
  }
  else{
    start = i - 5;
  }
  for(uint8_t j = start; j < i && j < 24; j++){
    out |= (((uint32_t)1) << j) * (j < i);
  }
  return out;
}

bool is_usa_dst(time_t time){
  int yy = year(time) % 100;
  time_t start = pgm_read_dword_near(USA_DST + 2 * yy);
  time_t stop = pgm_read_dword_near(USA_DST + 2 * yy + 1);
  bool out = (start < time) && (time < stop);

#ifdef NOTDEF
  Serial.print(time);
  Serial.print(" ");
  Serial.print(yy);
  Serial.print(" ");
  Serial.print(start);
  Serial.print(" ");
  Serial.print(stop);
  Serial.print(" ");
  Serial.print(start < time);
  Serial.print(" ");
  Serial.print(time < stop);
  Serial.print(" ");
  Serial.print((start < time) && (time < stop));
  Serial.print(" ");
  Serial.println(out);
#endif  
  return out;
}
