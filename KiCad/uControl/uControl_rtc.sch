EESchema Schematic File Version 2  date Friday 28 December 2012 10:02:48 PM IST
LIBS:uControl
LIBS:Conn-raspberry
LIBS:power
LIBS:uControl_v1-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 4 5
Title "uControl"
Date "28 dec 2012"
Rev "1"
Comp "WyoLum"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	9050 4800 8000 4800
Wire Wire Line
	9050 4500 8000 4500
Connection ~ 7150 1675
Wire Wire Line
	7150 1750 7150 1675
Wire Wire Line
	9050 3750 8000 3750
Wire Wire Line
	8000 3750 8000 1675
Wire Wire Line
	8000 1675 4375 1675
Wire Wire Line
	6450 2600 7500 2600
Wire Wire Line
	9050 4000 4500 4000
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
	4550 3875 9050 3875
Wire Wire Line
	6450 2450 7500 2450
Wire Wire Line
	7500 2750 6450 2750
Wire Wire Line
	4375 2600 4375 4125
Wire Wire Line
	4375 4125 9050 4125
Wire Wire Line
	5300 2000 5300 1850
Connection ~ 5300 1900
Wire Wire Line
	7150 2250 7150 2450
Connection ~ 7150 2450
Wire Wire Line
	9050 4350 8000 4350
Wire Wire Line
	9050 4650 8000 4650
Text Label 8000 4800 0    40   ~ 0
RST
Text Label 8000 4650 0    40   ~ 0
~PD3_SQW
Text Label 8000 4500 0    40   ~ 0
32k
Text Label 8000 4350 0    40   ~ 0
BAT
Text HLabel 9050 4800 2    60   Input ~ 0
RST
Text HLabel 9050 4650 2    60   Input ~ 0
~PD3_SQW
Text HLabel 9050 4500 2    60   Input ~ 0
32k
Text HLabel 9050 4350 2    60   Input ~ 0
BAT
$Comp
L R R11
U 1 1 4ECB8D22
P 7150 2000
F 0 "R11" H 7225 2150 50  0000 C CNN
F 1 "10k" V 7150 2000 50  0000 C CNN
F 2 "rc03_vert" H 7150 2000 60  0001 C CNN
	1    7150 2000
	1    0    0    -1  
$EndComp
$Comp
L +BATT #PWR023
U 1 1 4EC101F0
P 5300 1850
F 0 "#PWR023" H 5300 1800 20  0001 C CNN
F 1 "+BATT" H 5300 1950 30  0000 C CNN
	1    5300 1850
	1    0    0    -1  
$EndComp
Text HLabel 9050 4125 2    60   Input ~ 0
GND
Text HLabel 9050 4000 2    60   Input ~ 0
SDA
Text HLabel 9050 3875 2    60   Input ~ 0
SCL
Text HLabel 9050 3750 2    60   Input ~ 0
5V0
Text Label 8000 3750 0    40   ~ 0
5V0
Text Label 8000 4125 0    40   ~ 0
GND
$Comp
L I/O B3
U 1 1 4E1FEBD4
P 7650 2750
F 0 "B3" H 7730 2750 40  0000 L CNN
F 1 "I/O" H 7650 2805 30  0001 C CNN
F 2 "I/O" H 7650 2750 60  0001 C CNN
	1    7650 2750
	1    0    0    -1  
$EndComp
$Comp
L I/O B2
U 1 1 4E1FEBCE
P 7650 2600
F 0 "B2" H 7730 2600 40  0000 L CNN
F 1 "I/O" H 7650 2655 30  0001 C CNN
F 2 "I/O" H 7650 2600 60  0001 C CNN
	1    7650 2600
	1    0    0    -1  
$EndComp
$Comp
L I/O B1
U 1 1 4E1FEBC6
P 7650 2450
F 0 "B1" H 7730 2450 40  0000 L CNN
F 1 "I/O" H 7650 2505 30  0001 C CNN
F 2 "I/O" H 7650 2450 60  0001 C CNN
	1    7650 2450
	1    0    0    -1  
$EndComp
$Comp
L DS3231N U5
U 1 1 4E1FEA7F
P 5550 2800
F 0 "U5" H 5850 3350 60  0000 C CNN
F 1 "DS3231N" H 5250 2400 60  0000 C CNN
F 2 "DS3231" H 5550 2800 60  0001 C CNN
	1    5550 2800
	1    0    0    -1  
$EndComp
$Comp
L C C23
U 1 1 4E1FEA7E
P 4175 2775
F 0 "C23" H 4175 2850 50  0000 L CNN
F 1 "100n" V 4225 2525 50  0000 L CNN
F 2 "C2" H 4175 2775 60  0001 C CNN
	1    4175 2775
	1    0    0    -1  
$EndComp
Text Label 4750 3750 0    40   ~ 0
GND
Text Label 3950 1900 0    40   ~ 0
BAT
Text Label 8000 3875 0    40   ~ 0
SCL
Text Label 8000 4000 0    40   ~ 0
SDA
Text Label 6500 2450 0    40   ~ 0
~PD3_SQW
Text Label 6500 2600 0    40   ~ 0
RST
Text Label 6500 2750 0    40   ~ 0
32k
$Comp
L BATT_RTC BT1
U 1 1 4E1FEA78
P 3950 2800
F 0 "BT1" H 3650 2600 50  0000 C CNN
F 1 "BATT_RTC" H 3950 2610 50  0000 C CNN
F 2 "CR2032" H 3950 2800 60  0001 C CNN
	1    3950 2800
	0    1    1    0   
$EndComp
$EndSCHEMATC
