#include "Time.h"
#include "TimeAlarms.h"

void setup()
{
  Serial.begin(57600);
  setTime(8,29,0,10,1,11); // set time to 8:29:00am Jan 1 2010
  // create the alarms 
  AlarmId mal, dont_alarm;
  /*
  Alarm.free(mal); // free before allocated ok?
  dont_alarm = Alarm.alarmRepeat(8,29,12, DontAlarm);  // 08:29:12  every da
  Alarm.free(dont_alarm);
  
  mal = Alarm.alarmRepeat(8,29,12, MorningAlarm);  // 08:29:12  every day
  Alarm.alarmRepeat(8,29,17,EveningAlarm);  // 08:29:17 every day 
 
  Alarm.timerRepeat(7, Repeats7);            // timer for every 1 seconds    
  Alarm.timerRepeat(3, Repeats3);            // timer for every 5 seconds    
  Alarm.timerOnce(2, OnceOnly);                 // called once after 2 seconds

//create(      value,  onTickHandler,  IS_ALARM,  COUNTDOWN, IS_REPEAT,   arg, IS_ENABLED=true);  
  // Annual event 10 secs from now
  Alarm.create(now() + 10, fire_alarm, true, 0, REPEAT_ANNUAL, 10);
  
  // Weekday event 25 secs from now
  Alarm.create(now() + 25, fire_alarm, true, 0, REPEAT_WEEKDAYS, 25);
  */

  // ONCE 30 secs from now

  //         create(      value,  onTickHandler,  IS_ALARM,  COUNTDOWN, IS_REPEAT,   arg, IS_ENABLED=true);  
  AlarmID_t id = Alarm.create(now() + 35, fire_alarm, true, 0, REPEAT_5MIN, 32);
  Serial.println(Alarm.Alarm[id].is_5min_repeat(), DEC);
  Serial.println(Alarm.Alarm[id].is_daily(), DEC);
  Serial.println(Alarm.Alarm[id].is_annual(), DEC);
  Serial.println(Alarm.Alarm[id].is_armed(), DEC);
  Serial.println(Alarm.Alarm[id].is_5min_repeat(), DEC);
  
  // ONCE 17 Secs from now
  /*Alarm.create(now() + 17, fire_alarm, true, 0, NO_REPEAT, 17);*/
}

void  loop(){  
  Serial.println(Alarm.nextTrigger - now());
  // digitalClockDisplay();
  Alarm.serviceAlarms();
  delay(1000);  // wait one second 
}

// functions to be called when an alarm triggers:
void DontAlarm(uint8_t arg){
  Serial.println("Oops, should not have alarmed!");
}
void fire_alarm(uint8_t arg){
  Serial.print("Alarm fired with arg");
  Serial.println(arg, DEC);
}

void MorningAlarm(uint8_t arg){
  if(hour() != 8 || minute() != 29 || second() != 12){
    Serial.println("Morning alarm false triggered");
  }
  else{
    Serial.println("Morning Alarm: - turn lights off");    
  }
}

void EveningAlarm(uint8_t arg){
  if(hour() != 8 || minute() != 29 || second() != 17){
    Serial.println("Evening alarm false triggered");
  }
  else{
    Serial.println("Evening Alarm: - turn lights on");           
  }
}

void Repeats3(uint8_t arg){
  if(millis() < 3000){
    Serial.println("3 second timer alarm pre triggered");
  }
  else{
    Serial.println("3 second timer");         
  }
}

void Repeats7(uint8_t arg){
  if(millis() < 1000){
    Serial.println("7 second timer alarm pre triggered");
  }
  else{
    Serial.println("7 second timer");         
  }
}

void OnceOnly(uint8_t arg){
  if(millis() < 2000){
    Serial.println("OnceOnly alarm pre triggered");
  }
  else{
    Serial.println("This timer only triggers once"); 
  }
}

void digitalClockDisplay()
{
  // digital clock display of the time
  Serial.print(hour());
  printDigits(minute());
  printDigits(second());
  Serial.println(); 
}

void printDigits(int digits)
{
  Serial.print(":");
  if(digits < 10)
    Serial.print('0');
  Serial.print(digits);
}

