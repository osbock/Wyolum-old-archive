#ifndef RTC_BOB_H
#define RTC_BOB_H

#include <inttypes.h>
#include "Time.h"

/*
 * single front end interface to both PCgetTime and RTCgetTime()
 * Uses RTC if available or INT if not.
 * Updates time from PC if available
 */
time_t getTime();

// return temperature in degrees C
int getTemp();

// decimal to binary coded decimal
uint8_t dec2bcd(int dec);

// binary coded decimal to decimal
int bcd2dec(uint8_t bcd);

#endif
