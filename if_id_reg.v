
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

module if_id_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,           // 1 = freeze the register
    input  wire        flush,     // 1 = clear the instruction (branch taken)
    
    // inputs  from the Fetch stage 
    input  wire [31:0] if_pc,
    input  wire [31:0] if_instr,
    
      // outputs to the Decode stage 
    output reg  [31:0] id_pc,
    output reg  [31:0] id_instr
);


    localparam NOP_INSTR = 32'h00000013;  //  no operation declaration 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_pc    <= 32'b0;
            id_instr <= NOP_INSTR;
        end 
        else if (flush) begin
            id_pc    <= 32'b0;
            id_instr <= NOP_INSTR; // kill the bad instruction
        end 
        else if (!stall) begin
            id_pc    <= if_pc;     // Pass the PC forward
            id_instr <= if_instr;  // Pass the Instruction forward
        end
                   // if stall is 1 keep holding the old values)
    end

endmodule
