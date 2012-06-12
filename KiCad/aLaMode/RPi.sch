EESchema Schematic File Version 2  date Tuesday 12 June 2012 11:26:21 PM IST
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
Date "12 jun 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 6350 3300
Wire Wire Line
	6350 3225 6350 3300
Connection ~ 2125 3500
Wire Wire Line
	2125 3600 2125 3500
Wire Wire Line
	2300 2050 2300 2125
Wire Wire Line
	2300 2125 1925 2125
Wire Wire Line
	1925 2125 1925 2050
Connection ~ 1925 1575
Wire Wire Line
	1925 1650 1925 1575
Wire Wire Line
	1500 1125 5200 1125
Wire Wire Line
	5200 1125 5200 2175
Wire Wire Line
	5200 2175 3950 2175
Wire Wire Line
	3750 1475 2300 1475
Wire Wire Line
	7900 3800 8700 3800
Wire Wire Line
	3250 2375 1500 2375
Wire Wire Line
	3450 1875 3450 1575
Wire Wire Line
	1500 3075 3250 3075
Wire Wire Line
	1500 2875 3250 2875
Wire Wire Line
	1500 2675 3250 2675
Wire Wire Line
	3950 3075 4800 3075
Wire Wire Line
	4800 3075 4800 4400
Wire Wire Line
	4800 4400 6600 4400
Wire Wire Line
	3950 2875 5000 2875
Wire Wire Line
	5000 2875 5000 4200
Wire Wire Line
	5000 4200 6600 4200
Wire Wire Line
	3950 2675 8600 2675
Wire Wire Line
	8600 2675 8600 3700
Wire Wire Line
	8600 3700 7900 3700
Wire Wire Line
	3950 2475 5100 2475
Wire Wire Line
	5100 2475 5100 3500
Wire Wire Line
	5100 3500 6600 3500
Wire Wire Line
	8200 3500 7900 3500
Wire Wire Line
	3950 2375 5200 2375
Wire Wire Line
	5200 2375 5200 3400
Wire Wire Line
	5200 3400 6600 3400
Wire Wire Line
	7900 3600 8500 3600
Wire Wire Line
	8500 3600 8500 2575
Wire Wire Line
	8500 2575 3950 2575
Wire Wire Line
	8700 3800 8700 2775
Wire Wire Line
	8700 2775 3950 2775
Wire Wire Line
	3950 2975 4900 2975
Wire Wire Line
	4900 2975 4900 4300
Wire Wire Line
	4900 4300 6600 4300
Wire Wire Line
	3250 2575 1500 2575
Wire Wire Line
	3250 2775 1500 2775
Wire Wire Line
	3250 2975 1500 2975
Wire Wire Line
	1500 3500 3600 3500
Wire Wire Line
	3600 3500 3600 3275
Wire Wire Line
	3750 1475 3750 1875
Wire Wire Line
	3250 2475 1500 2475
Wire Wire Line
	3450 1575 1500 1575
Wire Wire Line
	2300 1475 2300 1650
Wire Wire Line
	2125 2175 2125 2125
Connection ~ 2125 2125
Wire Wire Line
	6600 3300 5900 3300
$Comp
L PWR_FLAG #FLG020
U 1 1 4FD632B4
P 6350 3225
F 0 "#FLG020" H 6350 3495 30  0001 C CNN
F 1 "PWR_FLAG" H 6350 3455 30  0000 C CNN
	1    6350 3225
	1    0    0    -1  
$EndComp
Text Label 5900 3300 0    40   ~ 0
Rpi_3V3
$Comp
L GND #PWR021
U 1 1 4FD62C0F
P 2125 2175
F 0 "#PWR021" H 2125 2175 30  0001 C CNN
F 1 "GND" H 2125 2105 30  0001 C CNN
	1    2125 2175
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR022
U 1 1 4FD62BFD
P 2125 3600
F 0 "#PWR022" H 2125 3600 30  0001 C CNN
F 1 "GND" H 2125 3530 30  0001 C CNN
	1    2125 3600
	1    0    0    -1  
$EndComp
$Comp
L C C13
U 1 1 4FD62BCC
P 2300 1850
F 0 "C13" H 2150 1950 50  0000 L CNN
F 1 "100n" H 2100 1750 50  0000 L CNN
F 2 "c_0805" H 2300 1850 60  0001 C CNN
	1    2300 1850
	-1   0    0    1   
$EndComp
$Comp
L C C12
U 1 1 4FD62B83
P 1925 1850
F 0 "C12" H 1775 1950 50  0000 L CNN
F 1 "100n" H 1725 1750 50  0000 L CNN
F 2 "c_0805" H 1925 1850 60  0001 C CNN
	1    1925 1850
	-1   0    0    1   
