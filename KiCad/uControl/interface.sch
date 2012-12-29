EESchema Schematic File Version 2  date 12/29/2012 7:23:44 PM
LIBS:uControl
LIBS:Conn-raspberry
LIBS:power
LIBS:uControl_v1-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 2 5
Title ""
Date "29 dec 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_6 P23
U 1 1 50DED8EA
P 4675 6800
F 0 "P23" V 4625 6800 60  0000 C CNN
F 1 "Pump" V 4725 6800 60  0000 C CNN
F 4 "X200" V 4825 6800 40  0000 C CNN "Part_No"
	1    4675 6800
	1    0    0    -1  
$EndComp
NoConn ~ 8050 4350
NoConn ~ 8100 4350
NoConn ~ 8100 4150
NoConn ~ 8050 4150
$Comp
L CONN_2 P28
U 1 1 50DE8768
P 7700 4250
F 0 "P28" V 7650 4250 40  0000 C CNN
F 1 "VLV_90_M" V 7750 4250 40  0000 C CNN
F 2 "2X06/90" V 7850 4250 40  0001 C CNN
	1    7700 4250
	-1   0    0    -1  
$EndComp
$Comp
L CONN_2 P29
U 1 1 50DE8761
P 8450 4250
F 0 "P29" V 8400 4250 40  0000 C CNN
F 1 "VLV_90_F" V 8500 4250 40  0000 C CNN
F 2 "Header_F_6x2" V 8600 4250 40  0001 C CNN
	1    8450 4250
	1    0    0    -1  
$EndComp
Text Label 6750 3600 0    40   ~ 0
+Vlv
Text Label 7700 6375 0    40   ~ 0
TC
Text Label 7700 6275 0    40   ~ 0
T+
Text Label 7700 5975 0    40   ~ 0
T-
Text Label 7700 5875 0    40   ~ 0
TD
Text Label 6325 6275 0    40   ~ 0
TSCL
Text Label 6325 6175 0    40   ~ 0
TSDA
Text Label 4275 5850 0    40   ~ 0
PT
Text Label 4275 5750 0    40   ~ 0
PR
Text Label 4275 5650 0    40   ~ 0
PX
Text Label 4275 5550 0    40   ~ 0
P-
Text Label 4275 5450 0    40   ~ 0
P+
Text Label 4275 5350 0    40   ~ 0
P+
Text Label 2925 3425 0    40   ~ 0
PD2_Flow_Tx
$Comp
L SCREW SC21
U 1 1 50DC1602
P 8000 6900
F 0 "SC21" H 8000 6800 40  0000 C CNN
F 1 "SCREW" H 8000 7000 40  0001 C CNN
F 2 "vite_3mm" H 8000 7100 40  0001 C CNN
	1    8000 6900
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC22
U 1 1 50DC1601
P 8150 6900
F 0 "SC22" H 8150 6800 40  0000 C CNN
F 1 "SCREW" H 8150 7000 40  0001 C CNN
F 2 "vite_3mm" H 8150 7100 40  0001 C CNN
	1    8150 6900
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC23
U 1 1 50DC1600
P 8300 6900
F 0 "SC23" H 8300 6800 40  0000 C CNN
F 1 "SCREW" H 8300 7000 40  0001 C CNN
F 2 "vite_3mm" H 8300 7100 40  0001 C CNN
	1    8300 6900
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC24
U 1 1 50DC15FF
P 8450 6900
F 0 "SC24" H 8450 6800 40  0000 C CNN
F 1 "SCREW" H 8450 7000 40  0001 C CNN
F 2 "vite_3mm" H 8450 7100 40  0001 C CNN
	1    8450 6900
	1    0    0    -1  
$EndComp
Text Notes 8000 6800 0    40   ~ 0
Mounting Holes
$Comp
L PCB PCB6
U 1 1 50DAE3BE
P 10300 4850
F 0 "PCB6" H 10300 4700 40  0000 C CNN
F 1 "PCB_MFold" H 10300 5000 40  0000 C CNN
F 2 "PCB_Mfold" H 10300 5250 40  0001 C CNN
	1    10300 4850
	1    0    0    -1  
$EndComp
$Comp
L PCB PCB5
U 1 1 50DAE3A7
P 7900 4850
F 0 "PCB5" H 7900 4700 40  0000 C CNN
F 1 "PCB_Vlv" H 7900 5000 40  0000 C CNN
F 2 "PCB_Vlv" H 7900 5250 40  0001 C CNN
	1    7900 4850
	1    0    0    -1  
$EndComp
$Comp
L PCB PCB2
U 1 1 50DAE394
P 1600 6900
F 0 "PCB2" H 1600 6700 40  0000 C CNN
F 1 "PCB_Pump" H 1600 7050 40  0000 C CNN
F 2 "PCB_Pump" H 1600 7300 40  0001 C CNN
	1    1600 6900
	1    0    0    -1  
$EndComp
$Comp
L PCB PCB3
U 1 1 50DAE38C
P 1600 4850
F 0 "PCB3" H 1600 4700 40  0000 C CNN
F 1 "PCB_Flow" H 1600 5000 40  0000 C CNN
F 2 "PCB_Flow" H 1600 5250 40  0001 C CNN
	1    1600 4850
	1    0    0    -1  
$EndComp
Wire Notes Line
	8875 5050 11150 5050
Wire Notes Line
	8875 5050 8875 3150
Wire Notes Line
	8875 3150 11150 3150
Wire Wire Line
	8100 3600 8025 3600
Wire Wire Line
	4325 5750 4250 5750
Wire Wire Line
	4325 5550 4250 5550
Wire Wire Line
	4325 5350 4250 5350
Wire Wire Line
	7000 3600 7000 4400
Wire Notes Line
	4950 3000 675  3000
Wire Notes Line
	4950 5050 675  5050
Wire Notes Line
	675  7125 4950 7125
