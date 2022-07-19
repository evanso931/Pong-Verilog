/* MoveBall
 * ----------------
 * By: Benjamin Evans
 * Date: 28/04/2022 
 *
 * Short Description
 * -----------------
 * This module is responsable for chainging the balls position causing
 * it move acrros the LCD 
 *   
 */

module MoveBall #(
    parameter BALL_X_START_POSITION = 115,
    parameter BALL_Y_START_POSITION = 240,
    parameter BALL_X_VELOCITY = 1,
    parameter BALL_Y_VELOCITY = 1,
    parameter MAX_TOP_POSITION = 175,
    parameter MIN_BOTTOM_POSITION = 310
)(   
    input           clock,
    input           reset,
    input           changeXDirection, // Hit Paddle
    input   [1:0]   changeYDirection, // Bit 1 == hit top half, Bit 0 == hit bottom half
    output  [7:0]   ballXValue,
    output  [8:0]   ballYValue,
    output          direction
    
);

// Local Variables
reg  [7:0]  xBallPosition = BALL_X_START_POSITION;
reg  [8:0]  yBallPosition = BALL_Y_START_POSITION; 
reg         xDirection = 1'b0; // 1 = Right, 0 = Left
reg         yDirection = 1'b0; // 1 = Down, 0 = Up

always @ (posedge clock) begin
    if (reset) begin 
        // Causes next ball to be served towards to conceding point player in a random direction
        // as only resetting x psotion 
        xBallPosition = BALL_X_START_POSITION;

    end else begin
        // X-axis Movemeant
        // Hit Paddles
        if (changeXDirection) begin
            // Right Paddle
            if (ballXValue >= 220 - 5 - 5) begin
                 xDirection <= 1'b0;
            end

            // Left Paddle
            if (ballXValue <= 20 + 5 + 5) begin
                 xDirection <= 1'b1;
            end
        end

        // Move Right
        if (xDirection) begin
            xBallPosition <= xBallPosition + BALL_X_VELOCITY;
        // Move Left
        end else if (~xDirection) begin
            xBallPosition <= xBallPosition - BALL_X_VELOCITY;
        end


        // Y-axis Movemeant
        // Hit Top half of Paddles
        if (changeYDirection[1]) begin
            // Ball Moving Down
            if (yDirection == 1'b1) begin
                yDirection <= 1'b0; // Change to Move Upwards
            end

        // Hit bottom half of paddles
        end else if (changeYDirection[0]) begin 
            // Ball Moving up
            if (yDirection == 1'b0) begin
                yDirection <= 1'b1; // Change to Move Down
            end
        end

        // Bounce of top and bottom walls 
        if (yDirection && yBallPosition >  MIN_BOTTOM_POSITION) begin 
            yDirection <= ~yDirection;
        end else if (~yDirection && yBallPosition <  MAX_TOP_POSITION) begin
            yDirection <= ~yDirection;
        end 
        
        // Move Down
        if (yDirection) begin
            yBallPosition <= yBallPosition + BALL_Y_VELOCITY;
        // Move Up
        end else if (~yDirection ) begin
            yBallPosition <= yBallPosition - BALL_Y_VELOCITY;
        end
    end
end

// Assign Outputs
assign ballXValue = xBallPosition;
assign ballYValue = yBallPosition;
assign direction = xDirection;

endmodule