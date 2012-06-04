EESchema Schematic File Version 2  date 6/4/2012 5:05:30 PM
LIBS:BatMon
LIBS:power
LIBS:BatMon-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 2 2
Title "BatMon - Car Battery Voltage Monitor"
Date "4 jun 2012"
Rev "A"
Comp "it's not Bat Man"
Comment1 "www.wyolum.com"
Comment2 "wyojustin@gmail.com :: anool.m@gmail.com"
Comment3 "part of the project inspired from : http://www.evilmadscientist.com/article.php/peggy2"
Comment4 ""
$EndDescr
Wire Notes Line
	750  7700 750  5500
Wire Notes Line
	750  7700 6050 7700
Wire Notes Line
	6050 7700 6050 5500
Wire Notes Line
	6050 5500 750  5500
Connection ~ 1750 5750
Wire Wire Line
	1700 5750 1750 5750
Connection ~ 950  5750
Wire Wire Line
	1000 5750 950  5750
Wire Wire Line
	1700 5850 1750 5850
Wire Wire Line
	1750 5850 1750 5650
Wire Wire Line
	1750 5650 1700 5650
Wire Wire Line
	1000 5850 950  5850
Wire Wire Line
	950  5850 950  5650
Wire Wire Line
	950  5650 1000 5650
Wire Wire Line
	1000 6000 950  6000
Wire Wire Line
	950  6000 950  6200
Wire Wire Line
	950  6200 1000 6200
Wire Wire Line
	1700 6000 1750 6000
Wire Wire Line
	1750 6000 1750 6200
Wire Wire Line
	1750 6200 1700 6200
Wire Wire Line
	1000 6100 950  6100
Connection ~ 950  6100
Wire Wire Line
	1700 6100 1750 6100
Connection ~ 1750 6100
$Comp
L DIL6 P25
U 1 1 4C9A353B
P 1350 6100
F 0 "P25" V 1350 6100 60  0000 C CNN
F 1 "DIL6" V 1350 6100 50  0001 C CNN
F 2 "PROTO-6" H 1350 6100 60  0001 C CNN
	1    1350 6100
	1    0    0    -1  
$EndComp
$Comp
L DIL6 P24
U 1 1 4C9A34A2
P 1350 5750
F 0 "P24" V 1350 5750 60  0000 C CNN
F 1 "DIL6" V 1350 5750 50  0001 C CNN
F 2 "PROTO-6" H 1350 5750 60  0001 C CNN
	1    1350 5750
	1    0    0    -1  
$EndComp
Text Notes 5400 7650 0    60   ~ 0
PROTO AREA
$EndSCHEMATC
