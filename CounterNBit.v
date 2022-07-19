/* CounterNbit
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 12th March 2022 
 *
 * Short Description
 * -----------------
 * This is a n bit counter and will be used to count the number of button inputs
 * 
 * Reference: Benjamin Evans - CounterNbit.v - ELEC5566M-Assignment2-evanso931
 *
 * Code taken from:
 * ELEC5566M – Synchronous Logic Unit2.1 - CounterNBit.v, pp. 11
 */ 

module CounterNBit #(
    //Parameter list within the #(...)
    parameter WIDTH = 10,                //Default to 10bits wide 
    parameter INCREMENT = 1,             //Amount to increment counter by each cycle
    parameter MAX_VALUE = (2**WIDTH)-1   //e.g. Maximum value default is 2^WIDTH - 1
)(
    //Port list within the (...) as before
    input                    clock, 
    input                    reset,
    input                    enable,
    output reg [(WIDTH-1):0] countValue  //Output is declared as "WIDTH" bits wide
);

localparam ZERO = {(WIDTH){1'b0}}; //A local parameter. The value 0, WIDTH bits wide.

always @(posedge clock or posedge reset) begin
    if (reset) begin
    countValue <= ZERO;
    end else if (countValue == MAX_VALUE) begin
    countValue <= ZERO;
    end else if (enable) begin 
    countValue <= countValue + INCREMENT;
    end
end

endmodule
