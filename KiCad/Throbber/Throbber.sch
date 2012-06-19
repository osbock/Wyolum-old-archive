EESchema Schematic File Version 2  date 6/19/2012 7:34:39 PM
LIBS:Throbber
LIBS:power
LIBS:Throbber-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title "Throbber - Bike Neutral Indicator"
Date "19 jun 2012"
Rev "A"
Comp "WyoLum"
Comment1 "www.wyolum.com"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 4900 3150
Connection ~ 3400 4200
Wire Wire Line
	3400 4150 3400 4200
Connection ~ 7200 2250
Wire Wire Line
	7200 3700 7200 2200
Wire Wire Line
	2450 7450 2850 7450
Wire Wire Line
	2450 7250 2850 7250
Wire Wire Line
	2450 7050 2850 7050
Wire Wire Line
	5400 3050 4900 3050
Connection ~ 5150 3250
Wire Wire Line
	7000 3350 7650 3350
Wire Wire Line
	7000 3150 7400 3150
Connection ~ 3200 2950
Wire Wire Line
	2850 2950 3200 2950
Wire Wire Line
	3300 1850 8650 1850
Wire Wire Line
	3300 1850 3300 3150
Wire Wire Line
	3300 3150 2850 3150
Wire Wire Line
	8650 1850 8650 2750
Connection ~ 7200 3600
Wire Wire Line
	7500 3700 7500 3600
Wire Wire Line
	7500 3600 7200 3600
Wire Wire Line
	7200 4100 7200 4500
Wire Wire Line
	8150 3350 8200 3350
Connection ~ 5150 4200
Wire Wire Line
	5150 4100 5150 4500
Wire Wire Line
	5400 3350 5350 3350
Connection ~ 5150 3600
Wire Wire Line
	4900 3600 5150 3600
Wire Wire Line
	4900 3600 4900 3700
Wire Wire Line
	750  6675 1100 6675
Wire Wire Line
	925  6775 925  6675
Connection ~ 925  6675
Wire Wire Line
	4650 3250 5400 3250
Wire Wire Line
	5150 3250 5150 3700
Wire Wire Line
	4900 4100 4900 4200
Wire Wire Line
	4900 4200 5150 4200
Wire Wire Line
	5350 3350 5350 4500
Wire Wire Line
	7200 2250 4650 2250
Wire Wire Line
	7200 4200 7500 4200
Wire Wire Line
	7500 4200 7500 4100
Connection ~ 7200 4200
Wire Wire Line
	7200 3050 7000 3050
Connection ~ 7200 3050
Wire Wire Line
	3700 4200 3700 4500
Wire Wire Line
	3200 2250 4150 2250
Wire Wire Line
	3200 2250 3200 3050
Wire Wire Line
	3200 3050 2850 3050
Wire Wire Line
	3200 3350 2850 3350
Wire Wire Line
	3200 4200 3700 4200
Wire Wire Line
	8650 3650 8650 4500
Wire Wire Line
	2850 3450 3200 3450
Connection ~ 3200 3450
Wire Wire Line
	7000 3250 7400 3250
Wire Wire Line
	5400 3150 4900 3150
Wire Wire Line
	4150 3250 2850 3250
Wire Wire Line
	2850 6950 2450 6950
Wire Wire Line
	2850 7150 2450 7150
Wire Wire Line
	2850 7350 2450 7350
Wire Notes Line
	2150 7550 3350 7550
Wire Notes Line
	2150 7550 2150 6650
Wire Notes Line
	2150 6650 3350 6650
Wire Notes Line
	3350 6650 3350 7550
Wire Wire Line
	3200 3350 3200 4200
