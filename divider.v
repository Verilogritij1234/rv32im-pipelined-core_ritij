module divider (
    input  wire        clk,
    input  wire        reset,
    input  wire        start,     // signal from control unit to begin division
    input  wire [31:0] dividend,      // number being divided
    input  wire [31:0] divisor,  // number to divide by
    output reg  [31:0] quotient,
    output reg  [31:0] remainder,
    output reg         ready,     // Pulses high when math is done
    output reg         busy         
);

    // state machine States  declaration 
    localparam IDLE      = 2'b00;
    localparam SHIFT_SUB = 2'b01;
    localparam DONE      = 2'b10;

    reg [1:0]  state;
    
    reg [32:0] A;       
    reg [31:0] Q;       
    reg [32:0] M;       
    reg [5:0]  count;   // counts from 31 down to 0

       // combinational logic: Shift A and Q left as a single unit, then subtract M
    wire [32:0] shifted_A = {A[31:0], Q[31]};
    wire [32:0] diff      = shifted_A - M;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            ready     <= 0;
            busy      <= 0;
            quotient  <= 0;
            remainder <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 0;
                    if (start) begin
                        A     <= 33'b0;
                        Q     <= dividend;
                        M     <= {1'b0, divisor}; // Zero-extend the divisor
                        count <= 6'd31;           // 32-bit division requires 32 loops
                        busy  <= 1;
                        state <= SHIFT_SUB;
                    end
                end

                SHIFT_SUB: begin
                    // Check the 33rd sign bit to see if the subtraction resulted in a negative number
                    if (diff[32] == 1'b1) begin
                        // RESTORE: Subtracted too much. Keep shifted A, set Q's lowest bit to 0.
                        A <= shifted_A;
                        Q <= {Q[30:0], 1'b0};
                    end else begin
                        // KEEP: Subtraction was valid. Keep the difference, set Q's lowest bit to 1.
                        A <= diff;
                        Q <= {Q[30:0], 1'b1};
                    end

                    // Loop 
                    if (count == 0) begin
                        state <= DONE;
                    end else begin
                        count <= count - 1'b1;
                    end
                end

                DONE: begin
                    quotient  <= Q;
                    remainder <= A[31:0];
                    ready     <= 1;
                    busy      <= 0;
                    state     <= IDLE;
                end
            endcase
        end
    end
endmodule