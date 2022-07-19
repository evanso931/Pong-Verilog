/* Refresh Rate
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 28th April 2022 
 *
 * Short Description
 * -----------------
 * This reduces the 50,000,000 Hz clock to a set x Hz to be used for the refresh rate
 * of element on the screen and control there movement screen
 */ 

module RefreshRate #(														
	parameter 	REFRESH_RATE = 100,				// The rate that the output triggers high
	parameter 	MAX_VALUE = (50000000/REFRESH_RATE)/2,    // Max value to count too
	parameter	WIDTH = 32,								
	parameter   INCREMENT = 1                                   
	
)(
    input     	clock,														
    input       reset,														
    output reg 	refreshRate													
);

// Wire for countValue from CounterNBit
wire [(WIDTH-1):0] countValue; 								
													
// CounterNBit module to count to Max_Value
CounterNBit #(
	.WIDTH			(WIDTH   	),
	.MAX_VALUE	  	(MAX_VALUE	),
	.INCREMENT	  	(INCREMENT	)

) CounterNBit(
	.clock		  	(clock		),
	.reset	  		(reset		),
	.enable      	(1'b1		),
	.countValue	    (countValue	)
);

// Produces a clock signal of set frequency defined by max value
always @(posedge clock or posedge reset) begin																				
	if (reset) begin
		refreshRate <= 1'b0;	

	end else if (countValue == MAX_VALUE - 1 ) begin 
		refreshRate <= ~ refreshRate;							
	end
end
	
endmodule