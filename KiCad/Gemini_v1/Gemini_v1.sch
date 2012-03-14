EESchema Schematic File Version 2  date 3/14/2012 5:50:38 PM
LIBS:Gemini_v1
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:Gemini_v1-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 5
Title ""
Date "14 mar 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 850  3400 1050 600 
U 4F608CE1
F0 "Gemini_Mech" 60
F1 "Gemini_Mech.sch" 60
$EndSheet
$Sheet
S 850  2050 1050 975 
U 4E1FEA4E
F0 "Gemini_rtc" 60
F1 "Gemini_rtc.sch" 60
F2 "GND" I R 1900 2550 60 
F3 "SDA" I R 1900 2450 60 
F4 "SCL" I R 1900 2350 60 
F5 "5V0" I R 1900 2250 60 
F6 "RST" I R 1900 2650 60 
F7 "SQW" I R 1900 2750 60 
F8 "32k" I R 1900 2850 60 
F9 "BAT" I R 1900 2950 60 
$EndSheet
$Sheet
S 850  1500 1050 300 
U 4F60847D
F0 "Gemini_Target" 60
F1 "Gemini_Target.sch" 60
$EndSheet
$Sheet
S 850  1000 1050 300 
U 4F608446
F0 "Gemini_Host" 60
F1 "Gemini_Host.sch" 60
$EndSheet
$Comp
L CONN_6 P?
U 1 1 4F5F0B5C
P 3200 6950
F 0 "P?" V 3150 6950 60  0000 C CNN
F 1 "FTDI" V 3250 6950 60  0000 C CNN
F 2 "PIN_ARRAY-6X1" H 3200 6950 60  0001 C CNN
	1    3200 6950
	1    0    0    1   
$EndComp
$Comp
L C C?
U 1 1 4F5F0B5B
P 2550 6650
F 0 "C?" V 2450 6775 50  0000 L CNN
F 1 "100n" V 2450 6475 50  0000 L CNN
F 2 "c_0805" H 2550 6650 60  0001 C CNN
	1    2550 6650
	0    1    1    0   
$EndComp
Text Label 1950 6700 0    60   ~ 0
RESET
Text Label 1950 6900 0    60   ~ 0
RXD
Text Label 1950 6800 0    60   ~ 0
TXD
Text Label 1950 7200 0    60   ~ 0
GND
$Comp
L ISP P?
U 1 1 4F5F0B59
P 1450 6950
F 0 "P?" V 1400 6950 60  0000 C CNN
F 1 "ISP" V 1500 6950 60  0000 C CNN
F 2 "ISP" H 1450 6950 60  0001 C CNN
	1    1450 6950
	1    0    0    -1  
$EndComp
Text Label 750  7100 0    60   ~ 0
RESET
Text Label 750  7000 0    60   ~ 0
MOSI
Text Label 750  6900 0    60   ~ 0
SCK
Text Label 750  6800 0    60   ~ 0
5V0
Text Label 750  6700 0    60   ~ 0
MISO
$Comp
L LED D?
U 1 1 4F5F0B4C
P 4900 7150
F 0 "D?" H 4900 7250 50  0000 C CNN
F 1 "LED" H 4900 7050 50  0000 C CNN
F 2 "d_0805" H 4900 7150 60  0001 C CNN
	1    4900 7150
	0    1    1    0   
$EndComp
$Comp
L LED D?
U 1 1 4F5F0B4B
P 5200 7150
F 0 "D?" H 5200 7250 50  0000 C CNN
F 1 "LED" H 5200 7050 50  0000 C CNN
F 2 "d_0805" H 5200 7150 60  0001 C CNN
	1    5200 7150
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 4F5F0B4A
P 4900 6650
F 0 "R?" V 4980 6650 50  0000 C CNN
F 1 "470E" V 4900 6650 50  0000 C CNN
F 2 "r_0805" H 4900 6650 60  0001 C CNN
	1    4900 6650
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 4F5F0B49
P 5200 6650
F 0 "R?" V 5280 6650 50  0000 C CNN
F 1 "470E" V 5200 6650 50  0000 C CNN
F 2 "r_0805" H 5200 6650 60  0001 C CNN
	1    5200 6650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 4F5F0B48
P 5050 7450
F 0 "#PWR?" H 5050 7450 30  0001 C CNN
F 1 "GND" H 5050 7380 30  0001 C CNN
	1    5050 7450
	1    0    0    -1  