$Comp
L PWR_FLAG #FLG01
U 1 1 4FE07A3E
P 3400 4150
F 0 "#FLG01" H 3400 4420 30  0001 C CNN
F 1 "PWR_FLAG" H 3400 4380 30  0000 C CNN
	1    3400 4150
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG02
U 1 1 4FE079EC
P 7200 2200
F 0 "#FLG02" H 7200 2470 30  0001 C CNN
F 1 "PWR_FLAG" H 7200 2430 30  0000 C CNN
	1    7200 2200
	1    0    0    -1  
$EndComp
Text Label 4900 3150 0    40   ~ 0
ADC3
Text Label 4900 3050 0    40   ~ 0
RST
$Comp
L CONN_6 K1
U 1 1 4FE072E2
P 2500 3200
F 0 "K1" V 2450 3200 60  0000 C CNN
F 1 "THROBBER" V 2550 3200 60  0000 C CNN
F 2 "pin_strip_6" V 2650 3200 60  0001 C CNN
	1    2500 3200
	-1   0    0    -1  
$EndComp
Text Label 7250 3350 0    40   ~ 0
MOSI_OUT
Text Label 7400 3250 0    40   ~ 0
MISO
Text Label 7400 3150 0    40   ~ 0
SCK
$Comp
L MOSFET_N Q1
U 1 1 4FE071E3
P 8500 3200
F 0 "Q1" H 8250 3400 60  0000 C CNN
F 1 "2N7000" H 8100 3250 60  0000 C CNN
F 2 "SOT23-3" H 8100 3350 60  0001 C CNN
	1    8500 3200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 4FE07039
P 8650 4500
F 0 "#PWR03" H 8650 4500 30  0001 C CNN
F 1 "GND" H 8650 4430 30  0001 C CNN
	1    8650 4500
	1    0    0    -1  
$EndComp
Text Label 4900 1850 0    40   ~ 0
LED_LAMP
$Comp
L GND #PWR04
U 1 1 4FE06F27
P 7200 4500
F 0 "#PWR04" H 7200 4500 30  0001 C CNN
F 1 "GND" H 7200 4430 30  0001 C CNN
	1    7200 4500
	1    0    0    -1  
$EndComp
Text Label 4900 3250 0    40   ~ 0
ND_IN
Text Label 4900 2250 0    40   ~ 0
5V
Text Label 3500 2250 0    40   ~ 0
12V
Text Label 3500 4200 0    40   ~ 0
GND
$Comp
L GND #PWR05
U 1 1 4FE06EF0
P 3700 4500
F 0 "#PWR05" H 3700 4500 30  0001 C CNN
F 1 "GND" H 3700 4430 30  0001 C CNN
	1    3700 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 4FE06E28
P 5150 4500
F 0 "#PWR06" H 5150 4500 30  0001 C CNN
F 1 "GND" H 5150 4430 30  0001 C CNN
	1    5150 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 4FE06E1E
P 5350 4500
F 0 "#PWR07" H 5350 4500 30  0001 C CNN
F 1 "GND" H 5350 4430 30  0001 C CNN
	1    5350 4500
	1    0    0    -1  
$EndComp
Text Label 3500 3250 0    40   ~ 0
~NEUTRAL DETECT
$Comp
L ATTINY85 U1
U 1 1 4FE06AE0
P 6200 3200
F 0 "U1" H 5600 3500 50  0000 L BNN
F 1 "ATTINY45/V" H 5600 2850 50  0000 L BNN
F 2 "SO8E" H 6700 2775 50  0001 C CNN
	1    6200 3200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 4FC9CC08
P 925 6775
F 0 "#PWR08" H 925 6775 30  0001 C CNN
F 1 "GND" H 925 6705 30  0001 C CNN
	1    925  6775
	1    0    0    -1  
$EndComp
Text Notes 650  6425 0    40   ~ 0
MOUNTING HOLES
$Comp
L CONN_1 P2
U 1 1 4FC9C7C5
P 1100 6525
F 0 "P2" V 1025 6450 40  0000 L CNN
F 1 "CONN_1" H 1100 6580 30  0001 C CNN
F 2 "vite_3mm" H 1100 6525 60  0001 C CNN
	1    1100 6525
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P1
U 1 1 4FC9C7B3
P 750 6525
F 0 "P1" V 675 6550 40  0000 L CNN
F 1 "CONN_1" H 750 6580 30  0001 C CNN
F 2 "vite_3mm" H 750 6525 60  0001 C CNN
	1    750  6525
	0    -1   -1   0   
