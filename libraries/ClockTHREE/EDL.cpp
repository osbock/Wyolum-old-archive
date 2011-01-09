#include <inttypes.h>
#include "EDL.h"
#include "EEPROM.h"

const uint16_t MAX_EEPROM_ADDR = 1023;

/* 
 * Copy DID to data to dest.  
 * dest -- location to copy DID record.  It must have enough space allocated to contain entire record.
 * len_p -- ouput, if output is true, the value pointed to by this pointer will contian the length for this did
 */
bool did_read(uint8_t did, char *dest, uint8_t *len_p){
  int16_t addr;
  bool status = false;

  if(get_did_addr(did, &addr, len_p)){
    for(uint8_t i = 0; i < *len_p; i++){
      dest[i] = EEPROM.read(addr + i);
    }
    status = true;
  }
  return status;
}

/* 
 * Write a valid DID stored in data.
 * return true if successful, false otherwise.
 */
bool did_write(char* data){
  uint8_t n = EEPROM.read(MAX_EEPROM_ADDR);
  int16_t addr = 0;
  uint8_t did = data[0];
  uint8_t len = data[1];
  bool status = false;
  
  int16_t tmp_addr;
  uint8_t tmp_l;
  if(!get_did_addr(did, &tmp_addr, &tmp_l)){
    if(did_next_addr(&addr)){
      if(addr + len < MAX_EEPROM_ADDR - 1){
	for(uint8_t i = 0; i < len; i++){
	  EEPROM.write(addr + i, data[i]);
	}
	EEPROM.write(MAX_EEPROM_ADDR, n + 1);
	status = true;
      }
    }
  }
  return status;
}

/*
 * Get next available DID address.  
 * Return true if space any space remains, otherwise false
 */
bool did_next_addr(int16_t *addr_p){
  uint8_t n = EEPROM.read(MAX_EEPROM_ADDR);
  bool status = false;
  *addr_p = 0;

  // go to end of the line of DIDs
  for(uint8_t i = 0; 
      i < n && *addr_p < MAX_EEPROM_ADDR - 2; 
      i++){
    *addr_p += EEPROM.read(*addr_p + 1);
  }
  if(*addr_p < MAX_EEPROM_ADDR - 2){
    status = true;
  }
  else{
    // strcpy(serial_msg, "mem");
  }
  return status;
}

/*
 * delete data store under identifier did
 * return true if successful, false otherwise
 */
bool did_delete(uint8_t did){
  int16_t addr, next_addr;
  uint8_t len;
  uint8_t n = EEPROM.read(MAX_EEPROM_ADDR);
  bool status = false;
  if(get_did_addr(did, &addr, &len)){
    status = true;
    if(n == 1){ // only one --> delete from address 0
      len = EEPROM.read(1);
      for(uint8_t i = 0; i < len; i++){
	EEPROM.write(i, 0);
      }
      EEPROM.write(MAX_EEPROM_ADDR, 0);
    }
    else{
      if(did_next_addr(&next_addr)){
	for(int i = addr; i < next_addr - 1 - len; i++){
	  EEPROM.write(i, EEPROM.read(i + len));
	}
      }
      if(n > 0){
	EEPROM.write(MAX_EEPROM_ADDR, n - 1);
      }
    }
  }
  return status;
}

/*
 * Get the address of DID identified by did.
 * did -- data id
 * addr_p -- output, if output is true, the value pointed to by this pointer will contian the address for this did
 * len_p -- output, if output is true, the value pointed to by this pointer will contian the length for this did
 */
bool get_did_addr(uint8_t did, int16_t* addr_p, uint8_t *len_p){
  bool status = false;
  uint8_t id;

  *addr_p = 0;
  id = EEPROM.read(*addr_p);
  uint8_t n = EEPROM.read(MAX_EEPROM_ADDR);
  uint8_t i = 0;
  while((*addr_p < MAX_EEPROM_ADDR - 2) && 
	(did != id) && 
	(i++ < n)){
    *len_p = EEPROM.read(*addr_p + 1);
    *addr_p += *len_p;
    id = EEPROM.read(*addr_p);
  }
  if(id == did){
    // make sure it is not too long
    if(*addr_p < MAX_EEPROM_ADDR - 2){
      *len_p = EEPROM.read(*addr_p + 1);
      status = true;
    }
  }
  else{
  }
  return status;
}

