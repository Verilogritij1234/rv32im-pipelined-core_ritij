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

// this is a 32 bit alu capable of performing large variety of 
// arithematical and logical opearations :
module ALU 
#(parameter BUS_WIDTH = 32)
    (
    input  wire [BUS_WIDTH-1:0] a,          // operand 1
    input  wire [BUS_WIDTH-1:0] b,          // operand 2 
    input  wire                 carry_in,  
    input  wire [3:0]           opcode,  
    output reg  [BUS_WIDTH-1:0] y,  
    output reg                  carry_out,
    output reg                  borrow,
    output wire                 zero, 
    output wire                 parity, 
    output reg                  invalid_op
    );

    localparam OP_PASS_A     = 4'd0; 
    localparam OP_ADD        = 4'd1; // addition 
    localparam OP_ADD_CARRY  = 4'd2;  // addition with carry
    localparam OP_SUB        = 4'd3;  // for subtraction 
    localparam OP_INC        = 4'd4; // to increment by 1
    localparam OP_DEC        = 4'd5;  // to decrement by 1
    localparam OP_AND        = 4'd6;  //  for AND boolen operation 
    localparam OP_NOT        = 4'd7;  //  for  NOT boolen operation 
    localparam OP_SOL        = 4'd8;  //  to Shift logical left
    localparam OP_SOR        = 4'd9;  //  to  Shift logical right

    localparam OP_OR         = 4'd10; // for OR boolen operation 
    localparam OP_XOR        = 4'd11;  // for XOR  boolen operation 
    localparam OP_NOR        = 4'd12; // for NOR  boolen operation 
    localparam OP_SUB_BORROW = 4'd13;  // subtraction with borrow 
    localparam OP_SRA        = 4'd14; // Shift right arithmetic
    localparam OP_SLT        = 4'd15; // Set on less than (signed)

    always @(*) begin

        y          = {BUS_WIDTH{1'b0}};  
        carry_out  = 1'b0;   
        borrow     = 1'b0;   
        invalid_op = 1'b0;  

        case(opcode)
            OP_PASS_A: begin 
                y = a; 
            end
            

         OP_ADD: begin 
                {carry_out, y} = a + b; 
            end
            
             OP_ADD_CARRY: begin  
                {carry_out, y} = a + b + carry_in; 
            end
            
         OP_SUB: begin  
                {borrow, y} = a - b;  
            end
            
          OP_INC: begin  
                {carry_out, y} = a + 1'b1;   
            end
            
              OP_DEC: begin  
                {borrow, y} = a - 1'b1;   
             end 
            
            OP_AND: begin  
                y = a & b; 
             end
            
            OP_NOT: begin  
                y = ~a;  
              end

            OP_SOL: begin  
                y = a << b[4:0]; // Shift logical left 
              end  
            
            OP_SOR: begin  
                y = a >> b[4:0]; // Shift logical right
              end 


              OP_OR: begin
                y = a | b;
            end

              OP_XOR: begin
                y = a ^ b;
            end

              OP_NOR: begin
                y = ~(a | b);
            end

              OP_SUB_BORROW: begin
                {borrow, y} = a - b - carry_in;
            end

            OP_SRA: begin
                // Shift Right Arithmetic (preserves sign bit)
                y = $signed(a) >>> b[4:0];
               end

            OP_SLT: begin
                // Set Less Than (Signed comparison)
                y = ($signed(a) < $signed(b)) ? {{BUS_WIDTH-1{1'b0}}, 1'b1} : {BUS_WIDTH{1'b0}};
               end

            default: begin  
                invalid_op = 1'b1;  
            end 
        endcase    
    end


    assign parity = ^y;               //  for even parity with XOR Op
    assign zero   = (y == {BUS_WIDTH{1'b0}});

endmodule




