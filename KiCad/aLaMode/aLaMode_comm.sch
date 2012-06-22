EESchema Schematic File Version 2  date 6/22/2012 6:23:59 PM
LIBS:aLaMode
LIBS:power
LIBS:aLaMode_v1-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 2 5
Title ""
Date "22 jun 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Connection ~ 4500 2550
Wire Wire Line
	4500 2450 4500 4400
Wire Wire Line
	6250 3800 6800 3800
Wire Wire Line
	3450 6075 2175 6075
Connection ~ 4500 4900
Wire Wire Line
	4500 4800 4500 4900
Connection ~ 3150 4100
Connection ~ 4150 4100
Wire Wire Line
	3150 4100 4150 4100
Wire Wire Line
	7150 4900 2550 4900
Wire Wire Line
	7150 4900 7150 4650
Wire Wire Line
	7150 4650 7500 4650
Wire Wire Line
	7500 3550 6250 3550
Wire Wire Line
	7500 3350 6250 3350
Wire Wire Line
	6250 3150 7500 3150
Wire Wire Line
	7500 2950 6250 2950
Connection ~ 5600 2150
Wire Wire Line
	5600 2250 5600 2150
Connection ~ 5300 4900
Wire Wire Line
	5300 4900 5300 4250
Wire Wire Line
	5750 2100 5750 2150
Wire Wire Line
	5750 2150 5450 2150
Wire Wire Line
	5450 2150 5450 2100
Connection ~ 5750 1600
Wire Wire Line
	5750 1600 5750 1650
Connection ~ 2850 4900
Wire Wire Line
	2850 4800 2850 4900
Connection ~ 3650 3150
Wire Wire Line
	3650 4400 3650 3150
Connection ~ 3650 4900
Wire Wire Line
	3650 4900 3650 4800
Connection ~ 8250 1600
Wire Wire Line
	8250 1600 8250 2600
Wire Wire Line
	8500 3200 8500 3100
Connection ~ 3150 4900
Wire Wire Line
	2550 4900 2550 3350
Wire Wire Line
	2550 3350 2150 3350
Wire Wire Line
	3150 4350 3150 3800
Wire Wire Line
	3950 3250 2150 3250
Wire Wire Line
	4450 3250 4650 3250
Wire Wire Line
	6250 4000 8500 4000
Wire Wire Line
	8500 4000 8500 3600
Wire Wire Line
	4150 4900 4150 4800
Wire Wire Line
	4650 3450 4150 3450
Wire Wire Line
	4500 2550 5600 2550
Wire Wire Line
	5600 2550 5600 2650
Wire Wire Line
	5300 2650 5300 1600
Wire Wire Line
	3450 5675 2900 5675
Wire Wire Line
	2900 5675 2900 5625
Wire Wire Line
	2900 5625 2850 5625
Wire Wire Line
	3450 5775 2175 5775
Wire Wire Line
	3450 6175 2175 6175
Wire Wire Line
	3450 5975 2175 5975
Wire Wire Line
	3475 6775 2175 6775
Wire Wire Line
	3475 6975 2175 6975
Wire Wire Line
	3475 7175 2175 7175
Wire Wire Line
	2175 7275 3475 7275
Wire Wire Line
	3475 7075 2175 7075
Wire Wire Line
	3475 6875 2175 6875
Wire Wire Line
	3450 5875 2175 5875
Wire Wire Line
	2450 5625 2400 5625
Wire Wire Line
	2400 5625 2400 5675
Wire Wire Line
	2400 5675 2175 5675
Wire Wire Line
	4500 2850 4650 2850
Wire Wire Line
	4150 3450 4150 4400
Wire Wire Line
	8250 3600 8250 3900
Wire Wire Line
	8250 3900 6250 3900
Wire Wire Line
	4450 3150 4650 3150
Wire Wire Line
	2150 3150 3950 3150
Wire Wire Line
	3150 3300 3150 3050