Connection ~ 2800 5350
Wire Wire Line
	2800 6100 2800 5350
Wire Wire Line
	3325 5550 3225 5550
Wire Wire Line
	5300 6175 5450 6175
Wire Notes Line
	8875 575  8875 3000
Wire Wire Line
	10775 2375 10775 2275
Wire Wire Line
	10775 2275 9925 2275
Connection ~ 9925 2450
Wire Wire Line
	9925 2275 9925 2450
Wire Wire Line
	9725 2650 10075 2650
Wire Wire Line
	9725 2450 10075 2450
Wire Wire Line
	9725 2550 10075 2550
Wire Wire Line
	9725 2750 10075 2750
Wire Wire Line
	9925 2750 9925 2925
Connection ~ 9925 2750
Wire Wire Line
	9925 2925 10775 2925
Wire Wire Line
	10775 2925 10775 2775
Wire Notes Line
	5100 5050 8725 5050
Wire Notes Line
	5100 3000 8725 3000
Wire Notes Line
	8725 7125 5100 7125
Wire Wire Line
	7825 6375 7600 6375
Wire Wire Line
	7600 6375 7600 6275
Wire Notes Line
	5100 3000 5100 575 
Wire Notes Line
	4950 5050 4950 3150
Wire Notes Line
	4950 3000 4950 575 
Connection ~ 2425 2850
Wire Wire Line
	1900 2850 3225 2850
Wire Wire Line
	3225 2850 3225 2700
Wire Notes Line
	675  7125 675  5200
Wire Wire Line
	10775 1925 10775 2075
Wire Wire Line
	10775 2075 9925 2075
Connection ~ 9925 1900
Wire Wire Line
	9925 2075 9925 1900
Wire Wire Line
	9725 1900 10075 1900
Wire Wire Line
	9725 1700 10075 1700
Connection ~ 7675 6275
Wire Wire Line
	7825 6275 7675 6275
Wire Wire Line
	7600 6175 7675 6175
Connection ~ 6425 5450
Wire Wire Line
	6625 5450 5950 5450
Wire Wire Line
	6625 5450 6625 6175
Wire Wire Line
	6625 6175 6675 6175
Wire Wire Line
	6675 6275 6150 6275
Wire Notes Line
	5100 5050 5100 3150
Wire Notes Line
	8725 5050 8725 3150
Wire Wire Line
	6425 5975 6425 5900
Wire Wire Line
	5250 5500 5250 5450
Wire Wire Line
	5250 5900 5250 5950
Connection ~ 5800 6925
Wire Wire Line
	6275 6875 6275 6925
Wire Wire Line
	5800 6475 5800 7000
Wire Wire Line
	5250 5450 5650 5450
Wire Wire Line
	5650 5450 5650 5675
Wire Wire Line
	5950 5450 5950 5675
Connection ~ 2425 1700
Wire Wire Line
	2425 2300 2425 1150
Wire Wire Line
	2150 3425 3325 3425
Wire Wire Line
	1450 1600 1450 1650
Wire Wire Line
	2575 1600 2575 1650
Wire Wire Line
	1750 1400 1750 1150
Wire Wire Line
	2050 1400 2050 1150
Wire Wire Line
	1050 1475 1125 1475
Wire Wire Line
	1125 1475 1125 2200
Wire Wire Line
	1125 2200 1550 2200
Wire Wire Line
	1050 1175 1225 1175
Wire Wire Line
	1225 1175 1225 2000
Wire Wire Line
	1225 2000 1550 2000
Wire Wire Line
	2250 1900 2800 1900
Wire Wire Line
	2800 1900 2800 1075
Wire Wire Line
	2800 1075 3325 1075
Wire Wire Line
	2250 2100 2900 2100
Wire Wire Line
	2900 2100 2900 1275
Wire Wire Line
	2900 1275 3325 1275
Wire Wire Line
	6175 1750 7100 1750
Wire Wire Line
	6175 1550 7100 1550
Wire Wire Line
	7100 1350 6175 1350
Wire Wire Line
	6175 1250 7100 1250
Wire Wire Line
	6175 1450 7100 1450
Connection ~ 6750 4900
Wire Wire Line
	6750 4900 7000 4900
Wire Wire Line
	7000 4900 7000 4800
Connection ~ 3200 4125
Wire Wire Line
	3200 4175 3200 4125
Wire Wire Line
	8475 5675 7675 5675
Wire Wire Line
	8475 5675 8475 5925
Wire Wire Line
	9725 1275 9725 1100
Wire Wire Line
	9725 1275 10775 1275
Wire Wire Line
	10775 1275 10775 1200
Wire Wire Line
	10075 1000 9725 1000
Wire Wire Line
	1375 5850 3325 5850
Wire Wire Line
	2025 5650 1375 5650
Connection ~ 2425 5750
Wire Wire Line
	2425 6100 2425 5750
Wire Wire Line
	2225 5750 3325 5750
Connection ~ 2425 6550
Wire Wire Line
	2425 6550 2425 6500
Wire Wire Line
	5475 3875 6075 3875
Wire Wire Line
	6075 3875 6075 3700
Wire Wire Line
	6075 3700 5925 3700
Wire Wire Line
	6750 4275 6425 4275
Wire Wire Line
	6425 3750 6425 3600
Wire Wire Line
	2575 6500 2575 6625
Wire Wire Line
	6450 4600 5950 4600
Wire Wire Line
	3225 5550 3225 6550
Connection ~ 2575 5650
Wire Wire Line
	2575 6100 2575 5650
Wire Wire Line
	1800 4025 3325 4025
Wire Wire Line
	1050 975  3325 975 
Wire Wire Line
	3325 775  1050 775 
Wire Wire Line
	3325 875  1050 875 
Wire Wire Line
	3325 1475 2950 1475
Wire Wire Line
	2150 3525 3325 3525
Wire Wire Line
	1800 4125 3325 4125
