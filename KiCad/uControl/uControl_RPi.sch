EESchema Schematic File Version 2  date 2/5/2013 3:30:20 PM
LIBS:uControl
LIBS:Conn-raspberry
LIBS:power
LIBS:uControl_v1-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 5 5
Title "uControl"
Date "5 feb 2013"
Rev "1"
Comp "WyoLum"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L BCM2835_GPIO P27
U 1 1 50E3D62C
P 7250 4700
F 0 "P27" H 7250 5400 60  0000 C CNN
F 1 "BCM2835_GPIO" V 7250 4700 50  0000 C CNN
F 2 "Header_GPIO" V 7350 4700 50  0001 C CNN
F 4 "CONN HEADER FMAL 26PS .1\" DL TIN" H 7250 5500 60  0001 L CNN "Field4"
F 5 "Header, Female Socket" H 7250 5600 60  0001 L CNN "Field5"
F 6 "0.1\", 2 row" H 7250 5700 60  0001 L CNN "Field6"
F 7 "Sullins Connector Solutions" H 7250 5800 60  0001 L CNN "Field7"
F 8 "PPTC132LFBN-RC" H 7250 5900 60  0001 L CNN "Field8"
F 9 "Digikey" H 7250 6000 60  0001 L CNN "Field9"
F 10 "S7081-ND" H 7250 6100 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/PPTC132LFBN-RC/S7081-ND/810219" H 7250 6200 60  0001 L CNN "Field11"
	1    7250 4700
	1    0    0    -1  
$EndComp
$Comp
L TSX0108 U6
U 1 1 50E2BD02
P 3600 2575
F 0 "U6" H 3600 2975 40  0000 C CNN
F 1 "TSX0108" H 3600 2875 40  0000 C CNN
F 2 "TXS0108EPWR" H 3600 2975 40  0001 C CNN
F 4 "IC 8BIT NON-INV TRANSLTR 20TSSOP" H 3600 3075 60  0001 L CNN "Field4"
F 5 "Translator, Bidirectional, Open Drain" H 3600 3175 60  0001 L CNN "Field5"
F 6 "20-TSSOP (0.173\", 4.40mm Width)" H 3600 3275 60  0001 L CNN "Field6"
F 7 "Texas Instruments" H 3600 3375 60  0001 L CNN "Field7"
F 8 "TXS0108EPWR" H 3600 3475 60  0001 L CNN "Field8"
F 9 "Digikey" H 3600 3575 60  0001 L CNN "Field9"
F 10 "296-23011-1-ND" H 3600 3675 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/TXS0108EPWR/296-23011-1-ND/1775304" H 3600 3775 60  0001 L CNN "Field11"
	1    3600 2575
	-1   0    0    -1  
$EndComp
$Comp
L R_10K R12
U 1 1 50E2B89D
P 5625 1625
F 0 "R12" H 5525 1775 50  0000 C CNN
F 1 "10K" V 5630 1625 50  0000 C CNN
F 2 "rc03_vert" V 5730 1625 50  0001 C CNN
F 4 "RES 10K OHM 1/8W 5% CF AXIAL" H 5625 1725 60  0001 L CNN "Field4"
F 5 "0.125W, 1/8W" H 5625 1825 60  0001 L CNN "Field5"
F 6 "Axial" H 5625 1925 60  0001 L CNN "Field6"
F 7 "Stackpole Electronics Inc" H 5625 2025 60  0001 L CNN "Field7"
F 8 "CF18JT10K0" H 5625 2125 60  0001 L CNN "Field8"
F 9 "Digikey" H 5625 2225 60  0001 L CNN "Field9"
F 10 "CF18JT10K0CT-ND" H 5625 2325 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/CF18JT10K0/CF18JT10K0CT-ND/2022766?cur=USD" H 5625 2425 60  0001 L CNN "Field11"
	1    5625 1625
	1    0    0    -1  
$EndComp
$Comp
L C C25
U 1 1 50E29596
P 2300 1850
F 0 "C25" H 2300 1950 50  0000 L CNN
F 1 "100n" H 2300 1750 50  0000 L CNN
F 2 "C2" H 2300 1850 50  0001 C CNN
F 4 "CAP FILM 0.1UF 63VDC RADIAL" H 2300 2050 60  0001 L CNN "Field4"
F 5 "100nF, 63V" H 2300 2150 60  0001 L CNN "Field5"
F 6 "R82" H 2300 2250 60  0001 L CNN "Field6"
F 7 "Kemet" H 2300 2350 60  0001 L CNN "Field7"
F 8 "R82DC3100AA50J" H 2300 2450 60  0001 L CNN "Field8"
F 9 "Digikey" H 2300 2550 60  0001 L CNN "Field9"
F 10 "399-5863-ND" H 2300 2650 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/R82DC3100AA50J/399-5863-ND/2571298?cur=USD" H 2300 2750 60  0001 L CNN "Field11"
	1    2300 1850
	-1   0    0    1   
