# Introduction #

Here are the step-by-step instructions for assembling the ClockTHREE. The build is divided in to three parts :

  * 'Components' - consisting of the CPU support components
  * 'LEDs' - RGB and Mono LEDs
  * 'Enclosure' - Mechanical assembly


---


each step:
  * parts
  * tools
  * procedure
  * photo


---


# Tips #
  * Take breaks often.  Fatigue will increase the possibility that you will make a mistake.
  * Soldering:
    * We assume that this is NOT your first soldering project.  If it is, we'd suggest getting a cheap learn to solder kit to get started.  If this is your first project in a while, here is a quick refresher on soldering.  The main thing is to double and triple check the part is the is in the correct place with the correct orientation (if applicable).  While de-soldering is possible, it is troublesome and time consuming and risky.  Make it a goal that you will not have to de-solder in the course of making a clock.
    * After each step, evaluate the solder joints from the front and back of the board.  On the back, the solder should be shiny and make a volcano shape as opposed to a dome shape. On the front, you should see that the solder came all the way trough the board. If you do make a mistake, don't panic.  Use a solder sucker to remove the solder and pull the piece gingerly while applying heat.  If you damage a trace in the process of de-soldering, send a picture of the damaged area and we will help you make the most of the situation.  It may be possible to "blue wire" around the damage.
    * The following parts will NOT be installed (not required)
      * CD3, rtcBoB breakout header
      * P41, STACK\_L
      * P42, STACK\_R
      * P13, ISP
      * P12, V\_OUT
      * Proto Area - left out for future experiments


---

# Gotchas #
  * he two rowBoB have different orientations.  Please study the pictures before soldering in the dimmer pots.

  * ake care when soldering the male header pins onto the rowBoBs that the



---


# CPU Support (everything but the LED array): #
Solder the CPU support hardware from lowest profile part to highest.
That way when the board is flipped over, the parts are pushed flush against the board.

---

**STEP 1**

RESISTORS : Start by soldering the resistors. The polarity (orientation) does not matter.

_Parts_

  * `R22` 10K brown-black-orange
  * `R31` 10K
  * `R17` 10K
  * `R18` 10K
  * `R19` 10K
  * `R23` 10K
  * `R25` 1K brown-black-red
  * `R26` 1K
  * `R20` 4K7 yellow-violet-red
  * `R21` 4K7
  * `R33` 680 blue-grey-brown
  * `R30` 100 brown-black-brown
the following link points to the https://lh5.googleusercontent.com/_okbbAZsA5NQ/TWJM6yEXyZI/AAAAAAAAAlk/1xoNw5hwrSw/s912/P2201543.JPG.


U5 jumper (zero ohm resistor):  There is a spot on the circuit board for a voltage regulator: U5 7805.  Since we use a 5 volt wall wart this part is unnecessary.  You will jumper over this part by soldering in a small wire between pin locations 1 and 3 (the outside holes).  We used a scrap resistor lead.

D1 jumper (zero ohm resistor):  This diode slot is to protect against reverse polarity power supplies, but comes at the expense of a fraction of a volt.  If you use the included 5V power supply, this diode is not used.  If you are using a higher voltage supply with the 7805 regulator, then please use this diode as the fraction of a volt cost is unimportant with a higher voltage supply.


---

**STEP 2**

DIODES : Next, install the DBG control diode. Orientation does matter on this part so be careful! The positive lead of a diode is called the anode and the negative lead is called the cathode.  A stripe indicates the cathode lead and must correlate to the stripe on the board.

_Parts_

D1 1N4148:  This is a fast switching diode for the DBG led.  This diode looks like a browm glass bead with a black strip on one end indicating the cathode. Make sure this strip is aligned with the white stripe on the PCB.

D3 1N4007:  This diode is not used when ClockTHREE is powered using the supplied 5V Wall Wart. This was intended as a polarity protection diode in case of a wrongly connected (reverse) input supply. Connect a jumper / zero ohm resistor instead.

---

**STEP 3**

FTDI Header: This right angle header has a low profile and is easiest to solder before the taller parts are in.  Apply a small amount of solder on each end pin, then check that the plastic is flush against the board, reheating the solder if necessary.  Then go back and solder the middle pins.

_Parts_
  * P7 : 6 way male header, right angle, FTDI


---


**STEP 4**

SMALL CAPACITORS : These come is two styles, brown ceramic labeled 104 and white plastic labeled 1J100.  Polarity does not matter on these parts.

_Parts_

  * C3 100nF
  * C6 100nF
  * C7 100nF
  * C9 100nF

---

**STEP 5**

