EESchema Schematic File Version 2  date 12-Mar-13 6:22:36 PM
LIBS:power
LIBS:smartRGB_sym
LIBS:Equinox-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 2 2
Title ""
Date "12 mar 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	5450 2700 4450 2700
Wire Wire Line
	4450 2700 4450 2450
Wire Wire Line
	7600 1000 8150 1000
Wire Wire Line
	8150 1000 8150 1150
Connection ~ 7900 1800
Wire Wire Line
	7900 1550 7900 2600
Connection ~ 7250 2500
Wire Wire Line
	2000 1700 7250 1700
Wire Wire Line
	1700 3950 2050 3950
Wire Wire Line
	1700 4150 2050 4150
Wire Wire Line
	2000 1100 2350 1100
Wire Wire Line
	2000 900  2350 900 
Wire Wire Line
	7900 2600 7050 2600
Wire Wire Line
	7900 1800 2000 1800
Wire Wire Line
	4750 2450 4750 2600
Wire Wire Line
	4750 2600 5450 2600
Connection ~ 5400 3850
Wire Wire Line
	2500 6900 2900 6900
Wire Wire Line
	2500 6700 2900 6700
Wire Wire Line
	2500 6500 2900 6500
Wire Wire Line
	5450 2500 4950 2500
Wire Wire Line
	5450 2800 5400 2800
Wire Wire Line
	5400 2800 5400 3850
Wire Wire Line
	7250 3550 7250 3850
Wire Wire Line
	3750 3850 3750 3950
Wire Wire Line
	7050 2700 7450 2700
Wire Wire Line
	2900 6400 2500 6400
Wire Wire Line
	2900 6600 2500 6600
Wire Wire Line
	2900 6800 2500 6800
Wire Notes Line
	2200 7000 3400 7000
Wire Notes Line
	2200 7000 2200 6100
Wire Notes Line
	2200 6100 3400 6100
Wire Notes Line
	3400 6100 3400 7000
Wire Wire Line
	2000 2000 3100 2000
Connection ~ 3750 3850
Wire Wire Line
	3100 2000 3100 3850
Wire Wire Line
	3100 3850 7250 3850
Wire Wire Line
	2000 1900 8150 1900
Wire Wire Line
	7050 2800 8150 2800
Wire Wire Line
	2350 1000 2000 1000
Wire Wire Line
	2350 1200 2000 1200
Wire Wire Line
	2050 4350 1700 4350
Wire Wire Line
	7050 2500 7250 2500
Wire Wire Line
	7250 1700 7250 3150
Wire Wire Line
	8150 2800 8150 1550
Connection ~ 8150 1900
Wire Wire Line
	7900 1150 7900 1000
Connection ~ 7900 1000
Text Label 7600 1000 0    40   ~ 0
5V
$Comp
L RESISTOR R2
U 1 1 51384E25
P 8150 1350
F 0 "R2" H 8150 1350 40  0000 C CNN
F 1 "10k" H 8150 1450 40  0000 C CNN
	1    8150 1350
	0    -1   -1   0   
$EndComp
$Comp
L RESISTOR R1
U 1 1 51384E1E
P 7900 1350
F 0 "R1" H 7900 1350 40  0000 C CNN
F 1 "10k" H 7900 1450 40  0000 C CNN
	1    7900 1350
	0    -1   -1   0   
$EndComp
Text Label 2050 3950 0    40   ~ 0
Data_In
Text HLabel 1700 3950 0    40   Input ~ 0
Data_In
Text Label 2050 4350 0    40   ~ 0
GND
Text Label 2050 4150 0    40   ~ 0
5V
Text HLabel 1700 4350 0    40   Input ~ 0
GND
Text HLabel 1700 4150 0    40   Input ~ 0
5V
Text Label 2350 1200 0    40   ~ 0
GND
Text Label 2350 1100 0    40   ~ 0
MOSI_SDA
Text Label 2350 1000 0    40   ~ 0
SCK_SCL
Text Label 2350 900  0    40   ~ 0
5V
$Comp
L CONN_N P12
U 1 1 50ED55F7
P 1650 1050
F 0 "P12" V 1600 1050 50  0000 C CNN
F 1 "C3SB_Out" V 1700 1050 50  0000 C CNN
F 4 "CONN HEADER 16POS .100 R/A 30AU" H 1650 1150 60  0001 L CNN "Field4"
F 5 "Header, Unshrouded, Male pin," H 1650 1250 60  0001 L CNN "Field5"
F 6 "0.1\" right angle" H 1650 1350 60  0001 L CNN "Field6"
F 7 "FCI" H 1650 1450 60  0001 L CNN "Field7"
F 8 "68016-116HLF" H 1650 1550 60  0001 L CNN "Field8"
F 9 "Digikey" H 1650 1650 60  0001 L CNN "Field9"
F 10 "609-3317-ND" H 1650 1750 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/68016-116HLF/609-3317-ND/1878554" H 1650 1850 60  0001 L CNN "Field11"
	1    1650 1050
	-1   0    0    -1  