Wire Wire Line
	2525 5650 3325 5650
Connection ~ 2575 6550
Wire Wire Line
	7100 3800 6750 3800
Wire Wire Line
	6750 3800 6750 4400
Wire Wire Line
	6750 4800 6750 4975
Wire Wire Line
	6425 4275 6425 4150
Connection ~ 6750 4275
Wire Wire Line
	5925 3500 6075 3500
Wire Wire Line
	6075 3500 6075 3375
Wire Wire Line
	6075 3375 5475 3375
Wire Wire Line
	3225 6550 1375 6550
Wire Wire Line
	1725 5750 1375 5750
Wire Wire Line
	3325 5350 1950 5350
Wire Wire Line
	9450 900  10075 900 
Wire Wire Line
	9725 1100 10075 1100
Wire Wire Line
	9725 1000 9725 750 
Wire Wire Line
	9725 750  10775 750 
Wire Wire Line
	10775 750  10775 800 
Wire Wire Line
	7675 6175 7675 6550
Wire Wire Line
	7675 6550 8475 6550
Wire Wire Line
	8475 6550 8475 6325
Wire Wire Line
	2950 1475 2950 2200
Wire Wire Line
	2950 2200 2250 2200
Wire Wire Line
	3325 1175 2850 1175
Wire Wire Line
	2850 1175 2850 2000
Wire Wire Line
	2850 2000 2250 2000
Wire Wire Line
	1550 1900 1275 1900
Wire Wire Line
	1275 1900 1275 1075
Wire Wire Line
	1275 1075 1050 1075
Wire Wire Line
	1550 2100 1175 2100
Wire Wire Line
	1175 2100 1175 1275
Wire Wire Line
	1175 1275 1050 1275
Wire Wire Line
	1900 2500 1900 2900
Wire Wire Line
	2050 1150 2575 1150
Wire Wire Line
	2575 1150 2575 1200
Wire Wire Line
	1750 1150 1450 1150
Wire Wire Line
	1450 1150 1450 1200
Wire Wire Line
	6550 1150 6550 1250
Connection ~ 6550 1250
Wire Wire Line
	3200 4575 3200 4625
Wire Wire Line
	3200 4625 2975 4625
Wire Wire Line
	2975 4625 2975 4025
Connection ~ 2975 4025
Wire Wire Line
	2250 1700 2425 1700
Connection ~ 2425 1150
Wire Wire Line
	2425 2800 2425 2850
Connection ~ 1900 2850
Wire Wire Line
	6150 5975 6275 5975
Wire Wire Line
	6150 6175 6525 6175
Wire Wire Line
	6275 6375 6275 5450
Connection ~ 6275 5975
Wire Wire Line
	6425 5500 6425 5450
Connection ~ 6275 5450
Wire Wire Line
	6675 5975 6525 5975
Wire Wire Line
	6525 5975 6525 6175
Wire Wire Line
	6675 6075 6575 6075
Wire Wire Line
	6575 6075 6575 6925
Wire Wire Line
	6575 6925 5800 6925
Connection ~ 6275 6925
Wire Wire Line
	7600 6075 7675 6075
Wire Wire Line
	7675 6075 7675 5675
Wire Wire Line
	7825 5975 7675 5975
Connection ~ 7675 5975
Wire Notes Line
	8725 7125 8725 5200
Wire Notes Line
	5100 7125 5100 5200
Wire Wire Line
	9725 1600 10075 1600
Wire Wire Line
	9725 1800 10075 1800
Wire Wire Line
	9925 1600 9925 1425
Connection ~ 9925 1600
Wire Wire Line
	9925 1425 10775 1425
Wire Wire Line
	10775 1425 10775 1525
Wire Notes Line
	8875 575  11150 575 
Wire Notes Line
	8875 3000 11150 3000
Wire Notes Line
	4950 7125 4950 5200
Wire Wire Line
	3225 2300 3225 775 
Connection ~ 3225 775 
Wire Notes Line
	675  3000 675  575 
Wire Notes Line
	675  5050 675  3150
Wire Notes Line
	8725 3000 8725 575 
Wire Wire Line
	7600 5975 7600 5875
Wire Wire Line
	7600 5875 7825 5875
Wire Notes Line
	5100 5200 8725 5200
Wire Notes Line
	8725 575  5100 575 
Wire Notes Line
	8725 3150 5100 3150
Wire Wire Line
	6550 750  6550 700 
Wire Wire Line
	6550 700  6400 700 
Wire Wire Line
	6400 700  6400 1450
Connection ~ 6400 1450
Wire Notes Line
	11150 3000 11150 575 
Wire Wire Line
	5300 6275 5450 6275
Wire Wire Line
	2800 6550 2800 6500
Connection ~ 2800 6550
Wire Wire Line
	3325 5450 2800 5450
Connection ~ 2800 5450
Wire Notes Line
	4950 5200 675  5200
Wire Notes Line
	675  3150 4950 3150
Wire Notes Line
	675  575  4950 575 
Wire Wire Line
	5925 3600 7100 3600
Connection ~ 6425 3600
Connection ~ 7000 3600
Wire Wire Line
	4250 5450 4325 5450
Wire Wire Line
	4250 5650 4325 5650
Wire Wire Line
	4250 5850 4325 5850
Wire Wire Line
	8025 3800 8100 3800
Wire Notes Line
	11150 3150 11150 5050
