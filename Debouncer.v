/* Debouncer 
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 12th March 2022 
 *
 * Short Description
 * -----------------
 * This is a button debouncer module to synchronise the button input to the clock
 * and remove noise from input button press
 *
 * Reference: Benjamin Evans - Debouncer.v - ELEC5566M-Assignment2-evanso931
 *
 * Code taken from:
 * ELEC5566M - Finite State Machines Unit2.2 -  NBitSynchroniser.v, pp. 19
 */ 
 
module Debouncer #(
    parameter WIDTH = 1,  // Number of bits wide
    parameter LENGTH = 2  // 2-flop synchroniser by default
)(
    //Asynchronous Input
    input  [WIDTH-1:0] asyncIn,
    //Clock and Synchronous Output
    input              clock,
    output [WIDTH-1:0] syncOut
);

// A chain of register for each bit
reg [WIDTH-1:0] syncChain [LENGTH-1:0];

// The first register is most likely to go metastable as it reads asyncIn directly
always @ (posedge clock) begin
    syncChain[0] <= asyncIn;
end

// Subsequent registers reduce the probability of the metastable state propagating
genvar i;
generate for (i = 1; i < LENGTH; i = i + 1) begin : sync_loop
    // For each stage in the synchroniser, add a register
    always @ (posedge clock) begin
        syncChain[i] <= syncChain[i-1];
    end
end endgenerate

// The output comes from the end of the synchroniser chain
assign syncOut = syncChain[LENGTH-1];

endmodule
