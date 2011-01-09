/*
  TimeAlarms.cpp - Arduino Time alarms for use with Time library   
  Copyright (c) 2010 Michael Margolis. 
                2011 optimized by Justin Shaw wyojustin@gmail.com (TJS)
  
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

 */

extern "C" {
#include <string.h> // for memset
}

#include <WProgram.h>
#include "TimeAlarms.h"
#include "Time.h"

#define IS_ONESHOT  0
#define TIMER_REPEAT 1
#define    REPEAT_ANNUAL 1 << 0
#define    REPEAT_SUNDAY 1 << 1
#define    REPEAT_MONDAY 1 << 2
#define   REPEAT_TUESDAY 1 << 3
#define REPEAT_WEDNESDAY 1 << 4 
#define  REPEAT_THURSDAY 1 << 5
#define    REPEAT_FRIDAY 1 << 6
#define  REPEAT_SATURDAY 1 << 7 
#define REPEAT_DAILY 0b11111110
#define IS_ALARM    true
#define IS_TIMER    false 

//**************************************************************
//* Alarm Class Constructor

AlarmClass::AlarmClass()
{
  init(); // TJS:
}

/* public methods */
// TJS:
void AlarmClass::init()
{
  set_alarm(false);
  set_enabled(false);
  set_repeat(0);
  value = MAX_TIME_T;
  nextTrigger = 0;
  onTickHandler = NULL;  // prevent a callback until this pointer is explicitly set 
}
void AlarmClass::set_allocated(bool val){ // TJS:
  /*  true -> alarm memory canNOT be resued
   * false -> alarm memory can be resued
   */
    Mode.isAllocated = val;
}
void AlarmClass::set_enabled(bool val){   // TJS:
  /*  true -> alarm will trigger when time expires
   * false -> alarm will NOT trigger when time expires
   */
  Mode.isEnabled = val;
}
void AlarmClass::set_repeat(uint8_t val){  // TJS:
  /*  bit field repeat every...
   * 0 -- annnual event
   * 1 -- sunday
   * 2 -- monday
   * 3 -- tuesday
   * 4 -- wednesday
   * 5 -- thursday
   * 6 -- friday
   * 7 -- saturday
   *  false -> repeated alarm
   */
  Mode.repeat = val;
}
void AlarmClass::set_alarm(bool val){    // TJS:
  /*  true -> wall clock alarm
   * false -> count down timer
   */
  Mode.isAlarm = val;
}
bool AlarmClass::is_countdown(){          // TJS:
  return !get_alarm();
}
bool AlarmClass::is_tod(){                // TJS:
  return get_alarm() && value < SECS_PER_WEEK;
}
bool AlarmClass::is_annual(){             // TJS:
  return Mode.repeat && 1;
}
bool AlarmClass::is_oneshot(){            // TJS:
  return Mode.repeat == 0;
}
bool AlarmClass::is_repeated(){            // TJS:
  return Mode.repeat > 0;
}
bool AlarmClass::is_armed(){              // TJS:
  return ((value != MAX_TIME_T) && 
	  get_allocated() && 
	  get_enabled());
}
bool AlarmClass::get_allocated(){         // TJS:
  return Mode.isAllocated;
}
bool AlarmClass::get_enabled(){           // TJS:
  return Mode.isEnabled;
}
uint8_t AlarmClass::get_repeat(){         // TJS:
  return Mode.repeat;
}
bool AlarmClass::get_alarm(){             // TJS:
  return Mode.isAlarm;
}

//**************************************************************
//* Private Methods

void AlarmClass::updateNextTrigger()
{
  time_t time = now();
  if(is_armed() && nextTrigger <= time){
    if(is_countdown()){
      if(is_repeated()){
	nextTrigger = time + value;
      }
    }
    else if(is_tod()){ // time of day alarm, find next time of day when this time occurs
      nextTrigger = previousMidnight(time) + value;
      if(value <= elapsedSecsToday(time)){  // find next day of the week
	uint8_t dow = dayOfWeek(time) - dowSunday;
	uint8_t delta_days = 1;
	uint16_t two_weeks = ((Mode.repeat & ~1) >>1) | ((Mode.repeat & ~1) << 7);
	// m-f looks like this then 01111100111110
	for(; delta_days < 8; delta_days++){
	  if((two_weeks >> (dow + delta_days)) & 1){
	    break;
	  }
	}
	nextTrigger += SECS_PER_DAY * delta_days;
      }
    }
    else if(is_annual()){
      tmElements_t tm;
      tm.Year = year() + 1;
      tm.Month = month();
      tm.Day = day();
      tm.Hour = hour();
      tm.Minute = minute();
      tm.Second = second();
      nextTrigger = makeTime(tm);
    }
    else{              // absolote time
      nextTrigger = value;
    }
  }
  else{
  }
}

