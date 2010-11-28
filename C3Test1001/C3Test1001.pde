/*
  Color Test.  Go through colors in this order:
OFF (HOLD)
RED
GREEN
BLUE
REDGREEN
REDBLUE
GREENBLUE
WHITE

Then repeat.
 */
const int N_ROW = 12;
const int N_COL = 16;
const int N_COLOR = 8;
const int DBG = 12;
const int COL_DRIVER_ENABLE = 17;

// bitmasks for the colors
const unsigned long RGBW_MASKS[] = {0b00001001001001001001001001001001, // RED
				    0b00010010010010010010010010010010, // GREEN
				    0b11100100100100100100100100100100, // BLUE
				    0b00111111111111111111111111111111};// WHITE

const unsigned long       OFF = 0;
const unsigned long       RED = RGBW_MASKS[0];
const unsigned long     GREEN = RGBW_MASKS[1];
const unsigned long      BLUE = RGBW_MASKS[2];
const unsigned long  REDGREEN = RGBW_MASKS[0] | RGBW_MASKS[1];
const unsigned long   REDBLUE = RGBW_MASKS[0] | RGBW_MASKS[2];
const unsigned long GREENBLUE = RGBW_MASKS[1] | RGBW_MASKS[2];
const unsigned long     WHITE = RGBW_MASKS[3];

const unsigned long COLORS[N_COLOR] = {OFF, 
				       RED, 
				       GREEN, 
				       BLUE, 
				       REDGREEN, 
				       REDBLUE, 
				       GREENBLUE, 
				       WHITE};
uint32_t* buffer;

// Modified from Peggy2.cpp
unsigned char SPI_TX(char cData)
{
  SPDR = cData;
  //Wait for transmission complete:
  while (!(SPSR & _BV(SPIF))) ;
  return SPDR;
} 

// Modified from Peggy2.cpp
void RefreshAll(){
  unsigned char col_j;
  
  union mix_t {
    unsigned long atemp; 
    unsigned char c[4];
  } mix;
  
  col_j = 0;
  while (col_j < N_COL){
    PORTD = col_j;
    mix.atemp = buffer[col_j];
    SPI_TX(mix.c[3]);
    SPI_TX(mix.c[2]);
    SPI_TX(mix.c[1]);
    
    SPI_TX(mix.c[0]); 
    PORTB |= 2U;    //Latch Pulse 
    PORTB &= 253U;
    //delay(100);
    col_j++;
  }
}

void setup(){
  pinMode(8, OUTPUT);
  pinMode(DBG, OUTPUT);
  pinMode(COL_DRIVER_ENABLE, OUTPUT);
  
  digitalWrite(COL_DRIVER_ENABLE, LOW);

  buffer = (uint32_t*)calloc(N_COL, sizeof(uint32_t));
  memset(buffer, WHITE, N_COL*sizeof(uint32_t)); // ALL ON: WHITE

  PORTD = 0U;
  DDRD = 255U;
  
  ////SET MOSI, SCK Output, all other SPI as input: 
  DDRB |= _BV(5) | _BV(3) | _BV(2) | _BV(1);
  
  //ENABLE SPI, MASTER, CLOCK RATE fck/4:  
  SPCR =  _BV(SPE) |  _BV(MSTR) ;
  
  //  Flush SPI LED drivers::
  SPI_TX(0);
  SPI_TX(0);
  SPI_TX(0);
  SPI_TX(0);

  PORTB |= 2;    //Latch Pulse 
  PORTB &= 253;  
}

unsigned long count =4000;
boolean dbg = true;
void loop(){
  int color_i = 0;
  int i;

  if(count % 4000 == 0){
    color_i = (count / 4000) % N_COLOR;
    if(color_i == 1){
      delay(1000);
    }
    for(i = 0; i < N_COL; i++){
      buffer[i] = COLORS[color_i];
    }
    if(dbg){
      // PORTC |= 0b00001000; // Disable col driver
      dbg = false;
    }
    else{
      // PORTC &= 0b11110111; // Enable col driver
      dbg = true;
    }
    digitalWrite(DBG, dbg);
    // digitalWrite(COL_DRIVER_ENABLE, dbg);

  }    
  RefreshAll();
  count++;
}
