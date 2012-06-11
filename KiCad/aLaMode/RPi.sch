EESchema Schematic File Version 2  date 6/11/2012 5:51:48 PM
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
Date "11 jun 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 3000 1675 0    40   ~ 0
3V3
Text Label 3000 1775 0    40   ~ 0
5V0
Wire Wire Line
	3000 1675 3750 1675
Wire Wire Line
	3750 1675 3750 1875
Wire Wire Line
	3600 3275 3600 3300
Wire Wire Line
	3600 3300 1500 3300
Wire Wire Line
	1500 3000 2275 3000
Wire Wire Line
	2275 3000 2275 2975
Wire Wire Line
	2275 2975 3250 2975
Wire Wire Line
	1500 2400 2250 2400
Wire Wire Line
	2250 2400 2250 2775
Wire Wire Line
	2250 2775 3250 2775
Wire Wire Line
	1500 2300 2725 2300
Wire Wire Line
	2725 2300 2725 2575
Wire Wire Line
	2725 2575 3250 2575
Wire Wire Line
	1500 2600 2325 2600
Wire Wire Line
	2325 2600 2325 2375
Wire Wire Line
	2325 2375 3250 2375
Wire Wire Line
	6600 4300 4900 4300
Wire Wire Line
	4900 4300 4900 2975
Wire Wire Line
	4900 2975 3950 2975
Wire Wire Line
	3950 2775 8700 2775
Wire Wire Line
	8700 2775 8700 3800
Wire Wire Line
	8700 3800 8225 3800
Wire Wire Line
	3950 2575 8500 2575
Wire Wire Line
	8500 2575 8500 3600
Wire Wire Line
	8500 3600 7900 3600
Wire Wire Line
	6600 3400 5200 3400
Wire Wire Line
	5200 3400 5200 2375
Wire Wire Line
	5200 2375 3950 2375
Wire Wire Line
	7900 3800 8200 3800
Wire Wire Line
	1500 2000 1750 2000
Wire Wire Line
	8200 3500 7900 3500
Wire Wire Line
	1500 1900 1750 1900
Wire Wire Line
	6600 3500 5100 3500
Wire Wire Line
	5100 3500 5100 2475
Wire Wire Line
	5100 2475 3950 2475
Wire Wire Line
	7900 3700 8600 3700
Wire Wire Line
	8600 3700 8600 2675
Wire Wire Line
	8600 2675 3950 2675
Wire Wire Line
	6600 4200 5000 4200
Wire Wire Line
	5000 4200 5000 2875
Wire Wire Line
	5000 2875 3950 2875
Wire Wire Line
	6600 4400 4800 4400
Wire Wire Line
	4800 4400 4800 3075
Wire Wire Line
	4800 3075 3950 3075
Wire Wire Line
	3250 2475 2425 2475
Wire Wire Line
	2425 2475 2425 2700
Wire Wire Line
	2425 2700 1500 2700
Wire Wire Line
	3250 2675 2825 2675
Wire Wire Line
	2825 2675 2825 2200
Wire Wire Line
	2825 2200 1500 2200
Wire Wire Line
	3250 2875 2250 2875
Wire Wire Line
	2250 2875 2250 2900
Wire Wire Line
	2250 2900 1500 2900
Wire Wire Line
	3250 3075 2275 3075
Wire Wire Line
	2275 3075 2275 3100
Wire Wire Line
	2275 3100 1500 3100
Wire Wire Line
	3450 1875 3450 1775
Wire Wire Line
	3450 1775 3000 1775
Text Label 1750 3100 0    40   ~ 0
SCLK
Text HLabel 1500 3100 0    40   Input ~ 0
SCLK
Text HLabel 1500 3000 0    40   Input ~ 0
MISO
Text Label 1750 3000 0    40   ~ 0
MISO
Text Label 1750 2900 0    40   ~ 0
MOSI
Text HLabel 1500 2900 0    40   Input ~ 0
MOSI
Text HLabel 1500 2400 0    40   Output ~ 0
RST
Text Label 1750 2400 0    40   ~ 0
RST
Text Label 1750 1900 0    40   ~ 0
5V0
Text HLabel 1500 1900 0    40   BiDi ~ 0
5V0
Text Label 5900 4400 0    40   ~ 0
Rpi_SCLK
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
	1    7250 3900
	1    0    0    -1  
$EndComp
$Comp
L TSX0108 U?
U 1 1 4FD5DAA4
P 3600 2575
F 0 "U?" H 3600 2975 40  0000 C CNN
F 1 "TSX0108" H 3600 2875 40  0000 C CNN
	1    3600 2575
	1    0    0    -1  
$EndComp
Text HLabel 1500 2000 0    40   BiDi ~ 0
3V3
Text Label 1750 2000 0    40   ~ 0
3V3
Text Label 1750 2200 0    40   ~ 0
TXD
Text Label 1750 2300 0    40   ~ 0
RXD
Text Label 1750 3300 0    40   ~ 0
GND
Text HLabel 1500 3300 0    40   BiDi ~ 0
GND
Text HLabel 1500 2200 0    40   Input ~ 0
TXD
Text HLabel 1500 2300 0    40   Output ~ 0
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
NoConn ~ 6600 3300
Text Label 8200 3500 0    40   ~ 0
GND
Text Label 8200 3700 0    40   ~ 0
Rpi_Rx
Text Label 8200 3600 0    40   ~ 0
Rpi_Tx
Text HLabel 1500 2700 0    40   Input ~ 0
SCL
Text HLabel 1500 2600 0    40   Input ~ 0
SDA
Text Label 1750 2700 0    40   ~ 0
SCL
Text Label 1750 2600 0    40   ~ 0
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
	1    10700 4200
	1    0    0    -1  
$EndComp
$Comp
L CONN_8 P2
U 1 1 4FBF744D
P 9850 4150
F 0 "P2" H 9800 4600 60  0000 C CNN
F 1 "GPU_JTAG" V 9900 4150 60  0000 C CNN
	1    9850 4150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