Wire Wire Line
	3150 3050 2150 3050
Wire Wire Line
	3150 4900 3150 4850
Wire Wire Line
	8250 3200 8250 3100
Wire Wire Line
	2150 1600 8500 1600
Wire Wire Line
	8500 1600 8500 2600
Connection ~ 5300 1600
Wire Wire Line
	3900 4900 3900 4800
Connection ~ 3900 4900
Wire Wire Line
	3900 4400 3900 3250
Connection ~ 3900 3250
Wire Wire Line
	2850 4400 2850 3050
Connection ~ 2850 3050
Wire Wire Line
	5450 1600 5450 1700
Connection ~ 5450 1600
Connection ~ 4150 4900
Wire Wire Line
	5600 5050 5600 4250
Connection ~ 5600 4900
Wire Wire Line
	6250 2850 7500 2850
Wire Wire Line
	6250 3050 7500 3050
Wire Wire Line
	6250 3250 7500 3250
Wire Wire Line
	6250 3450 7500 3450
Wire Wire Line
	7150 3150 7150 4450
Wire Wire Line
	7150 4450 7500 4450
Connection ~ 7150 3150
Connection ~ 4500 2850
Wire Wire Line
	6250 4100 6800 4100
$Comp
L PWR_FLAG #FLG05
U 1 1 4FE46AB8
P 4500 2450
F 0 "#FLG05" H 4500 2720 30  0001 C CNN
F 1 "PWR_FLAG" H 4500 2680 30  0000 C CNN
	1    4500 2450
	1    0    0    -1  
$EndComp
Text Label 6600 4100 0    40   ~ 0
CBUS3
Text Label 6600 3800 0    40   ~ 0
CBUS0
$Comp
L I/O B4
U 1 1 4FE468C3
P 6950 4100
F 0 "B4" H 7030 4100 40  0000 L CNN
F 1 "I/O" H 6950 4155 30  0001 C CNN
	1    6950 4100
	1    0    0    -1  
$EndComp
$Comp
L I/O B1
U 1 1 4FE468BD
P 6950 3800
F 0 "B1" H 7030 3800 40  0000 L CNN
F 1 "I/O" H 6950 3855 30  0001 C CNN
	1    6950 3800
	1    0    0    -1  
$EndComp
Text Label 2175 6075 0    40   ~ 0
~CTS
Text Label 3000 5675 0    40   ~ 0
~RTS
Text HLabel 2175 7075 0    40   Input ~ 0
MOSI
Text HLabel 2175 6975 0    40   Input ~ 0
SCK
Text HLabel 2175 6775 0    40   Input ~ 0
MISO
Text HLabel 2175 5875 0    40   Input ~ 0
RXD
Text HLabel 2175 5775 0    40   Input ~ 0
TXD
Text HLabel 2175 5675 0    40   Input ~ 0
RESET
$Comp
L C C21
U 1 1 4FE46431
P 4500 4600
F 0 "C21" H 4350 4700 50  0000 L CNN
F 1 "100nF" H 4250 4500 50  0000 L CNN
	1    4500 4600
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P14
U 1 1 4FE45898
P 7850 4550
F 0 "P14" V 7800 4550 40  0000 C CNN
F 1 "CTS<>GND" V 7900 4550 40  0000 C CNN
	1    7850 4550
	1    0    0    -1  
$EndComp
Text Label 6600 3550 0    40   ~ 0
~RI
Text Label 6600 3450 0    40   ~ 0
~DCD
Text Label 6600 3350 0    40   ~ 0
~DSR
Text Label 6600 3250 0    40   ~ 0
~DTR
Text Label 6600 3150 0    40   ~ 0
~CTS
Text Label 6600 3050 0    40   ~ 0
~RTS
Text Label 6600 2950 0    40   ~ 0
RXD
Text Label 6600 2850 0    40   ~ 0
TXD
Text HLabel 2150 3350 0    40   Input ~ 0
GND
Text HLabel 2150 3250 0    40   Input ~ 0
USBD+
Text HLabel 2150 3150 0    40   Input ~ 0
USBD-
Text HLabel 2150 3050 0    40   Input ~ 0
USBVCC
$Comp
L CONN_8 P13
U 1 1 4FE456C7
P 7850 3200
F 0 "P13" V 7800 3200 60  0000 C CNN
F 1 "FT231X_OUT" V 7900 3200 60  0000 C CNN
	1    7850 3200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 4FE45678