//**************************************************************
//* Time Alarms Public Methods

TimeAlarmsClass::TimeAlarmsClass()
{
  isServicing = false;
  for(uint8_t id = 0; id < dtNBR_ALARMS; id++)
    Alarm[id].set_allocated(false);  // ensure  all Alarms are avialable for allocation  
  nextTrigger = MAX_TIME_T;               // TJS: next tigger time in seconds past epoch (Feb 7, 2106 w/ 32 bit uint)
}

AlarmID_t TimeAlarmsClass::alarmOnce(time_t value, OnTick_t onTickHandler){   // trigger once at the given time of day
   return create( value, onTickHandler, IS_ALARM, IS_ONESHOT );
}

AlarmID_t TimeAlarmsClass::alarmOnce(const int H,  const int M,  const int S,OnTick_t onTickHandler){   // as above with HMS arguments
   return create( AlarmHMS(H,M,S), onTickHandler, IS_ALARM, IS_ONESHOT );
}
   
AlarmID_t TimeAlarmsClass::alarmOnce(const timeDayOfWeek_t DOW, const int H,  const int M,  const int S, OnTick_t onTickHandler){  // as above, with day of week 
   unsigned long dayOffset =  ( 7 + DOW - dayOfWeek(now())) %7;
   return create( (dayOffset * SECS_PER_DAY) + AlarmHMS(H,M,S), onTickHandler, IS_ALARM, IS_ONESHOT );   
}
   
AlarmID_t TimeAlarmsClass::alarmRepeat(time_t value, OnTick_t onTickHandler){ // trigger daily at the given time
     return create( value, onTickHandler, IS_ALARM, REPEAT_DAILY );
}

AlarmID_t TimeAlarmsClass::alarmRepeat(const int H,  const int M,  const int S, OnTick_t onTickHandler){ // as above with HMS arguments
     return create( AlarmHMS(H,M,S), onTickHandler, IS_ALARM, REPEAT_DAILY);
}

AlarmID_t TimeAlarmsClass::alarmRepeat(const timeDayOfWeek_t DOW, const int H,  const int M,  const int S, OnTick_t onTickHandler){  // as above, with day of week 
   unsigned long dayOffset =  ( 7 + DOW - dayOfWeek(now())) %7;
   return create( (dayOffset * SECS_PER_DAY) + AlarmHMS(H,M,S), onTickHandler, IS_ALARM, REPEAT_DAILY);      
}

AlarmID_t TimeAlarmsClass::timerOnce(time_t value, OnTick_t onTickHandler){   // trigger once after the given number of seconds 
     return create( value, onTickHandler, IS_TIMER, IS_ONESHOT );
}

AlarmID_t TimeAlarmsClass::timerOnce(const int H,  const int M,  const int S, OnTick_t onTickHandler){   // As above with HMS arguments
  return create( AlarmHMS(H,M,S), onTickHandler, IS_TIMER, IS_ONESHOT );
}
  
AlarmID_t TimeAlarmsClass::timerRepeat(time_t value, OnTick_t onTickHandler){ // trigger after the given number of seconds continuously
     return create( value, onTickHandler, IS_TIMER, TIMER_REPEAT);
}

AlarmID_t TimeAlarmsClass::timerRepeat(const int H,  const int M,  const int S, OnTick_t onTickHandler){ // trigger after the given number of seconds continuously
     return create( AlarmHMS(H,M,S), onTickHandler, IS_TIMER, TIMER_REPEAT);
}

void TimeAlarmsClass::enable(AlarmID_t ID)
{
  if(ID < dtNBR_ALARMS && Alarm[ID].get_allocated()){
    Alarm[ID].updateNextTrigger(); // trigger is updated whenever  this is called, even if already enabled

    // only enable if value is non zero and a tick handler has been set
    if ((Alarm[ID].value != 0) && (Alarm[ID].onTickHandler != 0)){
      Alarm[ID].set_enabled(true);
    }
    else{
      Alarm[ID].set_enabled(false);
    }
    findNextTrigger(); //TJS: since Alarm[ID].nextTrigger may have been updated we have to check of this.nextTrigger needs to be updated

  }
}

/*
 * TJS: update next trigger for all alarms and find minimum.
 */
