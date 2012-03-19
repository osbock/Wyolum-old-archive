EESchema Schematic File Version 2  date Tuesday 20 March 2012 12:04:09 AM IST
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
Sheet 4 5
Title "Buckler, i2sd, v3, with RTC, with HW addressing"
Date "19 mar 2012"
Rev "3"
Comp "WyoLum"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	6975 5600 6850 5600
Wire Wire Line
	6975 5400 6850 5400
Wire Wire Line
	6975 5500 6850 5500
Wire Wire Line
	6975 5700 6850 5700
Wire Wire Line
	6975 6150 6850 6150
Wire Wire Line
	6975 5950 6850 5950
Wire Wire Line
	6975 5850 6850 5850
Wire Wire Line
	6975 6050 6850 6050
Wire Wire Line
	6150 6050 6025 6050
Wire Wire Line
	6150 5850 6025 5850
Wire Wire Line
	6150 5950 6025 5950
Wire Wire Line
	6150 6150 6025 6150
Wire Wire Line
	6150 5700 6025 5700
Wire Wire Line
	6150 5500 6025 5500
Wire Wire Line
	6150 5400 6025 5400
Wire Wire Line
	6150 5600 6025 5600
Wire Notes Line
	7650 4950 5925 4950
Wire Notes Line
	7650 4950 7650 6300
Wire Notes Line
	7650 6300 5925 6300
Wire Notes Line
	5925 6300 5925 4950
Text Label 6850 6150 0    40   ~ 0
BAT
Text Label 6850 6050 0    40   ~ 0
32k
Text Label 6850 5950 0    40   ~ 0
SQW
Text Label 6850 5850 0    40   ~ 0
RST
Text Label 6025 6150 0    40   ~ 0
BAT
Text Label 6025 6050 0    40   ~ 0
32k
Text Label 6025 5950 0    40   ~ 0
SQW
Text Label 6025 5850 0    40   ~ 0
RST
Text Notes 6075 5075 0    60   Italic 12
Additional SMD headers for\nrtcBoB/ChronoDot compatibility
Text Label 6850 5700 0    50   ~ 0
SDA
Text Label 6850 5600 0    50   ~ 0
SCL
Text Label 6850 5400 0    50   ~ 0
GND
Text Label 6850 5500 0    50   ~ 0
5V0
Text Label 6025 5400 0    50   ~ 0
GND
Text Label 6025 5500 0    50   ~ 0
5V0
Text Label 6025 5700 0    50   ~ 0
SDA
Text Label 6025 5600 0    50   ~ 0
SCL
$Comp
L CONN_4 P?
U 1 1 4F6084BD
P 7325 6000
F 0 "P?" V 7275 6000 50  0000 C CNN
F 1 "CD1" V 7375 6000 50  0000 C CNN
F 2 "Sck-04-F-SMT" H 7325 6000 60  0001 C CNN
	1    7325 6000
	1    0    0    1   
$EndComp
$Comp
L CONN_4 P?
U 1 1 4F6084BC
P 7325 5550
F 0 "P?" V 7275 5550 50  0000 C CNN
F 1 "CD2" V 7375 5550 50  0000 C CNN
F 2 "Sck-04-F-SMT" H 7325 5550 60  0001 C CNN
	1    7325 5550
	1    0    0    1   
$EndComp
$Comp
L CONN_4 P?
U 1 1 4F6084BB
P 6500 6000
F 0 "P?" V 6450 6000 50  0000 C CNN
F 1 "CD1" V 6550 6000 50  0000 C CNN
F 2 "Sck-04-F-SMT" H 6500 6000 60  0001 C CNN
	1    6500 6000
	1    0    0    1   
$EndComp
$Comp
L CONN_4 P?
U 1 1 4F6084BA
P 6500 5550
F 0 "P?" V 6450 5550 50  0000 C CNN
F 1 "CD2" V 6550 5550 50  0000 C CNN
F 2 "Sck-04-F-SMT" H 6500 5550 60  0001 C CNN
	1    6500 5550
	1    0    0    1   
$EndComp
Wire Wire Line
	7250 4800 6950 4800
Wire Wire Line
	7250 4500 6950 4500
Connection ~ 6650 1675
Wire Wire Line
	6650 1750 6650 1675
Wire Wire Line
	7250 3750 7050 3750
Wire Wire Line
	7050 3750 7050 1675
Wire Wire Line
	7050 1675 4375 1675
Wire Wire Line
	6450 2600 6675 2600
Wire Wire Line
	7250 4000 4500 4000
Wire Wire Line
	4500 4000 4500 2850
Wire Wire Line
	4500 2850 4650 2850
Connection ~ 3950 3100
Wire Wire Line
	3950 3100 4175 3100
Wire Wire Line
	4175 3100 4175 2975
Wire Wire Line
	3950 2550 3950 1900
Wire Wire Line
	3950 1900 5300 1900
Connection ~ 6575 3150
Wire Wire Line
	6575 3150 6450 3150
Connection ~ 6575 2950
Wire Wire Line
	6450 2950 6575 2950
Connection ~ 5850 3750
Wire Wire Line
	5850 3750 5850 3650
Wire Wire Line
	5750 3750 5750 3650
Wire Wire Line
	6575 2850 6575 3750
Wire Wire Line
	6575 2850 6450 2850
Wire Wire Line
	4650 2600 4375 2600
Connection ~ 5750 3750
Wire Wire Line
	5950 3750 5950 3650