Text Notes 10550 4800 0    40   ~ 0
Mounting Holes
$Comp
L SCREW SC16
U 1 1 50DAD9E8
P 11000 4900
F 0 "SC16" H 11000 4800 40  0000 C CNN
F 1 "SCREW" H 11000 5000 40  0001 C CNN
F 2 "vite_3mm" H 11000 5100 40  0001 C CNN
	1    11000 4900
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC15
U 1 1 50DAD9E7
P 10850 4900
F 0 "SC15" H 10850 4800 40  0000 C CNN
F 1 "SCREW" H 10850 5000 40  0001 C CNN
F 2 "vite_3mm" H 10850 5100 40  0001 C CNN
	1    10850 4900
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC14
U 1 1 50DAD9E6
P 10700 4900
F 0 "SC14" H 10700 4800 40  0000 C CNN
F 1 "SCREW" H 10700 5000 40  0001 C CNN
F 2 "vite_3mm" H 10700 5100 40  0001 C CNN
	1    10700 4900
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC13
U 1 1 50DAD9E5
P 10550 4900
F 0 "SC13" H 10550 4800 40  0000 C CNN
F 1 "SCREW" H 10550 5000 40  0001 C CNN
F 2 "vite_3mm" H 10550 5100 40  0001 C CNN
	1    10550 4900
	1    0    0    -1  
$EndComp
NoConn ~ 10350 4300
NoConn ~ 10350 4200
NoConn ~ 10350 3800
NoConn ~ 10350 3700
$Comp
L MANIFOLD M1
U 1 1 50DACF5C
P 10150 4000
F 0 "M1" H 9930 3940 60  0000 C CNN
F 1 "MANIFOLD" H 9800 4050 60  0000 C CNN
F 2 "Manifold2" H 9800 4150 60  0001 C CNN
	1    10150 4000
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC9
U 1 1 50D99159
P 8150 4850
F 0 "SC9" H 8150 4750 40  0000 C CNN
F 1 "SCREW" H 8150 4950 40  0001 C CNN
F 2 "vite_3mm" H 8150 5050 40  0001 C CNN
	1    8150 4850
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC10
U 1 1 50D99158
P 8300 4850
F 0 "SC10" H 8300 4750 40  0000 C CNN
F 1 "SCREW" H 8300 4950 40  0001 C CNN
F 2 "vite_3mm" H 8300 5050 40  0001 C CNN
	1    8300 4850
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC11
U 1 1 50D99157
P 8450 4850
F 0 "SC11" H 8450 4750 40  0000 C CNN
F 1 "SCREW" H 8450 4950 40  0001 C CNN
F 2 "vite_3mm" H 8450 5050 40  0001 C CNN
	1    8450 4850
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC12
U 1 1 50D99156
P 8600 4850
F 0 "SC12" H 8600 4750 40  0000 C CNN
F 1 "SCREW" H 8600 4950 40  0001 C CNN
F 2 "vite_3mm" H 8600 5050 40  0001 C CNN
	1    8600 4850
	1    0    0    -1  
$EndComp
Text Notes 8150 4750 0    40   ~ 0
Mounting Holes
$Comp
L SCREW SC5
U 1 1 50D99149
P 850 6950
F 0 "SC5" H 850 6850 40  0000 C CNN
F 1 "SCREW" H 850 7050 40  0001 C CNN
F 2 "vite_3mm" H 850 7150 40  0001 C CNN
	1    850  6950
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC6
U 1 1 50D99148
P 1000 6950
F 0 "SC6" H 1000 6850 40  0000 C CNN
F 1 "SCREW" H 1000 7050 40  0001 C CNN
F 2 "vite_3mm" H 1000 7150 40  0001 C CNN
	1    1000 6950
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC7
U 1 1 50D99147
P 1150 6950
F 0 "SC7" H 1150 6850 40  0000 C CNN
F 1 "SCREW" H 1150 7050 40  0001 C CNN
F 2 "vite_3mm" H 1150 7150 40  0001 C CNN
	1    1150 6950
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC8
U 1 1 50D99146
P 1300 6950
F 0 "SC8" H 1300 6850 40  0000 C CNN
F 1 "SCREW" H 1300 7050 40  0001 C CNN
F 2 "vite_3mm" H 1300 7150 40  0001 C CNN
	1    1300 6950
	1    0    0    -1  
$EndComp
Text Notes 850  6850 0    40   ~ 0
Mounting Holes
Text Notes 850  4750 0    40   ~ 0
Mounting Holes
$Comp
L SCREW SC4
U 1 1 50D990FE
P 1300 4850
F 0 "SC4" H 1300 4750 40  0000 C CNN
F 1 "SCREW" H 1300 4950 40  0001 C CNN
F 2 "vite_3mm" H 1300 5050 40  0001 C CNN
	1    1300 4850
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC3
U 1 1 50D990FC
P 1150 4850
F 0 "SC3" H 1150 4750 40  0000 C CNN
F 1 "SCREW" H 1150 4950 40  0001 C CNN
F 2 "vite_3mm" H 1150 5050 40  0001 C CNN
	1    1150 4850
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC2
U 1 1 50D990F9
P 1000 4850
F 0 "SC2" H 1000 4750 40  0000 C CNN
F 1 "SCREW" H 1000 4950 40  0001 C CNN
F 2 "vite_3mm" H 1000 5050 40  0001 C CNN
	1    1000 4850
	1    0    0    -1  
$EndComp
$Comp
L SCREW SC1
U 1 1 50D990F0
P 850 4850
F 0 "SC1" H 850 4750 40  0000 C CNN
F 1 "SCREW" H 850 4950 40  0001 C CNN
F 2 "vite_3mm" H 850 5050 40  0001 C CNN
	1    850  4850
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P14
U 1 1 50D6C583
P 8450 3700
F 0 "P14" V 8400 3700 50  0000 C CNN
F 1 "Valve" H 8425 3900 40  0000 C CNN
F 2 "Valve" V 8600 3700 40  0001 C CNN
F 4 "X-1-05-S-F" H 8450 3500 40  0000 C CNN "Part_No"
	1    8450 3700
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P13
U 1 1 50D6C569
P 7675 3700
F 0 "P13" V 7625 3700 50  0000 C CNN
F 1 "Valve_Conn_BO" H 7525 3900 40  0000 C CNN
F 2 "Header_5V_Link" V 7825 3700 40  0001 C CNN
F 4 "X-1-05-S-F" V 7825 3700 40  0001 C CNN "Part_No"
	1    7675 3700
	-1   0    0    -1  
