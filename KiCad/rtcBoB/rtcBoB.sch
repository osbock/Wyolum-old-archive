EESchema Schematic File Version 2  date 12/18/10 15:49:47
LIBS:power
LIBS:rtcBoB
LIBS:rtcBoB-cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title "ClockTHREE :: rtcBoB"
Date "18 dec 2010"
Rev "A"
Comp "anool.m@gmail.com :: wyojustin@gmail.com"
Comment1 "http://goo.gl/V8Mni"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	1750 1700 1650 1700
Wire Wire Line
	1750 1700 1750 1650
Wire Wire Line
	4100 3600 4100 4100
Wire Wire Line
	5800 2300 5800 2700
Wire Wire Line
	5800 2300 6100 2300
Wire Wire Line
	5800 2700 4700 2700
Wire Wire Line
	5300 2350 5300 2700
Connection ~ 2050 1700
Wire Wire Line
	1650 1700 1650 2550
Wire Wire Line
	2050 3950 2050 2950
Wire Wire Line
	4700 2550 5850 2550
Wire Wire Line
	5150 2350 5150 2550
Connection ~ 3550 1700
Wire Wire Line
	6100 2200 5800 2200
Wire Wire Line
	5800 2200 5800 1700
Wire Wire Line
	7050 2400 7450 2400
Wire Wire Line
	7450 2400 7450 3750
Wire Wire Line
	7450 3750 2850 3750
Connection ~ 5000 3950
Wire Wire Line
	7550 2200 7550 3950
Wire Wire Line
	7550 2200 7050 2200
Connection ~ 5150 1800
Wire Wire Line
	5150 1800 5150 1850
Connection ~ 5000 2400
Wire Wire Line
	5000 2350 5000 2400
Wire Wire Line
	2850 3750 2850 2950
Wire Wire Line
	2850 2950 2900 2950
Wire Wire Line
	2900 2400 2400 2400
Connection ~ 4000 3950
Wire Wire Line
	4000 3950 4000 3600
Connection ~ 4200 3950
Wire Wire Line
	4200 3950 4200 3600
Connection ~ 5000 3100
Wire Wire Line
	5000 3100 4700 3100
Connection ~ 5000 2900
Wire Wire Line
	5000 2900 4700 2900
Wire Wire Line
	2900 2550 2400 2550
Wire Wire Line
	2400 2550 2400 3950
Wire Wire Line
	5000 3950 5000 2800
Wire Wire Line
	5000 2800 4700 2800
Wire Wire Line
	5000 3000 4700 3000
Connection ~ 5000 3000
Wire Wire Line
	5000 3200 4700 3200
Connection ~ 5000 3200
Connection ~ 4100 3950
Connection ~ 2400 3950
Wire Wire Line
	2650 2800 2650 3850
Wire Wire Line
	2650 2800 2900 2800
Connection ~ 5150 2550
Wire Wire Line
	5300 1850 5300 1800
Wire Wire Line
	5000 1800 5000 1850
Connection ~ 5000 1800
Wire Wire Line
	7050 2500 7350 2500
Wire Wire Line
	7350 2500 7350 3850
Wire Wire Line
	7350 3850 2650 3850
Wire Wire Line
	7050 2300 7350 2300
Wire Wire Line
	7350 2300 7350 1800
Wire Wire Line
	7350 1800 2400 1800
Connection ~ 5300 1800
Wire Wire Line
	2400 1800 2400 2400
Wire Wire Line
	6100 2400 4700 2400
Wire Wire Line
	2050 1700 2050 2550
Wire Wire Line
	1650 3000 1650 3950
Wire Wire Line
	1650 3950 7550 3950
Connection ~ 2050 3950
Connection ~ 5300 2700
Wire Wire Line
	6100 2500 5850 2500
Wire Wire Line
	5850 2500 5850 2550
Wire Wire Line
	3550 1600 3550 1950
Wire Wire Line
	1950 1650 1950 1700
Wire Wire Line
	1950 1700 5800 1700