P 5600 2250
F 0 "#PWR06" H 5600 2250 30  0001 C CNN
F 1 "GND" H 5600 2180 30  0001 C CNN
	1    5600 2250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 4FE4565F
P 5600 5050
F 0 "#PWR07" H 5600 5050 30  0001 C CNN
F 1 "GND" H 5600 4980 30  0001 C CNN
	1    5600 5050
	1    0    0    -1  
$EndComp
$Comp
L C_POL C23
U 1 1 4FE4562A
P 5750 1850
F 0 "C23" H 5875 1775 50  0000 L CNN
F 1 "4u7" H 5875 1700 50  0000 L CNN
	1    5750 1850
	1    0    0    -1  
$EndComp
$Comp
L C C22
U 1 1 4FE45609
P 5450 1900
F 0 "C22" H 5475 1800 50  0000 L CNN
F 1 "100nF" H 5475 1725 50  0000 L CNN
	1    5450 1900
	1    0    0    -1  
$EndComp
$Comp
L C C17
U 1 1 4FE455E4
P 2850 4600
F 0 "C17" H 2700 4700 50  0000 L CNN
F 1 "10nF" H 2625 4500 50  0000 L CNN
	1    2850 4600
	1    0    0    -1  
$EndComp
$Comp
L C C18
U 1 1 4FE45531
P 3650 4600
F 0 "C18" H 3475 4700 50  0000 L CNN
F 1 "47p" H 3500 4500 50  0000 L CNN
F 4 "490-1734-1-ND" H 3650 4800 60  0001 C CNN "Digikey"
	1    3650 4600
	1    0    0    -1  
$EndComp
$Comp
L C C19
U 1 1 4FE4552A
P 3900 4600
F 0 "C19" H 3750 4700 50  0000 L CNN
F 1 "47p" H 3750 4500 50  0000 L CNN
F 4 "490-1734-1-ND" H 3900 4800 60  0001 C CNN "Digikey"
	1    3900 4600
	1    0    0    -1  
$EndComp
Text Label 3200 4100 0    40   ~ 0
VBUS_SENSE
Text Label 2150 3350 0    40   ~ 0
GND
Text Label 2150 3050 0    40   ~ 0
USBVCC
Text Label 2150 3250 0    40   ~ 0
USBD+
Text Label 2150 3150 0    40   ~ 0
USBD-
Text Label 6600 4000 0    40   ~ 0
TxLED
Text Label 6600 3900 0    40   ~ 0
RxLED
$Comp
L R R19
U 1 1 4FE4541E
P 8500 2850
F 0 "R19" V 8580 2850 50  0000 C CNN
F 1 "270E" V 8500 2850 50  0000 C CNN
	1    8500 2850
	-1   0    0    1   
$EndComp
$Comp
L R R18
U 1 1 4FE4541A
P 8250 2850
F 0 "R18" V 8330 2850 50  0000 C CNN
F 1 "270E" V 8250 2850 50  0000 C CNN
	1    8250 2850
	-1   0    0    1   
$EndComp
$Comp
L LED D10
U 1 1 4FE45412
P 8500 3400
F 0 "D10" H 8500 3500 50  0000 C CNN
F 1 "LED" H 8500 3300 50  0000 C CNN
	1    8500 3400
	0    1    1    0   
