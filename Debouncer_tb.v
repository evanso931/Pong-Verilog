/* Debouncer_tb
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 13th March 2022 
 *
 * Short Description
 * -----------------
 * This is a test bench module to test the ReadInput Module 
 *
 * Reference: Benjamin Evans - Debouncer_tb.v - ELEC5566M-Assignment2-evanso931
 *
 * Sections of test bench code from:
 * ELEC5566M - Finite State Machines Unit2.1 - SynchronousTestBench_tb.v, pp. 19
 */ 

`timescale 1ns / 1ps

// Test bench module declaration
module Debouncer_tb;

localparam NUM_CYCLES = 1000;    //Simulate this many clock cycles
localparam CLOCK_FREQ = 50000000; //Clock frequency (in Hz)
localparam RST_CYCLES = 2;        //Number of cycles of reset at beginning.

 // Inputs
 reg button_1;
 reg clock;

 // Outputs
 wire button_out;

 // Instantiate the debouncing Verilog code
 Debouncer Debouncer_dut (
  .asyncIn(button_1), 
  .clock(clock), 
  .syncOut(button_out)
 );

//Clock generator + simulation time limit (ELEC5566M)
initial begin
    repeat(RST_CYCLES) @(posedge clock);// Wait  for  a coupleof clock
end

initial begin
    clock = 1'b0;
	button_1 = 1'b0;
end

real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;

//Now generate the clock (ELEC5566M)
integer half_cycles = 0;
always begin
    //Generate the next half cycle of clock
    #(HALF_CLOCK_PERIOD);          //Delay for half a clock period.
    clock = ~clock;                //Toggle the clock
    half_cycles = half_cycles + 1; //Increment the counter
    
    //Check if we have simulated enough half clock cycles
    if (half_cycles == (2*NUM_CYCLES)) begin 
        //Once the number of cycles has been reached
		half_cycles = 0; 		   //Reset half cycles, so if we resume running with "run -all", we perform another chunk.
        $stop;                     //Break the simulation
        //Note: We can continue the simualation after this breakpoint using 
        //"run -continue" or "run ### ns" in modelsim.
    end
end

// Noisy input signal to simulate deboucning button press
initial begin
    //Print to console that the simulation has started.
    $display("%d ns\tSimulation Started",$time); 

    #60;
    button_1 = 0;
    #20;
    button_1=1;
    #1
    button_1 = 0;
    #1;
    button_1=1;
    #1
    button_1 = 0;
    #1;
    button_1=1;
    #1
    button_1 = 0;
    #1;
    button_1=1;
    #30; 
    button_1 = 0;
    #1;
    button_1=1;
    #1
    button_1 = 0;
    #1;
    button_1=1;
    #1
    button_1 = 0;
    #20;
    
    //Finished
    $display("%d ns\tSimulation Finished",$time);
end 
      
endmodule