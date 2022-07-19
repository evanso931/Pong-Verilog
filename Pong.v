/* Pong
 *---------------------------
 * By: Benjamin Evans
 * For: University of Leeds
 * Date: 29th April 2022 
 *
 * Short Description
 * -----------------
 * This is the top level Pong module which contain a FSM to control Gameplay
 *
 * Reference: Benjamin Evans - DigitalLock.v - ELEC5566M-Assignment2-evanso931
 */ 

module Pong (    
    // Inputs 
    input clock, 
    input key0, // Up
    input key1, // Down
    input key2, // Play
    input key3, // Menu

    // Seven Segment Displays 
    output [6:0] segZero, 
    output [6:0] segOne,
    //output [6:0] seg2, 
    //output [6:0] seg3,
    output [6:0] segFour, 
    output [6:0] segFive,

    // LT24 Interface
    output             resetApp,
    output             LT24Wr_n,
    output             LT24Rd_n,
    output             LT24CS_n,
    output             LT24RS,
    output             LT24Reset_n,
    output [15:0]      LT24Data,
    output             LT24LCDOn
); 

// Local Variables
reg clockControl;
reg reset;
wire gameOver;
wire synchronisedkey2;
wire synchronisedkey3;

GameEngine GameEngine(
    // Inputs
    .clock              (clockControl   ),
    .reset              (reset          ),
    .rightPaddleUp      (key0           ),
    .rightPaddleDown    (key1           ),

    // Seven Segment Displays 
    .segFour            (segFour        ),
    .segFive            (segFive        ),
    .segZero            (segZero        ),
    .segOne             (segOne         ),

    // LT24 Interface
    .resetApp           (resetApp       ),
    .LT24Wr_n           (LT24Wr_n       ),
    .LT24Rd_n           (LT24Rd_n       ),
    .LT24CS_n           (LT24CS_n       ),
    .LT24RS             (LT24RS         ),
    .LT24Reset_n        (LT24Reset_n    ),
    .LT24Data           (LT24Data       ),
    .LT24LCDOn          (LT24LCDOn      )
);

Debouncer DebouncerKey2 (
    .clock      (clock),
    .asyncIn    (key2),
    .syncOut    (synchronisedkey2),
);

Debouncer DebouncerKey3 (
    .clock      (clock),
    .asyncIn    (key3),
    .syncOut    (synchronisedkey3),
);

// State-Machine Registers
reg state, nextState;

// Local state name parameters
localparam PLAY_STATE = 1'b0;
localparam MENU_STATE = 1'b1;

// Defined state transitions and outputs for each state, which are synchronous
always @(key2 or key3 or gameOver) begin
    case (state)
        PLAY_STATE: begin
            reset <= 1'b0;
            clockControl <= clock;
        
            // If key3 press code change state to menu state
            if (!synchronisedkey3) begin 
                nextState <= (key3) ?  state : MENU_STATE;
                reset <= 1'b1;
            end
            
        end
        MENU_STATE: begin 
            clockControl <= 1'b0;

            // If key2 press code change state to play state
            nextState <= (synchronisedkey2) ? state : PLAY_STATE;
        end
        default: begin
            state <=  MENU_STATE;
        end
    endcase
end

// Updates state to the next state. The next sate could still be the same state
always @(posedge clock) begin 
    state <= nextState;
end

endmodule