$EndComp
$Comp
L C C24
U 1 1 50E29581
P 1925 1850
F 0 "C24" H 1925 1950 50  0000 L CNN
F 1 "100n" H 1925 1750 50  0000 L CNN
F 2 "C2" H 1925 1850 50  0001 C CNN
F 4 "CAP FILM 0.1UF 63VDC RADIAL" H 1925 2050 60  0001 L CNN "Field4"
F 5 "100nF, 63V" H 1925 2150 60  0001 L CNN "Field5"
F 6 "R82" H 1925 2250 60  0001 L CNN "Field6"
F 7 "Kemet" H 1925 2350 60  0001 L CNN "Field7"
F 8 "R82DC3100AA50J" H 1925 2450 60  0001 L CNN "Field8"
F 9 "Digikey" H 1925 2550 60  0001 L CNN "Field9"
F 10 "399-5863-ND" H 1925 2650 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/R82DC3100AA50J/399-5863-ND/2571298?cur=USD" H 1925 2750 60  0001 L CNN "Field11"
	1    1925 1850
	-1   0    0    1   
$EndComp
Connection ~ 6300 4100
Wire Wire Line
	6300 4000 6300 4100
Wire Wire Line
	7400 3225 8000 3225
Wire Wire Line
	8000 3225 8000 3550
Wire Wire Line
	8000 3550 7850 3550
Connection ~ 5625 1325
Connection ~ 5850 1925
Wire Wire Line
	5850 1925 5625 1925
Wire Wire Line
	5625 1925 5625 1875
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
	3750 1475 2300 1475
Wire Wire Line
	7900 4600 8700 4600
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
	4800 3075 4800 5200
Wire Wire Line
	4800 5200 6600 5200
Wire Wire Line
	3950 2875 5000 2875
Wire Wire Line
	5000 2875 5000 5000
Wire Wire Line
	5000 5000 6600 5000
Wire Wire Line
	3950 2675 8600 2675
Wire Wire Line
	8600 2675 8600 4500
Wire Wire Line
	8600 4500 7900 4500
Wire Wire Line
	3950 2475 5100 2475
Wire Wire Line
	5100 2475 5100 4300
Wire Wire Line
	5100 4300 6600 4300
Wire Wire Line
	8200 4300 7900 4300
Wire Wire Line
	3950 2375 5200 2375
Wire Wire Line
	5200 2375 5200 4200
Wire Wire Line
	5200 4200 6600 4200
Wire Wire Line
	7900 4400 8500 4400
Wire Wire Line
	8500 4400 8500 2575
Wire Wire Line
	8500 2575 3950 2575
Wire Wire Line
	8700 4600 8700 2775
Wire Wire Line
	8700 2775 3950 2775
Wire Wire Line
	3950 2975 4900 2975
Wire Wire Line
	4900 2975 4900 5100
Wire Wire Line
	4900 5100 6600 5100
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
	5900 4100 6600 4100
Wire Wire Line
	5950 1425 5850 1425
Wire Wire Line
	5850 1425 5850 2050
Wire Wire Line
	5950 1325 5225 1325
Wire Wire Line
	5225 1325 5225 2175
Wire Wire Line
	5225 2175 3950 2175
Wire Wire Line
	7900 4100 8000 4100
Wire Wire Line
	8000 4100 8000 3650
Wire Wire Line
	8000 3650 7850 3650
Wire Wire Line
	5625 1375 5625 1325
Wire Wire Line
	5950 1225 5525 1225
$Comp
L PWR_FLAG #FLG025
U 1 1 50E00A24
P 6300 4000
F 0 "#FLG025" H 6300 4270 30  0001 C CNN
F 1 "PWR_FLAG" H 6300 4230 30  0000 C CNN
	1    6300 4000
	1    0    0    -1  
$EndComp
Text Label 5525 1225 0    40   ~ 0
Rpi_3V3
Text Notes 1850 4750 0    40   ~ 0
Mounting Holes\nfor Raspberry-Pi
$Comp
L SCREW SC26
U 1 1 50DD59EB
P 2200 4950
F 0 "SC26" H 2200 4850 40  0000 C CNN
F 1 "SCREW" H 2200 5050 40  0001 C CNN
F 2 "vite_3mm" H 2200 5150 40  0001 C CNN
	1    2200 4950
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC25
U 1 1 50DD59E1
P 1950 4950
F 0 "SC25" H 1950 4850 40  0000 C CNN
F 1 "SCREW" H 1950 5050 40  0001 C CNN
F 2 "vite_3mm" H 1950 5150 40  0001 C CNN
	1    1950 4950
	1    0    0    -1  
