/* HexTo7Segment_tb
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 13th March 2022 
 *
 * Short Description
 * -----------------
 * This is a test bench module to test the HexTo7Segment Module 
 *
 */ 

`timescale 1ns / 1ps

// Test bench module declaration
module HexTo7Segment_tb;

// Inputs
reg  [3:0] hex;

// Outputs
wire [6:0] seg;

// Instantiate the debouncing Verilog code
HexTo7Segment HexTo7Segment_dut (
    .hex(hex), 
    .seg(seg)
);

initial begin
	hex = 4'b0;
end

// Loop Variables
integer inputNumber;

// Noisy input signal to simulate deboucning button press
initial begin
    //Print to console that the simulation has started.
    $display("%d ns\tSimulation Started",$time); 
    
    for (inputNumber = 0; inputNumber < 16; inputNumber = inputNumber + 1) begin
        hex = inputNumber;
        #60;

        // check if seg is correct value
        case (hex)
                4'b0000 :      	// 0
                        if (seg != ~7'b1111110) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                4'b0001 :    	// 1
                        if (seg != ~7'b0110000) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b0010 :  		// 2
                        if (seg != ~7'b1101101) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b0011 : 		// 3
                        if (seg != ~7'b1111001) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b0100 :		// 4
                        if (seg != ~7'b0110011) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b0101 :		// 5 
                        if (seg != ~7'b1011011) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end	
                    
                4'b0110 :		// 6
                        if (seg != ~7'b1011111) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b0111 :		// 7
                        if (seg != ~7'b1110000) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1000 :     	// 8
                        if (seg != ~7'b1111111) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1001 :    	// 9
                        if (seg != ~7'b1111011) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1010 :  		// A
                        if (seg != ~7'b1110111) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1011 : 		// B
                        if (seg != ~7'b0011111) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1100 :		// C
                        if (seg != ~7'b1001110) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1101 :		// D
                        if (seg != ~7'b0111101) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1110 :		// E
                        if (seg != ~7'b1001111) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
                4'b1111 :		// F
                        if (seg != ~7'b1000111) begin 
                            $display("Error!");
                        end else begin
                            $display("Success!");
                        end
                    
        endcase
    end 
    //Finished
    $display("%d ns\tSimulation Finished",$time);
end 
      
endmodule