$EndComp
$Comp
L LED D9
U 1 1 4FE45407
P 8250 3400
F 0 "D9" H 8250 3500 50  0000 C CNN
F 1 "LED" H 8250 3300 50  0000 C CNN
	1    8250 3400
	0    1    1    0   
$EndComp
$Comp
L R R15
U 1 1 4FE45275
P 3150 4600
F 0 "R15" V 3230 4600 50  0000 C CNN
F 1 "15k" V 3150 4600 50  0000 C CNN
	1    3150 4600
	-1   0    0    1   
$EndComp
$Comp
L R R14
U 1 1 4FE4526D
P 3150 3550
F 0 "R14" V 3230 3550 50  0000 C CNN
F 1 "10k" V 3150 3550 50  0000 C CNN
	1    3150 3550
	-1   0    0    1   
$EndComp
$Comp
L R R17
U 1 1 4FE45259
P 4200 3250
F 0 "R17" V 4100 3250 50  0000 C CNN
F 1 "27E" V 4200 3250 50  0000 C CNN
	1    4200 3250
	0    -1   -1   0   
$EndComp
$Comp
L R R16
U 1 1 4FE45251
P 4200 3150
F 0 "R16" V 4280 3150 50  0000 C CNN
F 1 "27E" V 4200 3150 50  0000 C CNN
	1    4200 3150
	0    -1   -1   0   
$EndComp
$Comp
L C C20
U 1 1 4FE4520E
P 4150 4600
F 0 "C20" H 4000 4700 50  0000 L CNN
F 1 "10nF" H 3950 4500 50  0000 L CNN
	1    4150 4600
	1    0    0    -1  
$EndComp
Text HLabel 2150 1600 0    60   Input ~ 0
5V0
Text Label 2150 1600 0    40   ~ 0
5V0
$Comp
L FT231XS U7
U 1 1 4FE450CA
P 5450 3450
F 0 "U7" H 4800 2700 60  0000 C CNN
F 1 "FT231XS" H 4950 2800 60  0000 C CNN
	1    5450 3450
	1    0    0    -1  
$EndComp
$Comp
L CONN_6 P8
U 1 1 4FE44C6C
P 3800 5925
F 0 "P8" V 3750 5925 60  0000 C CNN
F 1 "FTDI" V 3850 5925 60  0000 C CNN
F 2 "Header_FTDI" H 3800 5925 60  0001 C CNN
	1    3800 5925
	1    0    0    1   
$EndComp
$Comp
L C C7
U 1 1 4FE44C6B
P 2650 5625
F 0 "C7" V 2600 5700 50  0000 L CNN
F 1 "100n" V 2525 5700 50  0000 L CNN
F 2 "c_0805" H 2650 5625 60  0001 C CNN
	1    2650 5625
	0    1    1    0   
$EndComp
Text Label 2175 5675 0    40   ~ 0
RESET
Text Label 2175 5875 0    40   ~ 0
RXD
Text Label 2175 5775 0    40   ~ 0
TXD
Text Label 2175 6175 0    40   ~ 0
GND
$Comp
L ISP P9
U 1 1 4FE44C6A
P 3825 7025
F 0 "P9" V 3775 7025 60  0000 C CNN
F 1 "ICSP" V 3875 7025 60  0000 C CNN
F 2 "Header_ICSP" H 3825 7025 60  0001 C CNN
	1    3825 7025
	1    0    0    -1  
$EndComp
Text Label 2175 7175 0    40   ~ 0
RESET
Text Label 2175 7075 0    40   ~ 0
MOSI
Text Label 2175 6975 0    40   ~ 0
SCK
Text Label 2175 6875 0    40   ~ 0
5V0
Text Label 2175 6775 0    40   ~ 0
MISO
Text Label 2175 5975 0    40   ~ 0
USBVCC
Text Label 2175 7275 0    40   ~ 0
GND
Text Notes 2500 6650 2    60   Italic 12
ISP Header
Text Notes 2550 5450 2    60   Italic 12
FTDI Header
$EndSCHEMATC