$EndComp
Text HLabel 1500 1125 0    40   Input ~ 0
U6_OE
Text Notes 2075 1125 0    40   ~ 0
NOTE : How do we handle U6_OE ? Permanently enabled, or via an ATMega Port ?
Text Label 1500 1125 0    40   ~ 0
U6_OE
Text Label 4150 3075 0    40   ~ 0
Rpi_SCK
Text Label 4150 2975 0    40   ~ 0
Rpi_MISO
Text Label 4150 2875 0    40   ~ 0
Rpi_MOSI
Text Label 4150 2775 0    40   ~ 0
Rpi_RST
Text Label 4150 2675 0    40   ~ 0
Rpi_Rx
Text Label 4150 2575 0    40   ~ 0
Rpi_Tx
Text Label 4150 2475 0    40   ~ 0
Rpi_SCL
Text Label 4150 2375 0    40   ~ 0
Rpi_SDA
Text Label 2850 1475 0    40   ~ 0
Rpi_3V3
Text Label 2850 1575 0    40   ~ 0
5V0
Text Label 2850 3075 0    40   ~ 0
SCK
Text HLabel 1500 3075 0    40   Input ~ 0
SCK
Text HLabel 1500 2975 0    40   Input ~ 0
MISO
Text Label 2850 2975 0    40   ~ 0
MISO
Text Label 2850 2875 0    40   ~ 0
MOSI
Text HLabel 1500 2875 0    40   Input ~ 0
MOSI
Text HLabel 1500 2775 0    40   Output ~ 0
RESET
Text Label 2850 2775 0    40   ~ 0
RESET
Text HLabel 1500 1575 0    40   BiDi ~ 0
5V0
Text Label 5900 4400 0    40   ~ 0
Rpi_SCK
Text Label 5900 4300 0    40   ~ 0
Rpi_MISO
Text Label 5900 4200 0    40   ~ 0
Rpi_MOSI
Text Label 8200 3800 0    40   ~ 0
Rpi_RST
$Comp
L BCM2835_GPIO P1
U 1 1 4FD5E087
P 7250 3900
F 0 "P1" H 7250 4600 60  0000 C CNN
F 1 "BCM2835_GPIO" V 7250 3900 50  0000 C CNN
F 2 "pin_strip_7" H 7250 3900 60  0001 C CNN
	1    7250 3900
	1    0    0    -1  
$EndComp
$Comp
L TSX0108 U6
U 1 1 4FD5DAA4
P 3600 2575
F 0 "U6" H 3600 2975 40  0000 C CNN
F 1 "TSX0108" H 3600 2875 40  0000 C CNN
	1    3600 2575
	-1   0    0    -1  
$EndComp
Text Label 2850 2675 0    40   ~ 0
TXD
Text Label 2850 2575 0    40   ~ 0
RXD
Text Label 2850 3500 0    40   ~ 0
GND
Text HLabel 1500 3500 0    40   BiDi ~ 0
GND
Text HLabel 1500 2675 0    40   Input ~ 0
TXD
Text HLabel 1500 2575 0    40   Output ~ 0
RXD
NoConn ~ 7900 3300
NoConn ~ 7900 4000
NoConn ~ 7900 4100
NoConn ~ 7900 4300
NoConn ~ 7900 4500
NoConn ~ 7900 4400
NoConn ~ 6600 4000
NoConn ~ 6600 3900
NoConn ~ 6600 3800
NoConn ~ 6600 3600
Text Label 8200 3500 0    40   ~ 0
GND
Text Label 8200 3700 0    40   ~ 0
Rpi_Rx
Text Label 8200 3600 0    40   ~ 0
Rpi_Tx
Text HLabel 1500 2475 0    40   Input ~ 0
SCL
Text HLabel 1500 2375 0    40   Input ~ 0
SDA
Text Label 2850 2475 0    40   ~ 0
SCL
Text Label 2850 2375 0    40   ~ 0
SDA
Text Label 5900 3500 0    40   ~ 0
Rpi_SCL
Text Label 5900 3400 0    40   ~ 0
Rpi_SDA
Text Notes 6900 4750 0    60   Italic 12
NOTE : GPIO voltage levels are 3v3 and are not 5v tolerant.
NoConn ~ 7900 3400
NoConn ~ 7900 3900
NoConn ~ 7900 4200
NoConn ~ 6600 4500
NoConn ~ 6600 4100
NoConn ~ 6600 3700
NoConn ~ 10350 4500
NoConn ~ 10350 4400
NoConn ~ 10350 4300
NoConn ~ 10350 4200
NoConn ~ 10350 4100
NoConn ~ 10350 4000
NoConn ~ 10350 3900
NoConn ~ 9500 4500
NoConn ~ 9500 4400
NoConn ~ 9500 4300
NoConn ~ 9500 4200
NoConn ~ 9500 4100
NoConn ~ 9500 4000
NoConn ~ 9500 3900
NoConn ~ 9500 3800
$Comp
L CONN_7 P3
U 1 1 4FBF7498
P 10700 4200
F 0 "P3" H 10650 4600 60  0000 C CNN
F 1 "LAN_JTAG" V 10770 4200 60  0000 C CNN
F 2 "pin_strip_7" H 10700 4200 60  0001 C CNN
	1    10700 4200
	1    0    0    -1  
$EndComp
$Comp
L CONN_8 P2
U 1 1 4FBF744D
P 9850 4150
F 0 "P2" H 9800 4600 60  0000 C CNN
F 1 "GPU_JTAG" V 9900 4150 60  0000 C CNN
F 2 "pin_strip_7" H 9850 4150 60  0001 C CNN
	1    9850 4150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