Connection ~ 5950 3750
Wire Wire Line
	6575 3050 6450 3050
Connection ~ 6575 3050
Wire Wire Line
	6450 3250 6575 3250
Connection ~ 6575 3250
Wire Wire Line
	4650 2450 4375 2450
Wire Wire Line
	3950 3000 3950 3750
Wire Wire Line
	3950 3750 6575 3750
Connection ~ 4375 3750
Wire Wire Line
	4175 2575 4175 2425
Wire Wire Line
	4175 2425 3950 2425
Connection ~ 3950 2425
Wire Wire Line
	4375 2450 4375 1675
Wire Wire Line
	4650 3000 4550 3000
Wire Wire Line
	4550 3000 4550 3875
Wire Wire Line
	4550 3875 7250 3875
Wire Wire Line
	6450 2450 6675 2450
Wire Wire Line
	6675 2750 6450 2750
Wire Wire Line
	4375 2600 4375 4125
Wire Wire Line
	4375 4125 7250 4125
Wire Wire Line
	5300 2000 5300 1850
Connection ~ 5300 1900
Wire Wire Line
	6650 2250 6650 2450
Connection ~ 6650 2450
Wire Wire Line
	7250 4350 6950 4350
Wire Wire Line
	7250 4650 6950 4650
Text Label 6950 4800 0    60   ~ 0
RST
Text Label 6950 4650 0    60   ~ 0
SQW
Text Label 6950 4500 0    60   ~ 0
32k
Text Label 6950 4350 0    60   ~ 0
BAT
Text HLabel 7250 4800 2    60   Input ~ 0
RST
Text HLabel 7250 4650 2    60   Input ~ 0
SQW
Text HLabel 7250 4500 2    60   Input ~ 0
32k
Text HLabel 7250 4350 2    60   Input ~ 0
BAT
$Comp
L R R?
U 1 1 4ECB8D22
P 6650 2000
F 0 "R?" V 6730 2000 50  0000 C CNN
F 1 "10k" V 6650 2000 50  0000 C CNN
F 2 "r_0805" H 6650 2000 60  0001 C CNN
	1    6650 2000
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR?
U 1 1 4EC101F0
P 5300 1850
F 0 "#PWR?" H 5300 1800 20  0001 C CNN
F 1 "+BATT" H 5300 1950 30  0000 C CNN
	1    5300 1850
	1    0    0    -1  
$EndComp
Text HLabel 7250 4125 2    60   Input ~ 0
GND
Text HLabel 7250 4000 2    60   Input ~ 0
SDA
Text HLabel 7250 3875 2    60   Input ~ 0
SCL
Text HLabel 7250 3750 2    60   Input ~ 0
5V0
Text Label 7050 3750 0    40   ~ 0
5V0
Text Label 7050 4125 0    40   ~ 0
GND
$Comp
L I/O B?
U 1 1 4E1FEBD4
P 6825 2750
F 0 "B?" H 6905 2750 40  0000 L CNN
F 1 "I/O" H 6825 2805 30  0001 C CNN
F 2 "I/O" H 6825 2750 60  0001 C CNN
	1    6825 2750
	1    0    0    -1  
$EndComp
$Comp
L I/O B?
U 1 1 4E1FEBCE
P 6825 2600
F 0 "B?" H 6905 2600 40  0000 L CNN
F 1 "I/O" H 6825 2655 30  0001 C CNN
F 2 "I/O" H 6825 2600 60  0001 C CNN
	1    6825 2600
	1    0    0    -1  
$EndComp
$Comp
L I/O B?
U 1 1 4E1FEBC6
P 6825 2450
F 0 "B?" H 6905 2450 40  0000 L CNN
F 1 "I/O" H 6825 2505 30  0001 C CNN
F 2 "I/O" H 6825 2450 60  0001 C CNN
	1    6825 2450
	1    0    0    -1  
$EndComp
Text Notes 8125 4150 0    60   ~ 0
rtcBoB\n
$Comp
L DS3231N U?
U 1 1 4E1FEA7F
P 5550 2800
F 0 "U?" H 5850 3350 60  0000 C CNN
F 1 "DS3231N" H 5250 2400 60  0000 C CNN
F 2 "DS3231" H 5550 2800 60  0001 C CNN
	1    5550 2800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 4E1FEA7E
P 4175 2775
F 0 "C?" V 4225 2875 50  0000 L CNN
F 1 "100n" V 4225 2575 50  0000 L CNN
F 2 "c_0805" H 4175 2775 60  0001 C CNN
	1    4175 2775
	1    0    0    -1  
$EndComp
Text Label 4750 3750 0    40   ~ 0
GND
Text Label 3950 1900 0    40   ~ 0
BAT
Text Label 7050 3875 0    40   ~ 0
SCL
Text Label 7050 4000 0    40   ~ 0
SDA
Text Label 6500 2450 0    40   ~ 0
SQW
Text Label 6500 2600 0    40   ~ 0
RST
Text Label 6500 2750 0    40   ~ 0
32k
$Comp
L BATT_RTC BT?
U 1 1 4E1FEA78
P 3950 2800
F 0 "BT?" H 3650 2600 50  0000 C CNN
F 1 "BATT_RTC" H 3950 2610 50  0000 C CNN
F 2 "CR1632" H 3950 2800 60  0001 C CNN
F 4 "BU2032SM-HD-GCT-ND " H 3950 2800 60  0001 C CNN "Digikey"
	1    3950 2800
	0    1    1    0   
$EndComp
$EndSCHEMATC