$EndComp
Text Label 5200 6350 0    60   ~ 0
LED2
Text Label 4900 6350 0    60   ~ 0
LED1
Text Label 1950 7000 0    60   ~ 0
5V0
Text Label 5750 6500 0    60   ~ 0
5V0
Text Label 5750 6300 0    60   ~ 0
RESET
Text Label 750  7200 0    60   ~ 0
GND
Text Label 5750 6600 0    60   ~ 0
GND
Text Notes 6500 6200 2    60   Italic 12
BUCKLER Interface
Text Notes 575  6200 0    60   Italic 12
ISP/PROG Header
Text Notes 1800 6200 0    60   Italic 12
FTDI Header
Text Notes 4625 6200 0    60   Italic 12
INDICATORS
Text Label 2000 2250 0    60   ~ 0
5V0
Text Label 2000 2350 0    60   ~ 0
SCL
Text Label 2000 2450 0    60   ~ 0
SDA
Text Label 2000 2550 0    60   ~ 0
GND
$Comp
L CONN_6 P?
U 1 1 4F5F0B3B
P 6700 6550
F 0 "P?" V 6650 6550 60  0000 C CNN
F 1 "CONN_6" V 6750 6550 60  0000 C CNN
F 2 "PIN_ARRAY-6X1" H 6700 6550 60  0001 C CNN
	1    6700 6550
	1    0    0    -1  
$EndComp
$Comp
L CONN_6 P?
U 1 1 4F5F0B3A
P 6700 7275
F 0 "P?" V 6650 7275 60  0000 C CNN
F 1 "CONN_6" V 6750 7275 60  0000 C CNN
F 2 "PIN_ARRAY-6X1" H 6700 7275 60  0001 C CNN
	1    6700 7275
	1    0    0    -1  
$EndComp
Text Label 5750 7425 0    60   ~ 0
SDA
Text Label 5750 7525 0    60   ~ 0
SCL
NoConn ~ 6350 6800
NoConn ~ 6350 7025
NoConn ~ 6350 7125
NoConn ~ 6350 7225
NoConn ~ 6350 7325
$Comp
L I/O P?
U 1 1 4F5F0B39
P 6500 6900
F 0 "P?" H 6580 6900 40  0000 L CNN
F 1 "I/O" H 6500 6955 30  0001 C CNN
F 2 "I/O" H 6500 6900 60  0001 C CNN
	1    6500 6900
	1    0    0    -1  
$EndComp
NoConn ~ 6350 6900
Text Label 2000 2650 0    60   ~ 0
RST
Text Label 2000 2750 0    60   ~ 0
SQW
Text Label 2000 2850 0    60   ~ 0
32k
Text Label 2000 2950 0    60   ~ 0
BAT
Text Label 5750 6400 0    50   ~ 0
3V3
$Comp
L CONN_6 P?
U 1 1 4F5F0B2E
P 4300 6950
F 0 "P?" V 4250 6950 60  0000 C CNN
F 1 "BootDrive" V 4350 6950 60  0000 C CNN
F 2 "PIN_ARRAY-6X1" H 4300 6950 60  0001 C CNN
	1    4300 6950
	1    0    0    1   
$EndComp
Text Label 3575 7200 0    50   ~ 0
GND
Text Label 3575 7100 0    50   ~ 0
GND
Text Label 3575 7000 0    50   ~ 0
5V0
Text Label 3575 6900 0    50   ~ 0
TXD
Text Label 3575 6800 0    50   ~ 0
RXD
Text Label 3575 6700 0    50   ~ 0
Boot
Text Notes 3500 6200 0    60   Italic 12
BootDrive Header
$Comp
L CONN_6 P?
U 1 1 4F5F0B2C
P 7975 6550
F 0 "P?" V 7925 6550 60  0000 C CNN
F 1 "GPS_UP501" V 8025 6550 60  0000 C CNN
F 2 "PIN_ARRAY-6X1" V 8125 6550 60  0001 C CNN
	1    7975 6550
	1    0    0    -1  
$EndComp
Text Label 7225 6400 0    50   ~ 0
GPS_Tx
Text Label 7225 6500 0    50   ~ 0
GND
Text Label 7225 6600 0    50   ~ 0
3V3
Text Label 7225 6700 0    50   ~ 0
BAT
Text Label 7225 6800 0    50   ~ 0
1pps
Text Notes 7000 6200 0    60   Italic 12
GPS Breakout
Wire Wire Line
	7625 6700 7225 6700