IC SOCKETS :  All of the large ICs have sockets.  This avoids the risk of having to de-solder an IC (ick) and also eliminates the possibility of overheating the IC. Technically speaking polarity does not matter with the sockets (although the IC's themselves have polarity). There is however a preferred orienation.  The small notch on one end indicates the pin 1 slot for the IC.  The correct orientation will reinforce the correct orientation when you insert the IC.

_Parts_

  * U1 12x2 pin wide (600 mils) : Row Driver, rowBoB 1
  * U2 12x2 pin wide (600 mils) : Row Driver, rowBoB 2
  * U4 12x2 pin wide (600 mils) : Column Driver, 74HC154
  * U3 14x2 pin skinny (300 mils) : CPU, ATMega

---

**STEP 6**

BUTTONS, RIGHT ANGLED : These buttons pop into place with a small squeeze on the back pins.

_Parts_

  * Sw1 : Inc
  * Sw2 : Dec
  * Sw3 : Mode
  * Sw4 : Reset
  * Sw5 : Enter

---

**STEP 7**

SPEAKER : The polarity matters on the speaker.  The plus sign on the speaker must coincide with the plus sign on the board.  The board will accommodate two different speaker pin spacings.  Use the bottom pin and either of the top two pins, whichever is a better fit.

_Parts_

  * SP1

---

**STEP 8**

POWER JACK : Only fits one way.

_Parts_

  * J1 V\_IN

---

**STEP 9**

LED's :  Use any color you like.  One each of red and Blue LED is included in the kits.  Polarity matters.  The long lead is the anode, the short lead is the cathode.  The flat side on the silk screen image and LED indicate the cathode (short lead).

_Parts_

  * D4 PWR
  * D2 DBG


You can do a mini-smoke test after this LED is installed.
Power up the board by plugging in the wall wart into J1.  The LED should light.  If not check the connectivity of all components in the power LED circuit.

J1+ -> D3 -> U5 jumper -> '[R25](https://code.google.com/p/clockthree/source/detail?r=25)' -> D4 -> J1-

---

**STEP 10**

RESONATOR, 16 MHz : Polarity does not matter.  This is a small three-pin part in either blue or brown.  Solder in either orientation.

_Parts_

  * X1

---

**STEP 11**

HEADERS and SOCKETS : There are several of these around the board.

_Parts_

  * CD1 : 4 way male header, straight, rtcBoB
  * CD2 : 4 way male header, straight, rtcBoB  Insert CD1 and CD2 into the female headers on rtcBoB then solder them into place.  This ensures the alignments are copatible.
  * K1 : 3 way male header, straight, PWR\_SEL
  * K2 : 3 way male header, straight, LED\_ENABLE
  * [R32](https://code.google.com/p/clockthree/source/detail?r=32) : 2 way female socket, straight, LDR

After completing K1 (PWR SEL) and K2 (LED\_ENABLE), install a jumper on the right two pins of K1 for USB power, and the top two pins of K2, to isolate the LED array for the time being.  We will change both of these arrangements before the clock is complete.


---

**STEP 12**

ELECTROLYTIC CAPACITOR : These are polarized capacitors. The negative terminal of the component is marked, and also has a shorter lead.

_Parts_

  * C8, 100uF, 16V / 63V

---

**STEP 13**

TRANSISTOR : Transistors are polarized too. The flat edge of the transistor goes with the flat side of the white silkscreen marking.  Spread out the leads to install it.  Either middle pin can be used, but we find the center hole easier to solder to than the offset hole.

_Parts_

  * Q17, 2N5401


---


**STEP 14**

Smoke test


---


**Step 15**

Blink test


---

# rowBOBs #

**STEP 1**

Solder 100nF cap and 680 Ohm resistor on the bottom of each rowBoB.  The resistor label indicates 470 Ohms.  We have found in testing that 680 Ohms makes a better display and guarantees that the LED are never over driven.  Putting these parts on the bottom leaves a nice clean finish.

_Parts_

  * 00nF capacitor
  * 80 Ohm resistor


---


**STEP 2**

2K Potentiometer

**WARNING**  The the top rowBoB has the reverse orientation as the bottom rowBoB. **WARNING**

Solder the first pot on the left edge.  On on the other rowBoB, solder the pot on the left edge as shown.

_Parts_

2K pot


---


**STEP 3**

Male header pins.  Insert the pins long side down into the U1 and U2 sockets.  Place the partially completed rowBoB on the pins with the pot facing the left edge of the board.  Solder each rowBoB in place.

_Parts_
4x 1x12 male header pins


---


# LED Array #

**STEP 1**

Column resistors.

_Parts_

[R1](https://code.google.com/p/clockthree/source/detail?r=1) - [R16](https://code.google.com/p/clockthree/source/detail?r=16) 100 Ohm resistors

**STEP 2**

_Parts_

Q1 - Q16 2N5401 Transistors.  As with Q17, orientation matters.  The silk screen indicates the correct orientation.  We find that using the middle hole easier than the offset hole.


