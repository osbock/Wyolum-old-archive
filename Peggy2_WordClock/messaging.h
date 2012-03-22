typedef void (* CallBackPtr)(); // this is a typedef for callback funtions


// Serial Messaging
struct MsgDef{
  uint8_t id;     // message type id

  /* n_byte holde the number of bytes or if n_byte == VAR_LENGTH, message type is variable length 
   * with message length in second byte of message. */
  uint8_t n_byte; 

  /* Function to call when this message type is recieved.
   * message content (header byte removed) will available to the call back function through
   * the global variabe "char serial_msg[]".
   */
  CallBackPtr cb; 
};


const uint8_t MAX_MSG_LEN = 100; // official: 100
const uint8_t SYNC_BYTE = 254;   // 0xEF; (does not seem to work!)
const uint8_t VAR_LENGTH = 255;  // 0xFF;
const uint8_t N_MSG_TYPE = 6;
char serial_msg[MAX_MSG_LEN];

time_t Serial_to_Time(char *in){
  return *((uint32_t *)in);
}
// write 4 bytes of in into char buffer out.
void Time_to_Serial(time_t in, char *out){
  time_t *out_p = (time_t *)out;
  *out_p = in;
}

void do_nothing(){};
void Serial_time_set();
void scroll_data(){ // TBD
}
void mode_interrupt(){ // TBD
}
void send_time();

void pong(){
}

// Message types
const MsgDef  NOT_USED_MSG = {0x00, 1, do_nothing};
const MsgDef  ABS_TIME_REQ = {0x01, 1, send_time};
const MsgDef  ABS_TIME_SET = {0x02, 5, Serial_time_set};
const MsgDef   SCROLL_DATA = {0x07, 2, scroll_data};
const MsgDef  TRIGGER_MODE = {0x0C, 1, mode_interrupt};
const MsgDef          PING = {0x12, MAX_MSG_LEN, pong}; // can make variable length.

// array to loop over when new messages arrive.
const MsgDef *MSG_DEFS[N_MSG_TYPE] = {&NOT_USED_MSG,
				      &ABS_TIME_REQ,
				      &ABS_TIME_SET,
				      &SCROLL_DATA,
				      &TRIGGER_MODE,
				      &PING};
// store serial data into serial_msg staring from first byte AFTER MID
boolean Serial_get_msg(uint8_t n_byte) {
  /*
    n_byte = message length including 1 byte MID
    store message in serial_msg
    
    return true if n_bytes arrived, false otherwise
  */
  uint16_t i = 0;
  unsigned long start_time = millis();

  uint8_t val, next;
  boolean out;

  // digitalWrite(DBG, HIGH);
  while((i < n_byte - 1)){/* && 
			     ((millis() - start_time) < SERIAL_TIMEOUT_MS)){*/
    if(Serial.available()){
      val = Serial.read();
      serial_msg[i++] = val;
    }
   }
   if(i == n_byte - 1){
     digitalWrite(DBG, LOW);
     out = true;
   }
   else{
    digitalWrite(DBG, HIGH);
    out = false;
  }
  return out;
}
void Serial_loop(void) {
  uint8_t val;
  boolean resync_flag = true;
  if(Serial.available()){
    val = Serial.read();
    // two_digits(val);
    // find msg type
    for(uint8_t msg_i = 0; msg_i < N_MSG_TYPE; msg_i++){
      if(MSG_DEFS[msg_i]->id == val){
	if(Serial_get_msg(MSG_DEFS[msg_i]->n_byte)){
	  /*
	   * Entire payload (n_byte - 1) bytes 
	   * is stored in serial_msg: callback time.
	   */

	  MSG_DEFS[msg_i]->cb();
	  //two_digits(val);
	  //c3.refresh(10000);
	}
	resync_flag = false;
	break;
	// return;
      }
    }
  }
}
bool set_toggle = false;
void Serial_time_set(){
  setRTC(Serial_to_Time(serial_msg));
  set_toggle = !set_toggle;
  digitalWrite(3, set_toggle);
}
void send_time(){
  char ser_data[4];
  Serial.write(ABS_TIME_SET.id);
  Time_to_Serial(getTime(), ser_data);
  for(uint8_t i = 0; i < 4; i++){
    Serial.write(ser_data[i]);
  }
}