$EndComp
$Comp
L CONN_6 P19
U 1 1 50D6C4CF
P 4675 5600
F 0 "P19" V 4625 5600 60  0000 C CNN
F 1 "Pump_Conn_Flex" V 4725 5600 40  0000 C CNN
F 2 "Conn_Pump_Flex" V 4825 5600 40  0001 C CNN
F 4 "X200" V 4825 5600 40  0001 C CNN "Part_No"
	1    4675 5600
	1    0    0    -1  
$EndComp
$Comp
L CONN_6 P18
U 1 1 50D6C4BF
P 3900 5600
F 0 "P18" V 3850 5600 60  0000 C CNN
F 1 "Pump_Conn_BO" V 3950 5600 40  0000 C CNN
F 2 "Header_FTDI" V 4050 5600 40  0001 C CNN
F 4 "X200" V 4050 5600 40  0001 C CNN "Part_No"
	1    3900 5600
	-1   0    0    -1  
$EndComp
NoConn ~ 4325 7050
NoConn ~ 4325 6950
NoConn ~ 4325 6850
NoConn ~ 4325 6750
$Comp
L CONN_4 P16
U 1 1 50D6BF9C
P 4675 3775
F 0 "P16" V 4625 3775 50  0000 C CNN
F 1 "FlowMeter" V 4725 3775 50  0000 C CNN
F 2 "FlowMeter" V 4825 3775 50  0001 C CNN
F 4 "EM1NR4R0V_1A" V 4825 3775 40  0000 C CNN "Part_No"
	1    4675 3775
	1    0    0    -1  
$EndComp
NoConn ~ 4325 6650
NoConn ~ 4325 6550
NoConn ~ 4325 3925
NoConn ~ 4325 3825
NoConn ~ 4325 3725
NoConn ~ 4325 3625
$Comp
L CONN_2 P12
U 1 1 50D19ECE
P 7450 3700
F 0 "P12" V 7400 3700 50  0000 C CNN
F 1 "Valve_Conn" H 7350 3900 40  0000 C CNN
F 2 "Header_5V_Link" V 7600 3700 40  0001 C CNN
F 4 "X-1-05-S-F" V 7600 3700 40  0001 C CNN "Part_No"
	1    7450 3700
	1    0    0    -1  
$EndComp
$Comp
L CONN_6 P8
U 1 1 50D19E1A
P 7450 1500
F 0 "P8" V 7400 1500 60  0000 C CNN
F 1 "Abso_Pr" V 7500 1500 60  0000 C CNN
F 2 "HDIB002AUY8H5" V 7600 1500 60  0001 C CNN
F 4 "HDIB002AUY8H5" V 7600 1500 40  0000 C CNN "Part_No"
	1    7450 1500
	1    0    0    -1  
$EndComp
$Comp
L CONN_8 P7
U 1 1 50D19AF4
P 3675 1125
F 0 "P7" V 3625 1125 60  0000 C CNN
F 1 "Gage_Pr" V 3725 1125 60  0000 C CNN
F 2 "HCEM500GUH9P3" V 3825 1125 60  0001 C CNN
F 4 "HCEM500GUH9P3" V 3825 1100 40  0000 C CNN "Part_No"
	1    3675 1125
	1    0    0    -1  
$EndComp
Text Notes 8950 2225 0    40   ~ 0
SPARE
NoConn ~ 7100 1650
Text Label 6175 1550 0    40   ~ 0
SDA
$Comp
L CONN_4 P10
U 1 1 50CEC0D0
P 10425 2600
F 0 "P10" V 10375 2600 50  0000 C CNN
F 1 "C3SB" V 10475 2600 50  0000 C CNN
F 2 "pin_strip_4-90" V 10575 2600 50  0001 C CNN
	1    10425 2600
	1    0    0    -1  
$EndComp
Text Label 9725 2550 0    40   ~ 0
SCL
Text Label 9725 2650 0    40   ~ 0
SDA
Text Label 9725 2750 0    40   ~ 0
GND
Text Label 9725 2450 0    40   ~ 0
5V0
$Comp
L C C11
U 1 1 50CEC0CF
P 10775 2575
F 0 "C11" H 10800 2650 50  0000 L CNN
F 1 "100n" H 10800 2475 50  0000 L CNN
F 2 "C2" H 10800 2575 50  0001 C CNN
F 4 "490-1734-1-ND" H 10775 2775 60  0001 C CNN "Digikey"
	1    10775 2575
	1    0    0    -1  
$EndComp
Text Notes 8925 650  0    40   ~ 0
Pulse Sensor\nAnalog + I2C on C3SB Bus
$Comp
L C C9
U 1 1 50CCCDB6
P 10775 1725
F 0 "C9" H 10800 1800 50  0000 L CNN
F 1 "100n" H 10800 1625 50  0000 L CNN
F 2 "C2" H 10800 1725 50  0001 C CNN
F 4 "490-1734-1-ND" H 10775 1925 60  0001 C CNN "Digikey"
	1    10775 1725
	1    0    0    -1  
$EndComp
Text Label 9725 1600 0    40   ~ 0
5V0
Text Label 9725 1900 0    40   ~ 0
GND
Text Label 9725 1800 0    40   ~ 0
SDA
Text Label 9725 1700 0    40   ~ 0
SCL
$Comp
L CONN_4 P9
U 1 1 50CCCC5E
P 10425 1750
F 0 "P9" V 10375 1750 50  0000 C CNN
F 1 "C3SB" V 10475 1750 50  0000 C CNN
F 2 "pin_strip_4-90" V 10575 1750 50  0001 C CNN
	1    10425 1750
	1    0    0    -1  
