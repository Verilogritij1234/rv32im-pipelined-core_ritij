
#
# Copyright (c) 2026, Ritij Kaushal
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


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
