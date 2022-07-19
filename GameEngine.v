/* GameEngine
 * ------------------------
 * By: Benjamin Evans
 * Date: 29th April 2022
 *
 * Short Description
 * -----------------
 * The GameEngine module interface with the LT24 Display Module
 * from Terasic. It makes use of the LT24Display IP core.
 * It also produces the game elementes and calacuted the game 
 * physics and mechanics.
 *
 * Reference: Some code by Thomas Carpenter - FPGAHardware unit 3.2 - LT24Top.v
 */

module GameEngine #(
    BALL_SIZE = 5,
    PADDLE_WIDTH = 5,
    PADDLE_HIGHT = 15
)(
    // Global Clock/Reset/Pause
    input              clock,
    input              reset,
    output             resetApp,
  
    // Button Inputs
    input              rightPaddleUp,
    input              rightPaddleDown,

    // Seven Segment Displays 
    output [6:0]       segFour,
    output [6:0]       segFive,
    output [6:0]       segZero,
    output [6:0]       segOne,

    // LT24 Interface
    output             LT24Wr_n,
    output             LT24Rd_n,
    output             LT24CS_n,
    output             LT24RS,
    output             LT24Reset_n,
    output [15:0]      LT24Data,
    output             LT24LCDOn
);

// Variables ---------------------------------------------------------
// LCD Local Variables
reg  [ 7:0] xAddr;
reg  [ 8:0] yAddr;
reg  [15:0] pixelData;
wire        pixelReady;
reg         pixelWrite;
wire        refreshClockPaddles;
wire        refreshClockBall;

// Ball Local Variables
wire [7:0] xBallPosition;
wire [8:0] yBallPosition;
wire       ballPaddleCollision; // effects x value
wire [1:0] ballPaddleHalfCollision; // Top or bottom half paddle effects y value, bit 1 = top, bit 0 = bottom
wire       direction;
reg        resetBall = 1'b0;

// Right Paddle Local Variables
wire [7:0] xPaddleRightPosition;
wire [8:0] yPaddleRightPosition;
reg       leftPaddleUp;
reg       leftPaddleDown;

// Left Paddle Local Variables
wire [7:0] xPaddleLeftPosition;
wire [8:0] yPaddleLeftPosition;

// Score Local Variables
reg  [7:0] leftPaddleScore;
reg  [7:0] rightPaddleScore;
wire [11:0] leftPaddleBCD;
wire [11:0] rightPaddleBCD;

// Ball Paddle x direction Collision Physics
assign ballPaddleCollision = (yBallPosition >= yPaddleRightPosition - PADDLE_HIGHT - BALL_SIZE &&
                              yBallPosition <= yPaddleRightPosition + PADDLE_HIGHT + BALL_SIZE &&
                              xBallPosition == xPaddleRightPosition - PADDLE_WIDTH - BALL_SIZE ||

                              yBallPosition >= yPaddleLeftPosition - PADDLE_HIGHT - BALL_SIZE &&
                              yBallPosition <= yPaddleLeftPosition + PADDLE_HIGHT + BALL_SIZE &&
                              xBallPosition == xPaddleLeftPosition + PADDLE_WIDTH + BALL_SIZE 
                             ) ? 1'b1 : 1'b0;
// Ball Hits Top Half of Paddle                             
assign ballPaddleHalfCollision[1] = (yBallPosition >= yPaddleRightPosition - PADDLE_HIGHT - BALL_SIZE &&
                                  yBallPosition <= yPaddleRightPosition &&
                                  xBallPosition == xPaddleRightPosition - PADDLE_WIDTH - BALL_SIZE ||

                                  yBallPosition >= yPaddleLeftPosition - PADDLE_HIGHT - BALL_SIZE &&
                                  yBallPosition <= yPaddleLeftPosition &&
                                  xBallPosition == xPaddleLeftPosition + PADDLE_WIDTH + BALL_SIZE  
                                 ) ? 1'b1 : 1'b0;

// Ball Hits Top Half of Paddle                             
assign ballPaddleHalfCollision[0] = (yBallPosition <= yPaddleRightPosition + PADDLE_HIGHT + BALL_SIZE &&
                                  yBallPosition >= yPaddleRightPosition &&
                                  xBallPosition == xPaddleRightPosition - PADDLE_WIDTH - BALL_SIZE ||

                                  yBallPosition <= yPaddleLeftPosition + PADDLE_HIGHT + BALL_SIZE &&
                                  yBallPosition >= yPaddleLeftPosition &&
                                  xBallPosition == xPaddleLeftPosition - PADDLE_WIDTH - BALL_SIZE  
                                 ) ? 1'b1 : 1'b0;