$EndComp
Text Notes 5175 5275 0    40   ~ 0
Temp Sensor on I2C\nwith 3V3<>5V0 translator
$Comp
L CONN_4 P21
U 1 1 50CCCAB6
P 7250 6125
F 0 "P21" V 7200 6125 50  0000 C CNN
F 1 "Temp_Conn_BO" V 7300 6125 40  0000 C CNN
F 2 "SIL-4" V 7400 6125 40  0001 C CNN
	1    7250 6125
	-1   0    0    1   
$EndComp
$Comp
L CONN_4 P20
U 1 1 50CCCAA5
P 7025 6125
F 0 "P20" V 6975 6125 50  0000 C CNN
F 1 "Temp_Conn" V 7075 6125 40  0000 C CNN
F 2 "SIL-4" V 7175 6125 40  0001 C CNN
	1    7025 6125
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 50CCC2AC
P 6425 5975
F 0 "#PWR03" H 6425 5975 30  0001 C CNN
F 1 "GND" H 6425 5905 30  0001 C CNN
	1    6425 5975
	1    0    0    -1  
$EndComp
$Comp
L C C15
U 1 1 50CCC29B
P 6425 5700
F 0 "C15" H 6450 5775 50  0000 L CNN
F 1 "100n" H 6450 5625 50  0000 L CNN
F 2 "C2" H 6450 5725 50  0001 C CNN
F 4 "490-1734-1-ND" H 6425 5900 60  0001 C CNN "Digikey"
	1    6425 5700
	1    0    0    -1  
$EndComp
$Comp
L C C14
U 1 1 50CCC293
P 5250 5700
F 0 "C14" H 5275 5775 50  0000 L CNN
F 1 "100n" H 5275 5625 50  0000 L CNN
F 2 "C2" H 5275 5725 50  0001 C CNN
F 4 "490-1734-1-ND" H 5250 5900 60  0001 C CNN "Digikey"
	1    5250 5700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 50CCC292
P 5250 5950
F 0 "#PWR04" H 5250 5950 30  0001 C CNN
F 1 "GND" H 5250 5880 30  0001 C CNN
	1    5250 5950
	1    0    0    -1  
$EndComp
$Comp
L R R7
U 1 1 50CCC247
P 6275 6625
F 0 "R7" H 6225 6475 50  0000 C CNN
F 1 "10k" V 6275 6625 50  0000 C CNN
F 2 "rc03_vert" V 6375 6625 50  0001 C CNN
	1    6275 6625
	-1   0    0    1   
$EndComp
Text Label 5950 5450 0    40   ~ 0
3V3
Text Label 5250 5450 0    40   ~ 0
5V0
$Comp
L GND #PWR05
U 1 1 50CCC1EF
P 5800 7000
F 0 "#PWR05" H 5800 7000 30  0001 C CNN
F 1 "GND" H 5800 6930 30  0001 C CNN
	1    5800 7000
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 50CCC15C
P 2425 2550
F 0 "R4" H 2375 2375 50  0000 C CNN
F 1 "10k" V 2425 2550 50  0000 C CNN
F 2 "rc03_vert" V 2525 2550 50  0001 C CNN
	1    2425 2550
	-1   0    0    1   
$EndComp
$Comp
L TXS0102DCT U2
U 1 1 50CCC02A
P 5800 6375
F 0 "U2" H 5800 6775 40  0000 C CNN
F 1 "TXS0102DCT" H 5800 6675 40  0000 C CNN
F 2 "TXS0102DCTR" H 5800 6775 40  0001 C CNN
	1    5800 6375
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 50CCABF0
P 2575 1650
F 0 "#PWR06" H 2575 1650 30  0001 C CNN
F 1 "GND" H 2575 1580 30  0001 C CNN
	1    2575 1650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 50CCABEC
P 1450 1650
F 0 "#PWR07" H 1450 1650 30  0001 C CNN
F 1 "GND" H 1450 1580 30  0001 C CNN
	1    1450 1650
	1    0    0    -1  
$EndComp
$Comp
L C C7
U 1 1 50CCABCC
P 1450 1400
F 0 "C7" H 1475 1475 50  0000 L CNN
F 1 "100n" H 1475 1325 50  0000 L CNN
F 2 "C2" H 1475 1425 50  0001 C CNN
F 4 "490-1734-1-ND" H 1450 1600 60  0001 C CNN "Digikey"
	1    1450 1400
	1    0    0    -1  
$EndComp
$Comp
L C C8
U 1 1 50CCAB99
P 2575 1400
F 0 "C8" H 2600 1475 50  0000 L CNN
F 1 "100n" H 2600 1325 50  0000 L CNN
F 2 "C2" H 2600 1425 50  0001 C CNN
F 4 "490-1734-1-ND" H 2575 1600 60  0001 C CNN "Digikey"
	1    2575 1400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 50CCAA70
P 1900 2900
F 0 "#PWR08" H 1900 2900 30  0001 C CNN
F 1 "GND" H 1900 2830 30  0001 C CNN
	1    1900 2900
	1    0    0    -1  
$EndComp
NoConn ~ 2250 2300
NoConn ~ 1550 2300
Text Label 1625 1150 0    40   ~ 0
5V0
Text Label 2150 1150 0    40   ~ 0
3V3
$Comp
L TXB0104D U1
U 1 1 50CCA92D
P 1900 2100
F 0 "U1" H 1900 2500 40  0000 C CNN
F 1 "TXB0104D" H 1900 2400 40  0000 C CNN
F 2 "TXB0104D" H 1900 2500 40  0001 C CNN
	1    1900 2100
	-1   0    0    -1  