$Comp
L CONN_2 P3
U 1 1 4D0C8A06
P 1850 1300
F 0 "P3" V 1800 1300 40  0000 C CNN
F 1 "CONN_2" V 1900 1300 40  0000 C CNN
	1    1850 1300
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR01
U 1 1 4D0C87C4
P 4100 4100
F 0 "#PWR01" H 4100 4100 30  0001 C CNN
F 1 "GND" H 4100 4030 30  0001 C CNN
	1    4100 4100
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR02
U 1 1 4D0C8796
P 3550 1600
F 0 "#PWR02" H 3550 1700 30  0001 C CNN
F 1 "VCC" H 3550 1700 30  0000 C CNN
	1    3550 1600
	1    0    0    -1  
$EndComp
Text Notes 6800 1250 0    40   ~ 0
Mounting Holes
NoConn ~ 6850 1050
NoConn ~ 6850 950 
NoConn ~ 6850 850 
NoConn ~ 6850 750 
$Comp
L CONN_1 H4
U 1 1 4C9C7003
P 7000 1050
F 0 "H4" H 7080 1050 40  0000 L CNN
F 1 "CONN_1" H 7000 1105 30  0001 C CNN
	1    7000 1050
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 H3
U 1 1 4C9C7001
P 7000 950
F 0 "H3" H 7080 950 40  0000 L CNN
F 1 "CONN_1" H 7000 1005 30  0001 C CNN
	1    7000 950 
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 H2
U 1 1 4C9C6FFE
P 7000 850
F 0 "H2" H 7080 850 40  0000 L CNN
F 1 "CONN_1" H 7000 905 30  0001 C CNN
	1    7000 850 
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 H1
U 1 1 4C9C6FF2
P 7000 750
F 0 "H1" H 7080 750 40  0000 L CNN
F 1 "CONN_1" H 7000 805 30  0001 C CNN
	1    7000 750 
	1    0    0    -1  
$EndComp
$Comp
L BATT_LI-PO BT1
U 1 1 4C9C4864
P 1650 2800
F 0 "BT1" H 1300 2750 50  0000 C CNN
F 1 "BATT_RTC" H 2100 2750 50  0000 C CNN
	1    1650 2800
	0    1    1    0   
$EndComp
Text Label 5850 2200 0    47   ~ 0
BAT
Text Label 5850 2300 0    47   ~ 0
32k
Text Label 5850 2400 0    47   ~ 0
SQW
Text Label 5850 2500 0    47   ~ 0
RST
Text Label 7050 2200 0    47   ~ 0
GND
Text Label 7050 2500 0    47   ~ 0
SDA
Text Label 7050 2400 0    47   ~ 0
SCL
Text Label 7050 2300 0    47   ~ 0
VCC
$Comp
L CONN_4 P2
U 1 1 4C9B49C8
P 6700 2350
F 0 "P2" V 6650 2350 50  0000 C CNN
F 1 "CDOT2" V 6750 2350 50  0000 C CNN
	1    6700 2350
	-1   0    0    1   
$EndComp
$Comp
L CONN_4 P1
U 1 1 4C9B49C7
P 6450 2350
F 0 "P1" V 6400 2350 50  0000 C CNN
F 1 "CDOT1" V 6500 2350 50  0000 C CNN
	1    6450 2350
	1    0    0    -1  
$EndComp
$Comp
L DS3231N U1
U 1 1 4C9B49C6
P 3800 2750
F 0 "U1" H 4100 3300 60  0000 C CNN
F 1 "DS3231" H 3500 2350 60  0000 C CNN
	1    3800 2750
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4C9B49C1
P 5000 2100
F 0 "R1" V 5080 2100 50  0000 C CNN
F 1 "10k" V 5000 2100 50  0000 C CNN
	1    5000 2100
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 4C9B49C0
P 5150 2100
F 0 "R2" V 5230 2100 50  0000 C CNN
F 1 "10k" V 5150 2100 50  0000 C CNN
	1    5150 2100
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 4C9B49BF
P 5300 2100
F 0 "R3" V 5380 2100 50  0000 C CNN
F 1 "10k" V 5300 2100 50  0000 C CNN
	1    5300 2100
	1    0    0    -1  
$EndComp
Text Notes 6300 1750 0    60   ~ 0
rtcBOB
$Comp
L C C1
U 1 1 4C9B49BE
P 2050 2750
F 0 "C1" V 2000 2550 50  0000 L CNN
F 1 "100n" V 2100 2550 50  0000 L CNN
	1    2050 2750
	1    0    0    -1  
$EndComp
$EndSCHEMATC