$EndComp
NoConn ~ 7850 3750
$Comp
L CONN_3 P26
U 1 1 500FBDD3
P 7500 3650
F 0 "P26" V 7450 3650 50  0000 C CNN
F 1 "5V_LINK" V 7550 3650 50  0000 C CNN
F 2 "Header_U6OE" H 7350 3850 50  0001 C CNN
	1    7500 3650
	-1   0    0    -1  
$EndComp
Text Label 8000 3650 0    40   ~ 0
Rpi_5V0
Text Notes 6450 3550 0    40   Italic 8
allows hooking up Ras-Pi 5V \nto uControl
Text Label 7400 3225 0    40   ~ 0
5V0
Text Notes 6450 1250 0    60   Italic 12
this jumper enables/disables the Voltage Translator U6, \nthereby allowing/dis-allowing communication \nbetween the Raspberry-Pi and a La Mode\nEDIT:Permanenty shorted(23-08-2012)
Text Label 4150 2175 0    40   ~ 0
Rpi_OE
$Comp
L GND #PWR026
U 1 1 4FD8C28A
P 5850 2050
F 0 "#PWR026" H 5850 2050 30  0001 C CNN
F 1 "GND" H 5850 1980 30  0001 C CNN
	1    5850 2050
	1    0    0    -1  
$EndComp
$Comp
L CONN_3 P25
U 1 1 4FD8C245
P 6300 1325
F 0 "P25" V 6250 1325 50  0000 C CNN
F 1 "U6_OE" V 6350 1325 50  0000 C CNN
F 2 "pin_strip_3-90" H 6300 1275 60  0001 C CNN
	1    6300 1325
	1    0    0    -1  
$EndComp
Text Label 5900 4100 0    40   ~ 0
Rpi_3V3
$Comp
L GND #PWR027
U 1 1 4FD62C0F
P 2125 2175
F 0 "#PWR027" H 2125 2175 30  0001 C CNN
F 1 "GND" H 2125 2105 30  0001 C CNN
	1    2125 2175
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR028
U 1 1 4FD62BFD
P 2125 3600
F 0 "#PWR028" H 2125 3600 30  0001 C CNN
F 1 "GND" H 2125 3530 30  0001 C CNN
	1    2125 3600
	1    0    0    -1  
$EndComp
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
~MOSI
Text HLabel 1500 2875 0    40   Input ~ 0
~MOSI
Text HLabel 1500 2775 0    40   Output ~ 0
RESET
Text Label 2850 2775 0    40   ~ 0
RESET
Text HLabel 1500 1575 0    40   BiDi ~ 0
5V0
Text Label 5900 5200 0    40   ~ 0
Rpi_SCK
Text Label 5900 5100 0    40   ~ 0
Rpi_MISO
Text Label 5900 5000 0    40   ~ 0
Rpi_MOSI
Text Label 8200 4600 0    40   ~ 0
Rpi_RST
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
NoConn ~ 7900 4800
NoConn ~ 7900 4900
NoConn ~ 7900 5100
NoConn ~ 7900 5300
NoConn ~ 7900 5200
NoConn ~ 6600 4800
NoConn ~ 6600 4700
NoConn ~ 6600 4600
NoConn ~ 6600 4400
Text Label 8200 4300 0    40   ~ 0
GND
Text Label 8200 4500 0    40   ~ 0
Rpi_Rx
Text Label 8200 4400 0    40   ~ 0
Rpi_Tx
Text HLabel 1500 2475 0    40   Input ~ 0
SCL
Text HLabel 1500 2375 0    40   Input ~ 0
SDA
Text Label 2850 2475 0    40   ~ 0
SCL
Text Label 2850 2375 0    40   ~ 0
SDA
Text Label 5900 4300 0    40   ~ 0
Rpi_SCL
Text Label 5900 4200 0    40   ~ 0
Rpi_SDA
Text Notes 6900 5550 0    60   Italic 12
NOTE : GPIO voltage levels are 3v3 and are not 5v tolerant.
NoConn ~ 7900 4200
NoConn ~ 7900 4700
NoConn ~ 7900 5000
NoConn ~ 6600 5300
NoConn ~ 6600 4900
NoConn ~ 6600 4500
$EndSCHEMATC