$EndComp
Text Label 6175 1450 0    40   ~ 0
GND
Text Label 6425 1350 0    40   ~ 0
PC2_Pr2
Text Label 6175 1750 0    40   ~ 0
SCL
Text Notes 5150 675  0    40   ~ 0
Absolute Pressure Sensor #2 on I2C Bus
Text HLabel 6175 1350 0    40   Input ~ 0
PC2_Pr2
$Comp
L C C5
U 1 1 50BEDE7E
P 6550 950
F 0 "C5" H 6575 1025 50  0000 L CNN
F 1 "100n" H 6575 875 50  0000 L CNN
F 2 "C2" H 6575 975 50  0001 C CNN
F 4 "490-1734-1-ND" H 6550 1150 60  0001 C CNN "Digikey"
	1    6550 950 
	1    0    0    -1  
$EndComp
Text Label 6175 1250 0    40   ~ 0
5V0
$Comp
L C C13
U 1 1 50BA6860
P 7000 4600
F 0 "C13" H 7025 4700 50  0000 L CNN
F 1 "100n" H 7025 4500 50  0000 L CNN
F 2 "C2" H 7025 4600 50  0001 C CNN
F 4 "490-1734-1-ND" H 7000 4800 60  0001 C CNN "Digikey"
	1    7000 4600
	1    0    0    -1  
$EndComp
$Comp
L C C17
U 1 1 50BA6840
P 2800 6300
F 0 "C17" H 2825 6400 50  0000 L CNN
F 1 "100n" H 2825 6200 50  0000 L CNN
F 2 "C2" H 2825 6300 50  0001 C CNN
F 4 "490-1734-1-ND" H 2800 6500 60  0001 C CNN "Digikey"
	1    2800 6300
	1    0    0    -1  
$EndComp
$Comp
L C C12
U 1 1 50BA67C9
P 3200 4375
F 0 "C12" H 3225 4450 50  0000 L CNN
F 1 "100n" H 3225 4275 50  0000 L CNN
F 2 "C2" H 3225 4375 50  0001 C CNN
F 4 "490-1734-1-ND" H 3200 4575 60  0001 C CNN "Digikey"
	1    3200 4375
	1    0    0    -1  
$EndComp
$Comp
L C C10
U 1 1 50BA6794
P 3225 2500
F 0 "C10" H 3250 2575 50  0000 L CNN
F 1 "100n" H 3250 2425 50  0000 L CNN
F 2 "C2" H 3250 2525 50  0001 C CNN
F 4 "490-1734-1-ND" H 3225 2700 60  0001 C CNN "Digikey"
	1    3225 2500
	1    0    0    -1  
$EndComp
$Comp
L C C16
U 1 1 50BA6760
P 8475 6125
F 0 "C16" H 8500 6200 50  0000 L CNN
F 1 "100n" H 8500 6025 50  0000 L CNN
F 2 "c_0805" H 8500 6125 50  0001 C CNN
F 4 "490-1734-1-ND" H 8475 6325 60  0001 C CNN "Digikey"
	1    8475 6125
	1    0    0    -1  
$EndComp
$Comp
L C C6
U 1 1 50BA6744
P 10775 1000
F 0 "C6" H 10800 1075 50  0000 L CNN
F 1 "100n" H 10800 900 50  0000 L CNN
F 2 "C2" H 10800 1000 50  0001 C CNN
F 4 "490-1734-1-ND" H 10775 1200 60  0001 C CNN "Digikey"
	1    10775 1000
	1    0    0    -1  
$EndComp
Text HLabel 5300 6275 0    40   Input ~ 0
SCL
Text HLabel 5300 6175 0    40   Input ~ 0
SDA
Text HLabel 9450 900  0    40   Input ~ 0
PC1_Pulse
NoConn ~ 7825 6175
NoConn ~ 7825 6075
$Comp
L CONN_6 P22
U 1 1 50BA5D3A
P 8175 6125
F 0 "P22" V 8125 6125 60  0000 C CNN
F 1 "Temp" V 8225 6125 60  0000 C CNN
F 2 "STS21" V 8325 6125 60  0001 C CNN
F 4 "STS21" V 8325 6125 40  0000 C CNN "Part_No"
	1    8175 6125
	1    0    0    -1  
$EndComp
Text Label 9775 900  0    40   ~ 0
PC1_Pulse
Text Label 9775 1100 0    40   ~ 0
GND
Text Label 9775 1000 0    40   ~ 0
5V0
$Comp
L CONN_3 P6
U 1 1 50BA5553
P 10425 1000
F 0 "P6" V 10375 1000 50  0000 C CNN
F 1 "Pulse" V 10475 1000 50  0000 C CNN
F 2 "pin_strip_3-90" V 10575 1000 50  0001 C CNN
	1    10425 1000
	1    0    0    -1  
$EndComp
Text HLabel 5475 3875 0    40   BiDi ~ 0
5V0
Text Label 2600 5750 0    40   ~ 0
IO_R
$Comp
L DIODESCH D2
U 1 1 50BA3BBD
P 2425 6300
F 0 "D2" V 2325 6250 40  0000 C CNN
F 1 "1N5225B" H 2675 6325 40  0000 C CNN
F 2 "diode_do35" H 2675 6350 40  0001 C CNN
	1    2425 6300
	0    -1   -1   0   
$EndComp
$Comp
L R R6
U 1 1 50BA3B80
P 1975 5750
F 0 "R6" V 1950 5575 50  0000 C CNN
F 1 "220E" V 1975 5750 50  0000 C CNN
F 2 "rc03_vert" V 2075 5750 50  0001 C CNN
	1    1975 5750
	0    1    1    0   
$EndComp
Text HLabel 1375 5850 0    40   Output ~ 0
~PB1_IO_T
Text HLabel 1375 5750 0    40   Input ~ 0
PB0_IO_R
Text Label 1425 5850 0    40   ~ 0
~PB1_IO_T
Text Label 1425 5750 0    40   ~ 0
PB0_IO_R
Text Label 1800 4025 0    40   ~ 0
12V
Text Label 6750 3800 0    40   ~ 0
-Vlv
Text Label 5525 3875 0    40   ~ 0
5V0
$Comp
L CONN_3 P11
U 1 1 50B75AE4
P 5575 3600
F 0 "P11" V 5525 3600 50  0000 C CNN
F 1 "VSel_Vlv" V 5625 3600 40  0000 C CNN
F 2 "SIL-3" V 5725 3600 40  0001 C CNN
	1    5575 3600
	-1   0    0    1   