Wire Wire Line
	7625 6500 7225 6500
Wire Wire Line
	7625 6300 7225 6300
Wire Wire Line
	3950 6700 3575 6700
Wire Wire Line
	3950 6900 3575 6900
Wire Wire Line
	3950 7100 3575 7100
Wire Notes Line
	4475 7650 3500 7650
Wire Notes Line
	4475 6200 4475 7650
Wire Notes Line
	3500 6200 4475 6200
Wire Wire Line
	1900 2750 2000 2750
Wire Wire Line
	6350 7525 5750 7525
Wire Wire Line
	1900 2550 2000 2550
Wire Wire Line
	1900 2350 2000 2350
Wire Notes Line
	5650 7650 5650 6200
Wire Notes Line
	6900 7650 5650 7650
Wire Notes Line
	6900 6200 6900 7650
Wire Notes Line
	6900 6200 5650 6200
Wire Notes Line
	1800 7650 1800 6200
Wire Notes Line
	3400 7650 1800 7650
Wire Notes Line
	3400 6200 3400 7650
Wire Notes Line
	3400 6200 1800 6200
Wire Wire Line
	6350 6600 5750 6600
Wire Wire Line
	6350 6300 5750 6300
Wire Wire Line
	2800 6700 2850 6700
Wire Wire Line
	2800 6650 2800 6700
Wire Wire Line
	2750 6650 2800 6650
Wire Wire Line
	2850 6800 1950 6800
Wire Wire Line
	2850 7200 1950 7200
Wire Wire Line
	2850 7000 1950 7000
Wire Wire Line
	5200 6400 5200 6350
Wire Wire Line
	4900 7400 4900 7350
Wire Wire Line
	5200 7400 4900 7400
Wire Wire Line
	5200 7350 5200 7400
Wire Wire Line
	4900 6950 4900 6900
Wire Wire Line
	1100 6700 750  6700
Wire Wire Line
	1100 6900 750  6900
Wire Wire Line
	1100 7100 750  7100
Wire Wire Line
	2650 7100 2850 7100
Connection ~ 2650 7200
Wire Wire Line
	750  7200 1100 7200
Wire Wire Line
	1100 7000 750  7000
Wire Wire Line
	1100 6800 750  6800
Wire Wire Line
	5200 6900 5200 6950
Wire Wire Line
	5050 7450 5050 7400
Connection ~ 5050 7400
Wire Wire Line
	4900 6400 4900 6350
Wire Wire Line
	2650 7200 2650 7100
Wire Wire Line
	2850 6900 1950 6900
Wire Wire Line
	2300 6650 2350 6650
Wire Wire Line
	2300 6700 2300 6650
Wire Wire Line
	1950 6700 2300 6700
Wire Wire Line
	6350 6500 5750 6500
Wire Notes Line
	1675 6200 575  6200
Wire Notes Line
	1675 7650 1675 6200
Wire Notes Line
	575  7650 1675 7650
Wire Notes Line
	575  7650 575  6200
Wire Notes Line
	5500 6200 4625 6200
Wire Notes Line
	5500 7650 5500 6200
Wire Notes Line
	4625 7650 5500 7650
Wire Notes Line
	4625 7650 4625 6200
Wire Notes Line
	3500 6200 3500 7650
Wire Wire Line
	1900 2250 2000 2250
Wire Wire Line
	1900 2450 2000 2450
Wire Wire Line
	6350 7425 5750 7425
Wire Wire Line
	6250 6700 6350 6700
Wire Wire Line
	6250 6600 6250 6700
Connection ~ 6250 6600
Wire Wire Line
	1900 2650 2000 2650
Wire Wire Line
	1900 2850 2000 2850
Wire Wire Line
	1900 2950 2000 2950
Wire Wire Line
	6350 6400 5750 6400
Wire Wire Line
	3950 7200 3575 7200
Wire Wire Line
	3950 7000 3575 7000
Wire Wire Line
	3950 6800 3575 6800
Wire Wire Line
	7625 6400 7225 6400
Wire Wire Line
	7625 6600 7225 6600
Wire Wire Line
	7625 6800 7225 6800
Wire Notes Line
	8225 6200 7000 6200
Wire Notes Line
	8225 6925 8225 6200
Wire Notes Line
	7000 6925 8225 6925
Wire Notes Line
	7000 6925 7000 6200
Text Label 7225 6300 0    50   ~ 0
GPS_Rx
$EndSCHEMATC