void TimeAlarmsClass::findNextTrigger(){
  nextTrigger = MAX_TIME_T; // (Feb 7, 2106 w/ 32 bit uint)

  for(int i = 0; i < dtNBR_ALARMS; i++){
    if(Alarm[i].get_enabled() && (Alarm[i].onTickHandler != NULL)){
      if(Alarm[i].nextTrigger <= nextTrigger){
	// TJS: Found the new next trigger!
	nextTrigger = Alarm[i].nextTrigger;
      }
    }
  }
}
void TimeAlarmsClass::free(AlarmID_t ID)
{
  if(ID < dtNBR_ALARMS){
    Alarm[ID].init();
  }
}
void TimeAlarmsClass::disable(AlarmID_t ID)
{
  time_t new_next_trigger = MAX_TIME_T;
  if(ID < dtNBR_ALARMS && Alarm[ID].get_allocated()){
    Alarm[ID].set_enabled(false);
    if(Alarm[ID].nextTrigger == nextTrigger){
      //TJS: find new nextTrigger!
      findNextTrigger();
    }
  }
}

// write the given value to the given alarm
void TimeAlarmsClass::write(AlarmID_t ID, time_t value)
{
  if(ID < dtNBR_ALARMS && Alarm[ID].get_allocated()){
    Alarm[ID].value = value;
    enable(ID); // TJS: Enable will check for nextTrigger
  }
}

// return the value for the given alarm
time_t TimeAlarmsClass::read(AlarmID_t ID)
{
  if(ID < dtNBR_ALARMS && Alarm[ID].get_allocated())
    return Alarm[ID].value;
  else 	
    return 0l;  
}
 
// following functions are not Alarm ID specific.
void TimeAlarmsClass::delay(unsigned long ms)
{
  unsigned long start = millis();
  while( millis() - start  <= ms)
    serviceAlarms();
}
		
void TimeAlarmsClass::waitForDigits( uint8_t Digits, dtUnits_t Units)
{
  while(Digits != getDigitsNow(Units) )
  {
    serviceAlarms();
  }
}

void TimeAlarmsClass::waitForRollover( dtUnits_t Units)
{
  while(getDigitsNow(Units) == 0  ) // if its just rolled over than wait for another rollover	                            
    serviceAlarms();
  waitForDigits(0, Units);
}

uint8_t TimeAlarmsClass::getDigitsNow( dtUnits_t Units)
{
  time_t time = now();
  if(Units == dtSecond) return numberOfSeconds(time);
  if(Units == dtMinute) return numberOfMinutes(time); 
  if(Units == dtHour) return numberOfHours(time);
  if(Units == dtDay) return dayOfWeek(time);
  return 255;  // This should never happen 
}

//***********************************************************
//* Private Methods

void TimeAlarmsClass::serviceAlarms()
{
  if(! isServicing)
  {
    isServicing = true;
    /* TJS: Speed up servicing (now() called multiple times to save memory)    
     * Just check against next trigger
     */
    time_t time = now();
    if(time >= nextTrigger){ 
      // now alarm ALL alarms that need to be triggered
      for(uint8_t i = 0; i < dtNBR_ALARMS; i++)
	{
	  if( Alarm[i].get_enabled() && (time >= Alarm[i].nextTrigger)  )
	    {
	      if(Alarm[i].is_oneshot()){
		free(i);  // free the ID if mode is OnShot		
	      }
	      else{
		Alarm[i].updateNextTrigger();
	      }
	      if(Alarm[i].onTickHandler != NULL) {        
		Alarm[i].onTickHandler();
	      }
	    }
	}
      //TJS: Find next trigger!
      findNextTrigger();
    }
    isServicing = false;
  }
}

// returns true if has been registerd ok
//                         create(       value,  onTickHandler,  IS_ALARM,  IS_REPEAT,   IS_ENABLED);
AlarmID_t TimeAlarmsClass::create(time_t value, 
				  OnTick_t onTickHandler,
				  boolean isAlarm, 
				  uint8_t repeat, 
				  boolean isEnabled ){
  for(uint8_t id = 0; id < dtNBR_ALARMS; id++)
  {
    if(Alarm[id].get_allocated() == false)
    {
      // here if there is an Alarm id is available
      Alarm[id].set_allocated(true);
      Alarm[id].onTickHandler = onTickHandler;
      Alarm[id].set_alarm(isAlarm);
      Alarm[id].set_repeat(repeat);
      Alarm[id].value = value;
      isEnabled ?  enable(id) : disable(id);   
      Alarm[id].updateNextTrigger();
      findNextTrigger(); // TJS: find the next alarm that needs to be triggeredxo
      return id;
    }  
  }
  return dtINVALID_ALARM_ID; // no IDs available // TJS: multiple return statements! ** hurumph! **
}

// make one instance for the user to use
TimeAlarmsClass Alarm = TimeAlarmsClass() ;

