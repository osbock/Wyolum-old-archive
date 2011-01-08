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

#define IS_ONESHOT  true
#define IS_REPEAT   false 
#define IS_ALARM    true
#define IS_TIMER    false 

//**************************************************************
//* Alarm Class Constructor

AlarmClass::AlarmClass()
{
  Mode.isAlarm =  Mode.isEnabled = Mode.isOneShot = 0;
  value = MAX_TIME_T;
  nextTrigger = 0;
  onTickHandler = NULL;  // prevent a callback until this pointer is explicitly set 
}

//**************************************************************
//* Private Methods

void AlarmClass::updateNextTrigger()
{
  if( (value != MAX_TIME_T) && Mode.isEnabled )
  {
    time_t time = now();
    if(Mode.isAlarm && nextTrigger <= time)   // update alarm if next trigger has passed
    {
      if( value > SECS_PER_WEEK ) { // is the value a specific data and time in the future 
        nextTrigger = value;  // yes, trigger on this value // TJS: treat as seconds past epoch
      }
      else if ( value <= SECS_PER_DAY) {
        if( value + previousMidnight(now()) <= time)  // TJS: TODO: trade "now()" for "time"
	  { // TJS: treat as seconds past midnight
	    nextTrigger = value + nextMidnight(time); // if time has passed then set for tomorrow 
	  }
	else
	  {
	    nextTrigger = value + previousMidnight(time);  // set the date to today and add the time given in value	
	  }
      }
      else if ( value <= SECS_PER_WEEK) {
        nextTrigger = value + previousMidnight(time); // set the date to today and add the time given in value
      }
      else {
        Mode.isEnabled = false; // values more than a year but less than today have expired so the alarm is disabled 
      }
    }
    if(Mode.isAlarm == false){
      // its a timer
      nextTrigger = time + value;  // add the value to previous time (this ensures delay always at least Value seconds)
    }
  }
  else {
    Mode.isEnabled = false;  // Disable if the value is 0
  }
}

//**************************************************************
//* Time Alarms Public Methods

TimeAlarmsClass::TimeAlarmsClass()
{
  isServicing = false;
  for(uint8_t id = 0; id < dtNBR_ALARMS; id++)
     Alarm[id].Mode.isAllocated = false;  // ensure  all Alarms are avialable for allocation  
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
     return create( value, onTickHandler, IS_ALARM, IS_REPEAT );
}

AlarmID_t TimeAlarmsClass::alarmRepeat(const int H,  const int M,  const int S, OnTick_t onTickHandler){ // as above with HMS arguments
     return create( AlarmHMS(H,M,S), onTickHandler, IS_ALARM, IS_REPEAT );
}

AlarmID_t TimeAlarmsClass::alarmRepeat(const timeDayOfWeek_t DOW, const int H,  const int M,  const int S, OnTick_t onTickHandler){  // as above, with day of week 
   unsigned long dayOffset =  ( 7 + DOW - dayOfWeek(now())) %7;
   return create( (dayOffset * SECS_PER_DAY) + AlarmHMS(H,M,S), onTickHandler, IS_ALARM, IS_REPEAT );      
}

AlarmID_t TimeAlarmsClass::timerOnce(time_t value, OnTick_t onTickHandler){   // trigger once after the given number of seconds 
     return create( value, onTickHandler, IS_TIMER, IS_ONESHOT );
}

AlarmID_t TimeAlarmsClass::timerOnce(const int H,  const int M,  const int S, OnTick_t onTickHandler){   // As above with HMS arguments
  return create( AlarmHMS(H,M,S), onTickHandler, IS_TIMER, IS_ONESHOT );
}
  
AlarmID_t TimeAlarmsClass::timerRepeat(time_t value, OnTick_t onTickHandler){ // trigger after the given number of seconds continuously
     return create( value, onTickHandler, IS_TIMER, IS_REPEAT);
}

AlarmID_t TimeAlarmsClass::timerRepeat(const int H,  const int M,  const int S, OnTick_t onTickHandler){ // trigger after the given number of seconds continuously
     return create( AlarmHMS(H,M,S), onTickHandler, IS_TIMER, IS_REPEAT);
}

void TimeAlarmsClass::enable(AlarmID_t ID)
{
  if(ID < dtNBR_ALARMS && Alarm[ID].Mode.isAllocated){
    Alarm[ID].updateNextTrigger(); // trigger is updated whenever  this is called, even if already enabled

    // only enable if value is non zero and a tick handler has been set
    if ((Alarm[ID].value != 0) && (Alarm[ID].onTickHandler != 0)){
      Alarm[ID].Mode.isEnabled =  true;
    }
    else{
      Alarm[ID].Mode.isEnabled = false;
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
    if(Alarm[i].Mode.isEnabled && (Alarm[i].onTickHandler != NULL)){
      if(Alarm[i].nextTrigger <= nextTrigger){
	// TJS: Found the new next trigger!
	nextTrigger = Alarm[i].nextTrigger;
      }
    }
  }
}
void TimeAlarmsClass::disable(AlarmID_t ID)
{
  time_t new_next_trigger = MAX_TIME_T;
  if(ID < dtNBR_ALARMS && Alarm[ID].Mode.isAllocated){
    Alarm[ID].Mode.isEnabled = false;
    if(Alarm[ID].nextTrigger == nextTrigger){
      //TJS: find new nextTrigger!
      findNextTrigger();
    }
  }
  
}

// write the given value to the given alarm
void TimeAlarmsClass::write(AlarmID_t ID, time_t value)
{
  if(ID < dtNBR_ALARMS && Alarm[ID].Mode.isAllocated){
    Alarm[ID].value = value;
    enable(ID); // TJS: Enable will check for nextTrigger
  }
}

// return the value for the given alarm
time_t TimeAlarmsClass::read(AlarmID_t ID)
{
  if(ID < dtNBR_ALARMS && Alarm[ID].Mode.isAllocated)
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
    if(now() >= nextTrigger){ 
      // now alarm ALL alarms that need to be triggered
      for(uint8_t i = 0; i < dtNBR_ALARMS; i++)
	{
	  if( Alarm[i].Mode.isEnabled && (now() >= Alarm[i].nextTrigger)  )
	    {
	      OnTick_t TickHandler = Alarm[i].onTickHandler;
	      if(Alarm[i].Mode.isOneShot)
		Alarm[i].Mode.isEnabled = Alarm[i].Mode.isAllocated = false;  // free the ID if mode is OnShot		
	      else   
		Alarm[i].updateNextTrigger();
	      if( TickHandler != NULL) {        
		(*TickHandler)();     // call the handler  
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
//                         create(        value,          onTickHandler,       IS_ALARM,        IS_REPEAT );
AlarmID_t TimeAlarmsClass::create( time_t value, OnTick_t onTickHandler,boolean isAlarm, boolean isOneShot, boolean isEnabled ){
  for(uint8_t id = 0; id < dtNBR_ALARMS; id++)
  {
    if(Alarm[id].Mode.isAllocated == false)
    {
      // here if there is an Alarm id is available
      Alarm[id].Mode.isAllocated = true;
      Alarm[id].onTickHandler = onTickHandler;
      Alarm[id].Mode.isAlarm = isAlarm;
      Alarm[id].Mode.isOneShot = isOneShot;
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

