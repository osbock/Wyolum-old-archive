#ifndef RTC_BOB_H
#define RTC_BOB_H

#include <inttypes.h>
#include "Time.h"
const uint8_t MONTHS[13] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30,31, 30, 31};

#define LEAP_YEAR(Y) (!((Y)%4) && ( ((Y)%100) || !((Y)%400)))

/*
 * single front end interface to both PCgetTime and RTCgetTime()
 * Uses RTC if available or INT if not.
 * Updates time from PC if available
 */
time_t getTime();

void setRTC(uint16_t YY, uint8_t MM, uint8_t DD, 
	    uint8_t hh, uint8_t mm, uint8_t ss);

// return temperature in degrees C
int getTemp();

// decimal to binary coded decimal
uint8_t dec2bcd(int dec);

// binary coded decimal to decimal
int bcd2dec(uint8_t bcd);

#endif
