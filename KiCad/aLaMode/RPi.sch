EESchema Schematic File Version 2  date 6/2/2012 4:03:37 PM
LIBS:aLaMode
LIBS:power
LIBS:Conn-raspberry
LIBS:aLaMode_v1-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 4 4
Title ""
Date "2 jun 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 8400 2500 0    40   ~ 0
GND
Text Label 5400 2500 0    40   ~ 0
GND
Text Label 1600 3100 0    40   ~ 0
GND
Text Label 1600 2200 0    40   ~ 0
GND
Connection ~ 5400 2500
Wire Wire Line
	5400 2600 5400 2300
Connection ~ 1450 3100
Wire Wire Line
	1450 3150 1450 2900
Connection ~ 2050 1250
Wire Wire Line
	2050 1400 2050 1250
Wire Wire Line
	5400 2000 5400 1850
Wire Wire Line
	1450 1700 1450 1550
Wire Wire Line
	9050 2050 9050 2150
Wire Wire Line
	9050 2150 8700 2150
Wire Wire Line
	950  1050 5850 1050
Wire Wire Line
	5850 1050 5850 2150
Wire Wire Line
	950  1250 4850 1250
Wire Wire Line
	4850 1250 4850 1950
Wire Wire Line
	5400 2500 5250 2500
Wire Wire Line
	5250 2500 5250 2450
Wire Wire Line
	4850 1950 4150 1950
Wire Wire Line
	5850 2150 5700 2150
Wire Wire Line
	4800 2150 4150 2150
Wire Wire Line
	2050 1850 2850 1850
Wire Wire Line
	1150 2750 950  2750
Wire Wire Line
	1450 2200 1600 2200
Wire Wire Line
	1600 2200 1600 2150
Wire Wire Line
	1600 3050 1600 3100
Wire Wire Line
	1600 3100 1450 3100
Wire Wire Line
	1150 1850 950  1850
Wire Wire Line
	2050 2750 2150 2750
Wire Wire Line
	2150 2750 2150 1950
Wire Wire Line
	2150 1950 2850 1950
Wire Wire Line
	4150 2050 4950 2050
Wire Wire Line
	8250 2450 8250 2500
Wire Wire Line
	8250 2500 8400 2500
Wire Wire Line
	4950 2050 4950 1150
Wire Wire Line
	4950 1150 950  1150
Wire Wire Line
	7800 2150 7500 2150
Wire Wire Line
	7500 2150 7500 2050
Wire Wire Line
	950  850  1550 850 
Wire Wire Line
	1450 2600 1450 2450
Wire Wire Line
	8400 2000 8400 1850
Wire Wire Line
	1450 2250 1450 2000
Connection ~ 1450 2200
Wire Wire Line
	8400 2600 8400 2300
Connection ~ 8400 2500
$Comp
L GND #PWR020
U 1 1 4FC9D996
P 8400 2600
F 0 "#PWR020" H 8400 2600 30  0001 C CNN
F 1 "GND" H 8400 2530 30  0001 C CNN
	1    8400 2600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR021
U 1 1 4FC9D98F
P 5400 2600
F 0 "#PWR021" H 5400 2600 30  0001 C CNN
F 1 "GND" H 5400 2530 30  0001 C CNN
	1    5400 2600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR022
U 1 1 4FC9D983
P 1450 3150
F 0 "#PWR022" H 1450 3150 30  0001 C CNN
F 1 "GND" H 1450 3080 30  0001 C CNN
	1    1450 3150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR023
U 1 1 4FC9D980
P 1450 2250
F 0 "#PWR023" H 1450 2250 30  0001 C CNN
F 1 "GND" H 1450 2180 30  0001 C CNN
	1    1450 2250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR024
U 1 1 4FC9D976
P 2050 1400
F 0 "#PWR024" H 2050 1400 30  0001 C CNN
F 1 "GND" H 2050 1330 30  0001 C CNN
	1    2050 1400
	1    0    0    -1  
$EndComp
Text Label 1450 2450 0    40   ~ 0
3V3
Text Label 1450 1550 0    40   ~ 0
3V3
Text Label 5400 1850 0    40   ~ 0
3V3
Text Label 8400 1850 0    40   ~ 0
3V3
Text HLabel 950  850  0    40   BiDi ~ 0
3V3
Text Label 1550 850  0    40   ~ 0
3V3
Text Notes 8050 2850 0    40   ~ 0
SPARE BUFFER\nwith Break Out Pins
$Comp
L I/O B4
U 1 1 4FC9D8B5
P 9050 1900
F 0 "B4" V 9130 1900 40  0000 L CNN
F 1 "I/O" H 9050 1955 30  0001 C CNN
	1    9050 1900
	0    -1   -1   0   
