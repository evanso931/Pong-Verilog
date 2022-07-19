/* CounterNBit Test Bench
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 12th March 2022 
 *
 * Short Description
 * -----------------
 * This is a test bench module to test the CounterNBit Module 
 *
 * Reference: Benjamin Evans - CounterNbit_tb.v - ELEC5566M-Assignment2-evanso931
 * 
 * Sections of test bench code from:
 * ELEC5566M - Finite State Machines Unit2.1 - SynchronousTestBench_tb.v, pp. 19
 */ 

`timescale 1 ns/100 ps

// Test bench module declaration
module CounterNBit_tb;

localparam NUM_CYCLES = 100;    //Simulate this many clock cycles
localparam CLOCK_FREQ = 50000000; //Clock frequency (in Hz)
localparam RST_CYCLES = 2;        //Number of cycles of reset at beginning.
 
// Inputs
reg  clock;
reg  reset;
reg  enable;

// Outputs
wire  [3:0] countValue;

// Instantiate the CounterNBit Verilog code
CounterNBit CounterNBit_dut (
  .clock      (clock     ),
  .reset      (reset     ),
  .enable     (enable    ),
  .countValue (countValue)
);

//Clock generator + simulation time limit (ELEC5566M)
initial begin
  reset = 1'b1;
  repeat(RST_CYCLES) @(posedge clock);// Wait  for  a coupleof clock
  reset = 1'b0;
end

initial begin
  clock = 1'b0;
	enable = 1'b0;
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

// Test Bench Logic
initial begin
  //Print to console that the simulation has started.
  $display("%d ns\tSimulation Started",$time);  

  enable = 1'b1;
  #100

  //Finished
  $display("%d ns\tSimulation Finished",$time);
end
endmodule