// Module Instantiations ----------------------------------------------------------------------
// LCD Display Module
localparam LCD_WIDTH  = 240;
localparam LCD_HEIGHT = 320;
LT24Display #(
    .WIDTH       (LCD_WIDTH  ),
    .HEIGHT      (LCD_HEIGHT ),
    .CLOCK_FREQ  (50000000   )
) Display (
    //Clock and Reset In
    .clock       (clock      ),
    .globalReset (reset      ),
    //Reset for User Logic
    .resetApp    (resetApp   ),
    //Pixel Interface
    .xAddr       (xAddr      ),
    .yAddr       (yAddr      ),
    .pixelData   (pixelData  ),
    .pixelWrite  (pixelWrite ),
    .pixelReady  (pixelReady ),
    //Use pixel addressing mode
    .pixelRawMode(1'b0       ),
    //Unused Command Interface
    .cmdData     (8'b0       ),
    .cmdWrite    (1'b0       ),
    .cmdDone     (1'b0       ),
    .cmdReady    (           ),
    //Display Connections
    .LT24Wr_n    (LT24Wr_n   ),
    .LT24Rd_n    (LT24Rd_n   ),
    .LT24CS_n    (LT24CS_n   ),
    .LT24RS      (LT24RS     ),
    .LT24Reset_n (LT24Reset_n),
    .LT24Data    (LT24Data   ),
    .LT24LCDOn   (LT24LCDOn  )
);

// X Counter
wire [7:0] xCount;
UpCounterNbit #(
    .WIDTH     (         8 ),
    .MAX_VALUE (LCD_WIDTH-1)
) xCounter (
    .clock     (clock     ),
    .reset     (resetApp  ),
    .enable    (pixelReady),
    .countValue(xCount    )
);

// Y Counter
wire [8:0] yCount;
wire yCntEnable = pixelReady && (xCount == (LCD_WIDTH-1));
UpCounterNbit #(
    .WIDTH     (           9),
    .MAX_VALUE (LCD_HEIGHT-1)
) yCounter (
    .clock     (clock     ),
    .reset     (resetApp  ),
    .enable    (yCntEnable),
    .countValue(yCount    )
);

// Refresh Rate For Paddles
RefreshRate #(
    .REFRESH_RATE (110)				
) RefreshRatePaddles (
    .clock              (clock	  	            ),			
    .reset		  	    (reset	                ),
    .refreshRate    	(refreshClockPaddles    )
);

// Refresh Rate For Ball
RefreshRate #(
    .REFRESH_RATE (140)				
) RefreshRateBall (
    .clock              (clock	  	        ),			
    .reset		  	    (reset	            ),
    .refreshRate    	(refreshClockBall   )
);

// Move Ball
MoveBall #(
    .BALL_X_VELOCITY      (1),
    .BALL_Y_VELOCITY      (1)
) MoveBall (
    .clock              (refreshClockBall           ),
    .reset              (resetBall                  ),
    .changeXDirection   (ballPaddleCollision        ),
    .changeYDirection   (ballPaddleHalfCollision    ),
    .ballXValue         (xBallPosition              ),
    .ballYValue         (yBallPosition              ),
    .direction          (direction                  )
);

// Move Right Paddle
MovePaddle #(
    .PADDLE_X_START_POSITION    (220),
    .PADDLE_Y_START_POSITION    (240)
) MovePaddleRight (
    .clock              (refreshClockPaddles             ),
    .reset              (resetApp                        ),
    .button             ({rightPaddleUp,rightPaddleDown} ),
    .paddleXValue       (xPaddleRightPosition            ),
    .paddleYValue       (yPaddleRightPosition            )
);

// Move Left Paddle
MovePaddle #(
    .PADDLE_X_START_POSITION    (20 ),
    .PADDLE_Y_START_POSITION    (240)
) MovePaddleLeft (
    .clock              (refreshClockPaddles              ),
    .reset              (resetApp                         ),
    .button             ({leftPaddleUp,leftPaddleDown}    ),
    .paddleXValue       (xPaddleLeftPosition              ),
    .paddleYValue       (yPaddleLeftPosition              )
);

// Displays Left Paddle Score on seven seg 4 and 5
HexTo7Segment LeftPaddleScoreFive (
	.hex (leftPaddleBCD[7:4]),
	.seg (segFive)   
);
HexTo7Segment LeftPaddleScoreFour (
	.hex (leftPaddleBCD[3:0]),
	.seg (segFour)   
);
BinaryToBCD LeftPaddleBCD (
    .bin (leftPaddleScore),
    .bcd (leftPaddleBCD)
);