$EndComp
$Comp
L I/O B1
U 1 1 4FC9D8AD
P 7500 1900
F 0 "B1" V 7580 1900 40  0000 L CNN
F 1 "I/O" H 7500 1955 30  0001 C CNN
	1    7500 1900
	0    -1   -1   0   
$EndComp
Text Label 1050 1050 0    40   ~ 0
TXD
Text Label 1050 1150 0    40   ~ 0
Rpi_Tx
Text Label 1050 1250 0    40   ~ 0
GND
Text HLabel 950  1250 0    40   BiDi ~ 0
GND
Text HLabel 950  1050 0    40   Input ~ 0
TXD
Text HLabel 950  1150 0    40   Output ~ 0
RXD
NoConn ~ 4150 1750
NoConn ~ 4150 2250
NoConn ~ 4150 2450
NoConn ~ 4150 2550
NoConn ~ 4150 2750
NoConn ~ 4150 2950
NoConn ~ 4150 2850
NoConn ~ 2850 2850
NoConn ~ 2850 2750
NoConn ~ 2850 2650
NoConn ~ 2850 2450
NoConn ~ 2850 2350
NoConn ~ 2850 2250
NoConn ~ 2850 2050
NoConn ~ 2850 1750
Text Label 5850 2150 0    40   ~ 0
TXD
Text Label 4300 1950 0    40   ~ 0
GND
Text Label 4300 2150 0    40   ~ 0
Rpi_Rx
Text Label 4300 2050 0    40   ~ 0
Rpi_Tx
Text HLabel 950  2750 0    40   Input ~ 0
SCL
Text HLabel 950  1850 0    40   Input ~ 0
SDA
Text Label 1000 2750 0    40   ~ 0
SCL
Text Label 1000 1850 0    40   ~ 0
SDA
Text Label 2150 1950 0    40   ~ 0
Rpi_SCL
Text Label 2150 1850 0    40   ~ 0
Rpi_SDA
$Comp
L 74LS125 U6
U 4 1 4FC9D559
P 8250 2150
F 0 "U6" H 8250 2250 50  0000 L BNN
F 1 "74LS125" H 8300 2000 40  0000 L TNN
	4    8250 2150
	-1   0    0    -1  
$EndComp
$Comp
L 74LS125 U6
U 3 1 4FC9D548
P 5250 2150
F 0 "U6" H 5250 2250 50  0000 L BNN
F 1 "74LS125" H 5300 2000 40  0000 L TNN
	3    5250 2150
	-1   0    0    -1  
$EndComp
$Comp
L 74LS125 U6
U 2 1 4FC9D53C
P 1600 2750
F 0 "U6" H 1600 2850 50  0000 L BNN
F 1 "74LS125" H 1650 2600 40  0000 L TNN
	2    1600 2750
	1    0    0    -1  
$EndComp
$Comp
L 74LS125 U6
U 1 1 4FC9D509
P 1600 1850
F 0 "U6" H 1600 1950 50  0000 L BNN
F 1 "74LS125" H 1650 1700 40  0000 L TNN
	1    1600 1850
	1    0    0    -1  
$EndComp
Text Notes 3150 3200 0    60   Italic 12
NOTE : GPIO voltage levels are 3v3 and are not 5v tolerant.
NoConn ~ 4150 1850
NoConn ~ 4150 2350
NoConn ~ 4150 2650
NoConn ~ 2850 2950
NoConn ~ 2850 2550
NoConn ~ 2850 2150
$Comp
L PBD-26 P1
U 1 1 4FC86C1D
P 3500 2350
F 0 "P1" H 3500 3050 60  0000 C CNN
F 1 "PBD-26" V 3500 2350 50  0000 C CNN
	1    3500 2350
	1    0    0    -1  
$EndComp
NoConn ~ 2750 4450
NoConn ~ 2750 4350
NoConn ~ 2750 4250
NoConn ~ 2750 4150
NoConn ~ 2750 4050
NoConn ~ 2750 3950
NoConn ~ 2750 3850
NoConn ~ 1900 4450
NoConn ~ 1900 4350
NoConn ~ 1900 4250
NoConn ~ 1900 4150
NoConn ~ 1900 4050
NoConn ~ 1900 3950
NoConn ~ 1900 3850
NoConn ~ 1900 3750
$Comp
L CONN_7 P3
U 1 1 4FBF7498
P 3100 4150
F 0 "P3" H 3050 4550 60  0000 C CNN
F 1 "LAN_JTAG" V 3170 4150 60  0000 C CNN
	1    3100 4150
	1    0    0    -1  
$EndComp
$Comp
L CONN_8 P2
U 1 1 4FBF744D
P 2250 4100
F 0 "P2" H 2200 4550 60  0000 C CNN
F 1 "GPU_JTAG" V 2300 4100 60  0000 C CNN
	1    2250 4100
	1    0    0    -1  
$EndComp
$EndSCHEMATC
