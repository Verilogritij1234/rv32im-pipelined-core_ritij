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


module forwarding_unit (
   
    input  wire [4:0] ex_rs1,
    input  wire [4:0] ex_rs2,

    
    input  wire       mem_reg_write,
    input  wire [4:0] mem_rd,


    input  wire       wb_reg_write,
    input  wire [4:0] wb_rd,

    
    output reg  [1:0] forward_a,
    output reg  [1:0] forward_b
);

    always @(*) begin
        // default:
        forward_a = 2'b00;
        forward_b = 2'b00;

        
// EX hazard:(priority 1)
   
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs1)) begin
            forward_a = 2'b10;
        end
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs2)) begin
            forward_b = 2'b10;
        end

       
        // MEM hazard: (priority 2)
        
        if (wb_reg_write && (wb_rd != 0) && (wb_rd == ex_rs1) && 
            !(mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs1))) begin
            forward_a = 2'b01;
        end
        if (wb_reg_write && (wb_rd != 0) && (wb_rd == ex_rs2) && 
            !(mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs2))) begin
            forward_b = 2'b01;
        end
    end

endmodule
