/* MoveBall Test Bench
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 28th March 2022 
 *
 * Short Description
 * -----------------
 * This is a test bench module to test the MoveBall Module 
 * 
 * Sections of test bench code from:
 * ELEC5566M - Finite State Machines Unit2.1 - SynchronousTestBench_tb.v, pp. 19
 */ 

`timescale 1 ns/100 ps

// Test bench module declaration
module MoveBall_tb;

localparam NUM_CYCLES = 100; //Simulate this many clock cycles
localparam CLOCK_FREQ = 50000000; //Clock frequency (in Hz)
localparam RST_CYCLES = 2;        //Number of cycles of reset at beginning.
 
// Inputs
reg  clock;
reg  reset;
reg  changeXDirection;
reg  changeYDirection;

// Outputs
wire [7:0]   ballXValue;
wire [8:0]   ballYValue;
wire         direction;   // 1 = Right 

// Instantiate the MoveBall module Verilog code
MoveBall #(
  .BALL_X_START_POSITION    (209), // Start next to right paddle
  .BALL_Y_START_POSITION    (240)
) MoveBall_dut (
  .clock              (clock              ),
  .reset              (reset              ),
  .changeXDirection   (changeXDirection   ),
  .changeYDirection   (changeYDirection   ),
  .ballXValue         (ballXValue         ),
  .ballYValue         (ballYValue         ),
  .direction          (direction          )
);

//Clock generator + simulation time limit (ELEC5566M)
initial begin
  reset = 1'b1;
  repeat(RST_CYCLES) @(posedge clock);// Wait  for  a coupleof clock
  reset = 1'b0;
end

initial begin
  clock = 1'b0;
  changeXDirection = 1'b0;
  changeYDirection = 1'b0;
end

real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;

// Now generate the clock (ELEC5566M)
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

    #40
    // Goes through all possible movement directions and checks if balls updated x and y position are as expected 
    
    @(posedge clock);
    // Check Move X right
    if (ballXValue >= 209 && direction) begin 
        $display("Success!");
    end else begin
        $display("Error!");
    end

    // Change x Directions
    @(posedge clock);
    changeYDirection = 1'b1;
    changeXDirection = 1'b1;
    @(posedge clock);
    changeXDirection = 1'b0;
    changeYDirection = 1'b0;

    #100 // Wait for change in dfirection and to move back in other direction

    // Check Move X left
    if (ballXValue <= 209 && ~direction) begin 
        $display("Success!");
    end else begin
        $display("Error!");
    end

    // Check Move Y up
    if (ballXValue <= 240) begin 
        $display("Success!");
    end else begin
        $display("Error!");
    end

     // Check Move Y down
    if (ballYValue >= 240) begin 
        $display("Success!");
    end else begin
        $display("Error!");
    end


    //Finished
    $display("%d ns\tSimulation Finished",$time);
end
endmodule