$EndComp
$Comp
L DIODE D1
U 1 1 50B7155C
P 6425 3950
F 0 "D1" V 6325 4000 40  0000 C CNN
F 1 "1N4001" H 6425 3850 40  0000 C CNN
F 2 "diode_do41" H 6425 3950 40  0001 C CNN
	1    6425 3950
	0    -1   -1   0   
$EndComp
Text HLabel 5950 4600 0    40   Input ~ 0
~PD5_Valve
Text HLabel 1375 5650 0    40   Input ~ 0
PD7_IO_X
Text HLabel 1950 5350 0    40   Input ~ 0
12V
Text HLabel 2150 3525 0    40   Input ~ 0
PD4_Flow_Rx
Text HLabel 2150 3425 0    40   Output ~ 0
PD2_Flow_Tx
Text HLabel 1050 1475 0    40   Input ~ 0
~MOSI
Text HLabel 1050 1275 0    40   Input ~ 0
~SS
Text HLabel 1050 1175 0    40   Input ~ 0
SCK
Text HLabel 1050 1075 0    40   Input ~ 0
MISO
Text HLabel 1050 975  0    40   Input ~ 0
PC3_Pr1
Text HLabel 1050 875  0    40   BiDi ~ 0
GND
Text HLabel 1050 775  0    40   BiDi ~ 0
3V3
Text Label 6125 4600 0    40   ~ 0
~PD5_Valve
Text Notes 5125 3225 0    40   ~ 0
Valve on digital PWM port\neither 12V (V_IN) or 5V0
Text Notes 700  3225 0    40   ~ 0
Flow Meter on Serial
Text Notes 700  675  0    40   ~ 0
Gage Sensor #1 on SPI Bus
Text Label 5475 3375 0    40   ~ 0
12V
$Comp
L GND #PWR09
U 1 1 50B4B058
P 6750 4975
F 0 "#PWR09" H 6750 4975 30  0001 C CNN
F 1 "GND" H 6750 4905 30  0001 C CNN
	1    6750 4975
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 50B4B052
P 2575 6625
F 0 "#PWR010" H 2575 6625 30  0001 C CNN
F 1 "GND" H 2575 6555 30  0001 C CNN
	1    2575 6625
	1    0    0    -1  
$EndComp
$Comp
L NPN Q1
U 1 1 50B4B01E
P 6650 4600
F 0 "Q1" H 6525 4525 50  0000 C CNN
F 1 "TIP112G" H 6375 4450 50  0000 C CNN
F 2 "TO220-3-V" H 6840 4600 30  0001 C CNN
	1    6650 4600
	1    0    0    -1  
$EndComp
Text Label 2600 5650 0    40   ~ 0
IO_X
$Comp
L R R5
U 1 1 50B22950
P 2275 5650
F 0 "R5" V 2250 5475 50  0000 C CNN
F 1 "220E" V 2275 5650 50  0000 C CNN
F 2 "rc03_vert" V 2375 5650 50  0001 C CNN
	1    2275 5650
	0    1    1    0   
$EndComp
$Comp
L DIODESCH D3
U 1 1 50B22921
P 2575 6300
F 0 "D3" V 2475 6250 40  0000 C CNN
F 1 "1N5225B" H 2825 6325 40  0000 C CNN
F 2 "diode_do35" H 2825 6350 40  0001 C CNN
	1    2575 6300
	0    -1   -1   0   
$EndComp
Text Notes 700  5275 0    40   ~ 0
Pump on digital port\nV_IN = 12V DC\nIO_X = 3V3 for pump control
Text Label 1425 5650 0    40   ~ 0
PD7_IO_X
Text Label 1375 6550 0    40   ~ 0
GND
Text Label 2600 5350 0    40   ~ 0
12V
$Comp
L CONN_6 P17
U 1 1 50B22337
P 3675 5600
F 0 "P17" V 3625 5600 60  0000 C CNN
F 1 "Pump_Conn" V 3725 5600 40  0000 C CNN
F 2 "Header_FTDI" V 3825 5600 40  0001 C CNN
F 4 "X200" V 3825 5600 40  0001 C CNN "Part_No"
	1    3675 5600
	1    0    0    -1  
$EndComp
Text Label 1800 4125 0    40   ~ 0
GND
NoConn ~ 3325 3925
NoConn ~ 3325 3825
NoConn ~ 3325 3725
NoConn ~ 3325 3625
Text Label 2925 3525 0    40   ~ 0
PD4_Flow_Rx
$Comp
L CONN_8 P15
U 1 1 50B21A2A
P 3675 3775
F 0 "P15" V 3625 3775 60  0000 C CNN
F 1 "Flow_Conn" V 3725 3775 60  0000 C CNN
F 2 "Conn_Flow" V 3825 3775 60  0001 C CNN
F 4 "EM1NR4R0V_1A" V 3825 3775 40  0001 C CNN "Part_No"
	1    3675 3775
	1    0    0    -1  
$EndComp
Text Label 2950 1175 0    40   ~ 0
P_SCK
NoConn ~ 3325 1375
Text Label 2950 1475 0    40   ~ 0
P_MOSI
Text Label 2950 1275 0    40   ~ 0
P_SS
Text Label 2950 1075 0    40   ~ 0
P_MISO
Text Label 2950 975  0    40   ~ 0
PC3_Pr1
Text Label 2950 875  0    40   ~ 0
GND
Text Label 2950 775  0    40   ~ 0
3V3
$EndSCHEMATC
