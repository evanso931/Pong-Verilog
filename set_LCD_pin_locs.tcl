# Reference: Some code from - FPGAHardware unit 3.2 - set_LCD_pin_locs.tcl

# Requre quartus project
package require ::quartus::project

# Set pin locations for LCD on GPIO 0
set_location_assignment PIN_AJ17 -to LT24Data[0]
set_location_assignment PIN_AJ19 -to LT24Data[1]
set_location_assignment PIN_AK19 -to LT24Data[2]
set_location_assignment PIN_AK18 -to LT24Data[3]
set_location_assignment PIN_AE16 -to LT24Data[4]
set_location_assignment PIN_AF16 -to LT24Data[5]
set_location_assignment PIN_AG17 -to LT24Data[6]
set_location_assignment PIN_AA18 -to LT24Data[7]
set_location_assignment PIN_AA19 -to LT24Data[8]
set_location_assignment PIN_AE17 -to LT24Data[9]
set_location_assignment PIN_AC20 -to LT24Data[10]
set_location_assignment PIN_AH19 -to LT24Data[11]
set_location_assignment PIN_AJ20 -to LT24Data[12]
set_location_assignment PIN_AH20 -to LT24Data[13]
set_location_assignment PIN_AK21 -to LT24Data[14]
set_location_assignment PIN_AD19 -to LT24Data[15]
set_location_assignment PIN_AG20 -to LT24Reset_n
set_location_assignment PIN_AG16 -to LT24RS
set_location_assignment PIN_AD20 -to LT24CS_n
set_location_assignment PIN_AH18 -to LT24Rd_n
set_location_assignment PIN_AH17 -to LT24Wr_n
set_location_assignment PIN_AJ21 -to LT24LCDOn

# Set pin location for Clock
set_location_assignment PIN_AA16 -to clock

# Set pin location for button inputs
set_location_assignment PIN_AA14 -to key0
set_location_assignment PIN_AA15 -to key1
set_location_assignment PIN_W15 -to key2
set_location_assignment PIN_Y16 -to key3

# Set pin location for seven segment displays
# Seg 0
set_location_assignment PIN_AH28 -to segZero[0]
set_location_assignment PIN_AG28 -to segZero[1]
set_location_assignment PIN_AF28 -to segZero[2]
set_location_assignment PIN_AG27 -to segZero[3]
set_location_assignment PIN_AE28 -to segZero[4]
set_location_assignment PIN_AE27 -to segZero[5]
set_location_assignment PIN_AE26 -to segZero[6]
# Seg 1
set_location_assignment PIN_AD27 -to segOne[0]
set_location_assignment PIN_AF30 -to segOne[1]
set_location_assignment PIN_AF29 -to segOne[2]
set_location_assignment PIN_AG30 -to segOne[3]
set_location_assignment PIN_AH30 -to segOne[4]
set_location_assignment PIN_AH29 -to segOne[5]
set_location_assignment PIN_AJ29 -to segOne[6]
# Seg 4
set_location_assignment PIN_W25 -to segFour[0]
set_location_assignment PIN_V23 -to segFour[1]
set_location_assignment PIN_W24 -to segFour[2]
set_location_assignment PIN_W22 -to segFour[3]
set_location_assignment PIN_Y24 -to segFour[4]
set_location_assignment PIN_Y23 -to segFour[5]
set_location_assignment PIN_AA24 -to segFour[6]
# Seg 5
set_location_assignment PIN_AA25 -to segFive[0]
set_location_assignment PIN_AA26 -to segFive[1]
set_location_assignment PIN_AB26 -to segFive[2]
set_location_assignment PIN_AB27 -to segFive[3]
set_location_assignment PIN_Y27 -to segFive[4]
set_location_assignment PIN_AA28 -to segFive[5]
set_location_assignment PIN_V25 -to segFive[6]

# Set pin location for resetApp
set_location_assignment PIN_V16 -to resetApp

# Commit assignments
export_assignments
