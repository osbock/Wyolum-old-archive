// Updated 7, 2011 optimized by Justin Shaw wyojustin@gmail.com (TJS)

#ifndef TimeAlarms_h
#define TimeAlarms_h

#include <inttypes.h>

#include "Time.h"

#define dtNBR_ALARMS 10 // may need more alarms!

typedef enum { dtMillisecond, dtSecond, dtMinute, dtHour, dtDay } dtUnits_t;

typedef struct  {
  uint8_t isAllocated            :1 ;  // the alarm is avialable for allocation if false
  uint8_t isEnabled              :1 ;  // the timer is only actioned if isEnabled is true 
  uint8_t isOneShot              :1 ;  // the timer will be de-allocated after trigger is processed 
  uint8_t isAlarm                :1 ;  // time of day alarm if true, period timer if false
  uint8_t countdown_sec          :1;
  uint8_t countdown_min          :1;
  uint8_t countdown_5min         :1;
  uint8_t countdown_hour         :1;
  uint8_t countdown_day          :1;
  uint8_t sunday                 :1;
  uint8_t monday                 :1;
  uint8_t tuesday                :1;
  uint8_t wednedsay              :1;
  uint8_t thursday               :1;
  uint8_t friday                 :1;
  uint8_t saturday               :1;
 }
    AlarmMode_t   ;

typedef uint8_t AlarmID_t;
typedef AlarmID_t AlarmId;  // Arduino friendly name
#define dtINVALID_ALARM_ID 255


class AlarmClass;  // forward reference
typedef void (*OnTick_t)();  // alarm callback function typedef 

// class defining an alarm instance, only used by dtAlarmsClass
class AlarmClass
{  
private:
  AlarmMode_t Mode;
public:
  AlarmClass();
  void init(); // TJS.
  void set_allocated(bool val); // TJS:
  void set_enabled(bool val);   // TJS:
  void set_oneshot(bool val);  // TJS:
  void set_alarm(bool val);    // TJS:
  bool get_allocated();         // TJS:
  bool get_enabled();           // TJS:
  bool get_oneshot();          // TJS:
  bool get_alarm();            // TJS:
  OnTick_t onTickHandler;  
  void updateNextTrigger();
  /* TJS Interpretation of value:
   * value holds time to next trigger:
   * if value is larger than a week, it is an absolute time in seconds past epoch
   * if it is less than a day, it is repeat time in seconds past midnight
   * if it is less than a week, it is repeat time in seconds past midnight
   * otherwise is it not valid.
   */
  time_t value;
  time_t nextTrigger; //TJS: holds next trigger time in absolute time (seconds from epoch).
};

// class containing the collection of alarms
class TimeAlarmsClass
{
 private:
  time_t nextTrigger; // TJS:  Next trigger time accross all Alarm[]
  uint8_t isServicing;
  AlarmID_t create( time_t value, OnTick_t onTickHandler, uint8_t isAlarm, uint8_t isOneShot, uint8_t isEnabled=true);
  
  void findNextTrigger(); // TJS: Find and set the time of the next alarm to be triggered.
  AlarmClass Alarm[dtNBR_ALARMS];
  
 public:
  void serviceAlarms();// TJS: made public.  This is the method I wish to use.
  TimeAlarmsClass();
  // functions to create alarms and timers
  AlarmID_t alarmRepeat(time_t value, OnTick_t onTickHandler);                    // trigger daily at given time of day
  AlarmID_t alarmRepeat(const int H,  const int M,  const int S, OnTick_t onTickHandler); // as above, with hms arguments
  AlarmID_t alarmRepeat(const timeDayOfWeek_t DOW, const int H,  const int M,  const int S, OnTick_t onTickHandler); // as above, with day of week 
 
  AlarmID_t alarmOnce(time_t value, OnTick_t onTickHandler);                     // trigger once at given time of day
  AlarmID_t alarmOnce( const int H,  const int M,  const int S, OnTick_t onTickHandler);  // as above, with hms arguments
  AlarmID_t alarmOnce(const timeDayOfWeek_t DOW, const int H,  const int M,  const int S, OnTick_t onTickHandler); // as above, with day of week 
  
  AlarmID_t timerOnce(time_t value, OnTick_t onTickHandler);   // trigger once after the given number of seconds 
  AlarmID_t timerOnce(const int H,  const int M,  const int S, OnTick_t onTickHandler);   // As above with HMS arguments
  
  AlarmID_t timerRepeat(time_t value, OnTick_t onTickHandler); // trigger after the given number of seconds continuously
  AlarmID_t timerRepeat(const int H,  const int M,  const int S, OnTick_t onTickHandler);   // As above with HMS arguments
  
  void delay(unsigned long ms);
   
  // utility methods
  uint8_t getDigitsNow( dtUnits_t Units);         // returns the current digit value for the given time unit
  void waitForDigits( uint8_t Digits, dtUnits_t Units);  
  void waitForRollover(dtUnits_t Units);
 
  // low level methods
  void enable(AlarmID_t ID);
  void free(AlarmID_t ID);                   // TJS:
  void disable(AlarmID_t ID);
  void write(AlarmID_t ID, time_t value);    // write the value (and enable) the alarm with the given ID
  time_t read(AlarmID_t ID);                 // return the value for the given timer 
};

extern TimeAlarmsClass Alarm;  // make an instance for the user

/*==============================================================================
 * MACROS
 *============================================================================*/

/* public */
#define waitUntilThisSecond(_val_) waitForDigits( _val_, dtSecond)
#define waitUntilThisMinute(_val_) waitForDigits( _val_, dtMinute)
#define waitUntilThisHour(_val_)   waitForDigits( _val_, dtHour)
#define waitUntilThisDay(_val_)    waitForDigits( _val_, dtDay)
#define waitMinuteRollover() waitForRollover(dtSecond)
#define waitHourRollover()   waitForRollover(dtMinute)
#define waitDayRollover()    waitForRollover(dtHour)

#define AlarmHMS(_hr_, _min_, _sec_) (_hr_ * SECS_PER_HOUR + _min_ * SECS_PER_MIN + _sec_)

#endif /* TimeAlarms_h */