$EndComp
$Comp
L C C2
U 1 1 4FC8914C
P 7500 3900
F 0 "C2" H 7550 4000 50  0000 L CNN
F 1 "100n" H 7525 3800 50  0000 L CNN
F 2 "c_0805" H 7500 3900 60  0001 C CNN
	1    7500 3900
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 4FC89147
P 4900 3900
F 0 "C1" H 4950 4000 50  0000 L CNN
F 1 "10n" H 4925 3800 50  0000 L CNN
F 2 "c_0805" H 4900 3900 60  0001 C CNN
	1    4900 3900
	1    0    0    -1  
$EndComp
Text Notes 2275 6775 0    60   Italic 12
ISP
$Comp
L CONN_6 K2
U 1 1 4FC76A52
P 3200 7200
F 0 "K2" V 3150 7200 60  0000 C CNN
F 1 "ISP" V 3250 7200 60  0000 C CNN
F 2 "pin_strip_3x2" H 3200 7200 60  0001 C CNN
	1    3200 7200
	1    0    0    -1  
$EndComp
Text Label 2450 6950 2    40   ~ 0
MISO
Text Label 2450 7150 2    40   ~ 0
SCK
Text Label 2450 7350 2    40   ~ 0
RST
Text Label 2450 7050 2    40   ~ 0
5V
Text Label 2450 7450 2    40   ~ 0
GND
Text Label 2450 7250 2    40   ~ 0
MOSI_OUT
$Comp
L DIODE_ZENER D2
U 1 1 4FC7194F
P 7200 3900
F 0 "D2" H 7300 3850 40  0000 C CNN
F 1 "Z5V1" H 7200 3775 40  0000 C CNN
F 2 "d_0805" H 7200 3900 60  0001 C CNN
	1    7200 3900
	0    -1   -1   0   
$EndComp
$Comp
L DIODE_ZENER D1
U 1 1 4FC71943
P 5150 3900
F 0 "D1" H 5250 3850 40  0000 C CNN
F 1 "Z5V1" H 5150 3775 40  0000 C CNN
F 2 "d_0805" H 5150 3900 60  0001 C CNN
	1    5150 3900
	0    -1   -1   0   
$EndComp
$Comp
L R R2
U 1 1 4FC71681
P 4400 2250
F 0 "R2" V 4325 2250 50  0000 C CNN
F 1 "4K7" V 4400 2250 50  0000 C CNN
F 2 "r_0805" H 4400 2250 60  0001 C CNN
	1    4400 2250
	0    1    1    0   
$EndComp
$Comp
L R R3
U 1 1 4FC7167F
P 7900 3350
F 0 "R3" V 7950 3550 50  0000 C CNN
F 1 "2k2" V 7900 3350 50  0000 C CNN
F 2 "r_0805" H 7900 3350 60  0001 C CNN
	1    7900 3350
	0    -1   -1   0   
$EndComp
$Comp
L PCB PCB1
U 1 1 4EDA0FBA
P 925 7275
F 0 "PCB1" H 925 7575 60  0000 C CNN
F 1 "PCB" H 925 6975 60  0000 C CNN
F 2 "PCB" H 925 7275 60  0001 C CNN
	1    925  7275
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 4C1741EB
P 4400 3250
F 0 "R1" V 4325 3250 50  0000 C CNN
F 1 "4K7" V 4400 3250 50  0000 C CNN
F 2 "r_0805" H 4400 3250 60  0001 C CNN
	1    4400 3250
	0    1    1    0   
$EndComp
$EndSCHEMATC