$EndComp
$Comp
L ISP P11
U 1 1 50ED5151
P 3250 6650
F 0 "P11" V 3200 6650 60  0000 C CNN
F 1 "ISP" V 3300 6650 60  0000 C CNN
F 4 "CONN HEADER 6POS .100 STR 15AU" H 3250 6750 60  0001 L CNN "Field4"
F 5 "Header, Unshrouded, Male Pin" H 3250 6850 60  0001 L CNN "Field5"
F 6 "6 pos, 2 row, 0.1\"" H 3250 6950 60  0001 L CNN "Field6"
F 7 "FCI" H 3250 7050 60  0001 L CNN "Field7"
F 8 "67996-206HLF" H 3250 7150 60  0001 L CNN "Field8"
F 9 "Digikey" H 3250 7250 60  0001 L CNN "Field9"
F 10 "609-3210-ND" H 3250 7350 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/scripts/DkSearch/dksus.dll?vendor=0&keywords=609-3210-ND" H 3250 7450 60  0001 L CNN "Field11"
	1    3250 6650
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 PB3
U 1 1 50ED4EBA
P 4750 2300
F 0 "PB3" V 4825 2250 40  0000 L CNN
F 1 "PB3" H 4750 2355 30  0001 C CNN
	1    4750 2300
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P10
U 1 1 50ED4EA5
P 4450 2300
F 0 "P10" V 4525 2250 40  0000 L CNN
F 1 "Data_In" H 4450 2355 30  0001 C CNN
	1    4450 2300
	0    -1   -1   0   
$EndComp
$Comp
L C2 C18
U 1 1 50ED4B91
P 7250 3350
F 0 "C18" H 7250 3450 50  0000 L CNN
F 1 "100n" H 7250 3250 50  0000 L CNN
F 4 "CAP CER 0.1UF 25V 10% X7R 0805" H 7250 3550 60  0001 L CNN "Field4"
F 5 "100nF, 25V" H 7250 3650 60  0001 L CNN "Field5"
F 6 "Surface Mount, MLCC" H 7250 3750 60  0001 L CNN "Field6"
F 7 "Kemet" H 7250 3850 60  0001 L CNN "Field7"
F 8 "C0805C104K3RACTU" H 7250 3950 60  0001 L CNN "Field8"
F 9 "Digikey" H 7250 4050 60  0001 L CNN "Field9"
F 10 "399-1168-1-ND" H 7250 4150 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/C0805C104K3RACTU/399-1168-1-ND/411443" H 7250 4250 60  0001 L CNN "Field11"
	1    7250 3350
	1    0    0    -1  
$EndComp
Text Label 2350 1700 0    40   ~ 0
5V
Text Label 2350 2000 0    40   ~ 0
GND
Text Label 2350 1900 0    40   ~ 0
MOSI_SDA
Text Label 2350 1800 0    40   ~ 0
SCK_SCL
$Comp
L CONN_N P9
U 1 1 50ED4827
P 1650 1850
F 0 "P9" V 1600 1850 50  0000 C CNN
F 1 "C3SB_In" V 1700 1850 50  0000 C CNN
F 4 "CONN HEADER 16POS .100 R/A 30AU" H 1650 1950 60  0001 L CNN "Field4"
F 5 "Header, Unshrouded, Male pin," H 1650 2050 60  0001 L CNN "Field5"
F 6 "0.1\" right angle" H 1650 2150 60  0001 L CNN "Field6"
F 7 "FCI" H 1650 2250 60  0001 L CNN "Field7"
F 8 "68016-116HLF" H 1650 2350 60  0001 L CNN "Field8"
F 9 "Digikey" H 1650 2450 60  0001 L CNN "Field9"
F 10 "609-3317-ND" H 1650 2550 60  0001 L CNN "Field10"
F 11 "http://www.digikey.com/product-detail/en/68016-116HLF/609-3317-ND/1878554" H 1650 2650 60  0001 L CNN "Field11"
	1    1650 1850
	-1   0    0    -1  
$EndComp
Text Label 2500 6700 2    40   ~ 0
MOSI_SDA
Text Label 2500 6900 2    40   ~ 0
GND
Text Label 2500 6500 2    40   ~ 0
5V
Text Label 2500 6800 2    40   ~ 0
RST
Text Label 2500 6600 2    40   ~ 0
SCK_SCL
Text Label 2500 6400 2    40   ~ 0
MISO
Text Notes 2325 6225 0    60   Italic 12
ISP
$Comp
L ATTINY85 U19
U 1 1 50ED42DB
P 6250 2650
F 0 "U19" H 5650 2950 50  0000 L BNN
F 1 "ATTINY45-20SU" H 5650 2300 50  0000 L BNN
F 2 "SO8E" H 6750 2225 50  0001 C CNN
	1    6250 2650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 50ED42DA
P 3750 3950
F 0 "#PWR04" H 3750 3950 30  0001 C CNN
F 1 "GND" H 3750 3880 30  0001 C CNN
	1    3750 3950
	1    0    0    -1  
$EndComp
Text Label 3550 3850 0    40   ~ 0
GND
Text Label 4950 2700 0    40   ~ 0
Data_In
Text Label 7300 2600 0    40   ~ 0
SCK_SCL
Text Label 7450 2700 0    40   ~ 0
MISO
Text Label 7300 2800 0    40   ~ 0
MOSI_SDA
Text Label 4950 2500 0    40   ~ 0
RST
Text Label 4950 2600 0    40   ~ 0
PB3
$EndSCHEMATC
