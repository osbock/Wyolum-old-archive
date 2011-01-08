#include "Time.h"
#include "TimeAlarms.h"

void setup()
{
  Serial.begin(57600);
  setTime(8,29,0,1,1,10); // set time to 8:29:00am Jan 1 2010
  // create the alarms 
  AlarmId mal, dont_alarm;

  Alarm.free(mal); // free before allocated ok?

  mal = Alarm.alarmRepeat(8,29,12, MorningAlarm);  // 08:29:12  every day

  dont_alarm = Alarm.alarmRepeat(8,29,12, DontAlarm);  // 08:29:12  every da
  Alarm.free(dont_alarm);

  Alarm.alarmRepeat(8,29,17,EveningAlarm);  // 08:29:17 every day 
 
  Alarm.timerRepeat(7, Repeats7);            // timer for every 1 seconds    
  Alarm.timerRepeat(3, Repeats3);            // timer for every 5 seconds    
  Alarm.timerOnce(10, OnceOnly);             // called once after 10 seconds 
}

void  loop(){  
  // Serial.println(millis(), DEC);
  digitalClockDisplay();
  Alarm.serviceAlarms(); // wait one second 
  Alarm.delay(1000);
}

// functions to be called when an alarm triggers:
void DontAlarm(){
  Serial.println("Oops, should not have alarmed!");
}
void MorningAlarm(){
  if(hour() != 8 || minute() != 29 || second() != 12){
    Serial.println("Morning alarm false triggered");
  }
  else{
    Serial.println("Morning Alarm: - turn lights off");    
  }
}

void EveningAlarm(){
  if(hour() != 8 || minute() != 29 || second() != 17){
    Serial.println("Evening alarm false triggered");
  }
  else{
    Serial.println("Evening Alarm: - turn lights on");           
  }
}

void Repeats3(){
  if(millis() < 3000){
    Serial.println("3 second timer alarm pre triggered");
  }
  else{
    Serial.println("3 second timer");         
  }
}

void Repeats7(){
  if(millis() < 1000){
    Serial.println("7 second timer alarm pre triggered");
  }
  else{
    Serial.println("7 second timer");         
  }
}

void OnceOnly(){
  if(millis() < 10000){
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

