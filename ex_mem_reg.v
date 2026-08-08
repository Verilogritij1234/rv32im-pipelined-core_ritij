
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


module ex_mem_reg (
    input  wire        clk,
    input  wire        reset,

       // inputs from EX stage
    
    input  wire        ex_reg_write,
    input  wire        ex_mem_write,
    input  wire        ex_mem_to_reg,
    
    input  wire        ex_branch_taken,
    input  wire [31:0] ex_branch_target,

    input  wire [31:0] ex_alu_result, 
    input  wire [31:0] ex_reg_b,      
    input  wire [4:0]  ex_rd,          

  // outputs to MEM stage

    output reg         mem_reg_write,
    output reg         mem_mem_write,
    output reg         mem_mem_to_reg,
    
    output reg         mem_branch_taken,
    output reg  [31:0] mem_branch_target,

    output reg  [31:0] mem_alu_result,
    output reg  [31:0] mem_store_data,
    output reg  [4:0]  mem_rd
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_reg_write     <= 1'b0;
            mem_mem_write     <= 1'b0;
            mem_mem_to_reg    <= 1'b0;
            mem_branch_taken  <= 1'b0;
            mem_branch_target <= 32'b0;
            mem_alu_result    <= 32'b0;
            mem_store_data    <= 32'b0;
            mem_rd            <= 5'b0;
        end 
        else begin
// assigments for data transfer: 
            mem_reg_write     <= ex_reg_write;
            mem_mem_write     <= ex_mem_write;
            mem_mem_to_reg    <= ex_mem_to_reg;
            mem_branch_taken  <= ex_branch_taken;
            mem_branch_target <= ex_branch_target;
            mem_alu_result    <= ex_alu_result; 
            mem_store_data    <= ex_reg_b;
            mem_rd            <= ex_rd;
        end
    end

endmodule
