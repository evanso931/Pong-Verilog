/* HexTo7Segment
 * ----------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 26th April 2022
 *
 * Description
 * ------------
 * The module is a a exadecimal to 7-segment encoder
 *
 * Reference: Benjamin Evans - HexTo7Segment.v - ELEC5566M-Unit1-evanso931
 *
 */
 
 module HexTo7Segment#(
	parameter INVERT_OUTPUT = 1
 )( 
    input  [3:0] hex,
    output reg [6:0] seg
);
    // Hex input conversion to 7-segment output bits
    always @ * begin
        // Hex input to segment output
        case (hex)
            4'b0000 :      	// 0
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1111110;
					end else begin
						seg = 7'b1111110;
					end
				
            4'b0001 :    	// 1
					if (INVERT_OUTPUT) begin 
						seg = ~7'b0110000;
					end else begin
						seg = 7'b0110000;
					end
				
            4'b0010 :  		// 2
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1101101;
					end else begin
						seg = 7'b1101101;
					end
				
            4'b0011 : 		// 3
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1111001;
					end else begin
						seg = 7'b1111001;
					end
				
            4'b0100 :		// 4
					if (INVERT_OUTPUT) begin 
						seg = ~7'b0110011;
					end else begin
						seg = 7'b0110011;
					end
				
            4'b0101 :		// 5 
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1011011;
					end else begin
						seg = 7'b1011011;
					end	
				
            4'b0110 :		// 6
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1011111;
					end else begin
						seg = 7'b1011111;
					end
				
            4'b0111 :		// 7
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1110000;
					end else begin
						seg = 7'b1110000;
					end
				
            4'b1000 :     	// 8
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1111111;
					end else begin
						seg = 7'b1111111;
					end
				
            4'b1001 :    	// 9
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1111011;
					end else begin
						seg = 7'b1111011;
					end
				
            4'b1010 :  		// A
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1110111;
					end else begin
						seg = 7'b1110111;
					end
				
            4'b1011 : 		// B
					if (INVERT_OUTPUT) begin 
						seg = ~7'b0011111;
					end else begin
						seg = 7'b0011111;
					end
				
            4'b1100 :		// C
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1001110;
					end else begin
						seg = 7'b1001110;
					end
				
            4'b1101 :		// D
					if (INVERT_OUTPUT) begin 
						seg = ~7'b0111101;
					end else begin
						seg = 7'b0111101;
					end
				
            4'b1110 :		// E
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1001111;
					end else begin
						seg = 7'b1001111;
					end
				
            4'b1111 :		// F
					if (INVERT_OUTPUT) begin 
						seg = ~7'b1000111;
					end else begin
						seg = 7'b1000111;
					end
				
        endcase
    end

endmodule