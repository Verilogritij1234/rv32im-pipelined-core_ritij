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


module control_unit (
    input  wire [6:0] opcode,
    
    output reg        branch,      // 1 if Branch instruction
    output reg        mem_to_reg,  // 1 = Write RAM data to Reg, 0 = Write ALU data
    output reg [1:0]  alu_op,      // Tells ALU Decoder what instruction category this is
    output reg        mem_write,   // 1 = Write to RAM
    output reg        alu_src,     // 0 = Reg B, 1 = Immediate
    output reg        reg_write    // 1 = Write to Register File
);

    always @(*) begin
       
        branch     = 1'b0; 
        mem_to_reg = 1'b0; 
        alu_op     = 2'b00;
        mem_write  = 1'b0; 
        alu_src    = 1'b0; 
        reg_write  = 1'b0;

        case(opcode)
            7'b0110011: begin     //   for R Type  instructions
                reg_write = 1'b1;
                alu_op    = 2'b10;
            end
            
            7'b0010011: begin  //  for  I Type (immidiate type instructions)
                alu_src   = 1'b1;
                reg_write = 1'b1;
                alu_op    = 2'b11;
            end
            
            7'b0000011: begin    //   for load  instruction
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                reg_write  = 1'b1;
                alu_op     = 2'b00; 
            end
            
            7'b0100011: begin     //   for  Store instruction (SW)
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00; 
            end
            
            7'b1100011: begin  //  for branching operations
                branch = 1'b1;
                alu_op = 2'b01;   
            end
            
        
            7'b1101111: begin //   for jump  and  link (JAL) operations 
                reg_write = 1'b1;
            end

            7'b1100111: begin //   for jump and  link  register(JALR)
                reg_write = 1'b1; 
            end

            7'b0110111: begin   // load upper immediate
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end

            7'b0010111: begin // add upper immediate to PC 
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end
        endcase
    end
endmodule


