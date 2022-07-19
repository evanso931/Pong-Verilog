/* MovePaddle
 * ----------------
 * By: Benjamin Evans
 * Date: 28/04/2022 
 *
 * Short Description
 * -----------------
 * This module is resonsable for chainging the paddles position causing
 * it move up and down the LCD 
 *   
 */

module MovePaddle #(
    parameter PADDLE_X_START_POSITION = 115,
    parameter PADDLE_Y_START_POSITION = 240,
    parameter PADDLE_Y_VELOCITY = 1,
    parameter MAX_TOP_POSITION = 185,
    parameter MIN_BOTTOM_POSITION = 305
)(   
    input           clock,
    input           reset,
    input   [1:0]   button,
    output  [7:0]   paddleXValue,
    output  [8:0]   paddleYValue
    
);

// Local Variables
reg  [7:0]  xPaddlePosition = PADDLE_X_START_POSITION ;
reg  [8:0]  yPaddlePosition = PADDLE_Y_START_POSITION;  

always @ (posedge clock) begin
    if (reset) begin 
        xPaddlePosition = PADDLE_X_START_POSITION;
        yPaddlePosition = PADDLE_Y_START_POSITION;

    end else begin
        // Y-axis Movemeant
        
        // Move Down
        if (~button[0] && yPaddlePosition < MIN_BOTTOM_POSITION) begin
            yPaddlePosition <= yPaddlePosition + PADDLE_Y_VELOCITY;
        // Move Up
        end else if (~button[1] && yPaddlePosition > MAX_TOP_POSITION) begin
            yPaddlePosition <= yPaddlePosition - PADDLE_Y_VELOCITY;
        end
    end
end

// Assign Outputs
assign paddleXValue = xPaddlePosition;
assign paddleYValue = yPaddlePosition;

endmodule