// Displays Right Paddle Score on seven seg 0 and 1
HexTo7Segment RightPaddleScoreOne (
	.hex (rightPaddleBCD[7:4]),
	.seg (segOne)   
);
HexTo7Segment RightPaddleScoreZero (
	.hex (rightPaddleBCD[3:0]),
	.seg (segZero)   
);
BinaryToBCD RightPaddleBCD (
    .bin (rightPaddleScore),
    .bcd (rightPaddleBCD)
);


// Procedural BLocks ------------------------------------------------------------------------
// Pixel Write
always @ (posedge clock or posedge resetApp) begin
    if (resetApp) begin
        pixelWrite <= 1'b0;
    end else begin
        //In this example we always set write high, and use pixelReady to detect when
        //to update the data.
        pixelWrite <= 1'b1;
        //You could also control pixelWrite and pixelData in a State Machine.
    end
end

// Draw Elements
always @ (posedge clock or posedge resetApp) begin
    if (resetApp) begin
        pixelData           <= 16'b0;
        xAddr               <= 8'b0;
        yAddr               <= 9'b0;
    end else if (pixelReady) begin
        //X/Y Address are just the counter values
        xAddr               <= xCount;
        yAddr               <= yCount;

        // set whole new screen frame black
        pixelData    <= 16'h0000;  
        
        // Draw Ball
        if (xCount > xBallPosition - BALL_SIZE && xCount < xBallPosition + BALL_SIZE && 
        yCount > yBallPosition - BALL_SIZE && yCount < yBallPosition + BALL_SIZE) begin 
            pixelData    <= 16'hFFFF;
        end 
        
        // Draw Right Paddle
        if (xCount > xPaddleRightPosition - PADDLE_WIDTH && xCount < xPaddleRightPosition + PADDLE_WIDTH && 
        yCount > yPaddleRightPosition - PADDLE_HIGHT && yCount < yPaddleRightPosition + PADDLE_HIGHT) begin 
            pixelData    <= 16'hFFFF;
        end 
           
        // Draw Left Paddle
        if (xCount > xPaddleLeftPosition - PADDLE_WIDTH && xCount < xPaddleLeftPosition + PADDLE_WIDTH && 
        yCount > yPaddleLeftPosition - PADDLE_HIGHT && yCount < yPaddleLeftPosition + PADDLE_HIGHT) begin 
            pixelData    <= 16'hFFFF;
        end 

        // Draw Top Wall
        if (xCount > 0 && xCount < 239 && 
        yCount > 165 && yCount < 170) begin 
            pixelData    <= 16'h3186;
        end
    end
end

// Left Paddle AI movement
always @(posedge clock) begin
    // Stop moving if ball is moving away
    leftPaddleDown <= 1'b1;
    leftPaddleUp <= 1'b1;

    // Ball is moving left - try to hit ball
    if (direction == 0) begin
        // Ball Lower than paddle
        if (yPaddleLeftPosition >= yBallPosition) begin
            leftPaddleDown <= 1'b1;
            leftPaddleUp <= 1'b0;

        // Ball higher than paddle
        end else if (yPaddleLeftPosition < yBallPosition)begin
            leftPaddleUp <= 1'b1;
            leftPaddleDown <= 1'b0;
        end

    // Ball is moving right - move paddle to middle
    end else begin 
        // Paddle Higher than middle
        if (yPaddleLeftPosition > 241) begin
            leftPaddleDown <= 1'b1;
            leftPaddleUp <= 1'b0;

        // Paddle Lower than middle
        end else if (yPaddleLeftPosition < 239)begin
            leftPaddleUp <= 1'b1;
            leftPaddleDown <= 1'b0;
        end else begin
            leftPaddleDown <= 1'b1;
            leftPaddleUp <= 1'b1;
        end 
    end 
end

// Score Calculator
always @(posedge refreshClockBall) begin 
    if (resetApp) begin
        leftPaddleScore <= 4'b0;
        rightPaddleScore <= 4'b0;
        
    end else begin
        resetBall <= 1'b0;

        // Left Paddles Scored
        if (xBallPosition == 230) begin 
            resetBall <= 1'b1;
            leftPaddleScore <= (leftPaddleScore + 1'b1);

        // Right paddle Scored
        end else if (xBallPosition == 5) begin 
            resetBall <= 1'b1;
            rightPaddleScore <= (rightPaddleScore + 1'b1);
        end 
    end

    // Reset score when score = 11
    if (rightPaddleScore == 11 || leftPaddleScore == 11) begin
        leftPaddleScore <= 4'b0;
        rightPaddleScore <= 4'b0;
    end
end 

endmodule
