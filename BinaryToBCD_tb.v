/* BinaryToBCD_tb
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 29th April 2022 
 *
 * Short Description
 * -----------------
 * This is a test bench module to test the BinaryToBCD Module 
 *
 * All code from - Reference: https://verilogcodes.blogspot.com/2015/10/verilog-code-for-8-bit-binary-to-bcd.html
 *
 */ 

module BinaryToBCD_tb;

    // Input
    reg [7:0] bin;
    // Output
    wire [11:0] bcd;
    // Extra variables
    reg [8:0] i;

    // Instantiate the Unit Under Test (UUT)
    BinaryToBCD BinaryToBCD_dut (
        .bin(bin), 
        .bcd(bcd)
    );

//Simulation - Apply inputs
    initial begin
    //A for loop for checking all the input combinations.
        for(i=0;i<256;i=i+1)
        begin
            bin = i; 
            #10; //wait for 10 ns.
        end 
        $finish; //system function for stoping the simulation.
    end
      
endmodule