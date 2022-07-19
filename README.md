# Pong - Verilog

FPGA Verilog project of the arcade game Pong for the DE1-SoC board

Pong has been programmed in Verilog for the DE1-SoC board. The game runs very efficiently by programming an FPGA, which improves the LT24 display performance. To have a worthy opponent to play against, an AI has been programmed to control the other paddles movement. This project meets all of the minimum requirements and most of the further requirements by using complex Verilog programming techniques. 

The following files are provided:

| File | Purpose |
| ---  | --- |
| `BinaryToBCD.v` | This module converts binary numbers into binary coded decimal |
| `BinaryToBCD_tb.v` | This is a test bench module to test the BinaryToBCD Module   |
| `CounterNbit.v` | This is a n bit counter and will be used to count the number of button inputs |
| `CounterNBit_tb.v` | This is a test bench module to test the CounterNBit Module   |
| `Debouncer .v` | This is a button debouncer module to synchronise the button input to the clock and remove noise from input button press |
| `Debouncer_tb.v` | This is a test bench module to test the ReadInput Module  |
| `GameEngine.v` | The GameEngine module interface with the LT24 Display Module from Terasic. It makes use of the LT24Display IP core. It also produces the game elementes and calacuted the game physics and mechanics. |
| `HexTo7Segment.v` | The module is a a exadecimal to 7-segment encoder |
| `HexTo7Segment_tb.v` | This is a test bench module to test the HexTo7Segment Module  |
| `LT24Display.sdc.v` | he purpose of this file is to tell Quartus what the timing requirements of the design are so that it can try to make sure the design can run as fast as we require without any glitches caused by propagation delays, etc.  |
| `LT24Display.v` | This module is designed to interface with the LT24 Display Module from Terasic. It provides functionality to initialise the display and to allow individually addressed pixels to be written to the internal frame buffer of the LT24.|
| `MoveBall.v` | his module is responsable for chainging the balls position causing it move acrros the LCD |
| `MoveBall_tb.v` | This is a test bench module to test the MoveBall Module  |
| `MovePaddle.v` | This module is resonsable for chainging the paddles position causing it move up and down the LCD |
| `MovePaddle_tb.v` | This is a test bench module to test the MovePaddle Module |
| `Pong.v` | This is the top level Pong module which contain a FSM to control Gameplay  |
| `RefreshRate.v` | This reduces the 50,000,000 Hz clock to a set x Hz to be used for the refresh rate of element on the screen and control there movement screen  |
| `RefreshRate_tb.v` | This is a test bench module to test the RefreshRate Module   |
| `UpCounterNbit.v` | This module is a simple up-counter with a count enable. The counter has parameter controlled width, increment, and maximum value.|
| `set_LCD_pin_locs.tcl` | Script to automatically assign hardware pins |
| `ELEC5566M-Mini-Project-evanso931.qpf` | Quartus project file |
| `ELEC5566M-Mini-Project-evanso931.qsf` | Quartus settings file |
| `Pictures/*`             | Diagrams of the digital lock structure |


Pong High-Level System Block Diagram

![alt text](https://github.com/leeds-embedded-systems/ELEC5566M-Mini-Project-evanso931/blob/main/Pictures/Pong%20FPGA%20High-Level%20System%20Diagram.png?raw=true)

Pong File Hierarchy Block Diagram

![alt text](https://github.com/leeds-embedded-systems/ELEC5566M-Mini-Project-evanso931/blob/main/Pictures/Pong%20File%20Hierarchy.png?raw=true)

Pong State Machine

![alt text](https://github.com/leeds-embedded-systems/ELEC5566M-Mini-Project-evanso931/blob/main/Pictures/Pong%20Finite%20State%20Machine.png?raw=true)
