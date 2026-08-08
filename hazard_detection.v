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



module hazard_detection (
    input  wire [4:0] id_rs1,
    input  wire [4:0] id_rs2,
    input  wire       ex_mem_read,        // Load instruction in EX
    input  wire [4:0] ex_rd,              // Dest register in EX
    input  wire       ex_branch_taken,    // Branch/Jump in EX
    
    input  wire       ex_is_div,          // High if instruction in EX is a DIV
    input  wire       div_ready,          // High ONLY when divider is 100% finished
    input  wire       id_reg_write,       // Original write signal from Control Unit

    output reg        pc_write,           // 0 = freeze PC
    output reg        if_id_write,        // 0 = freeze IF/ID Reg
    output reg        id_ex_write,        // 0 = freeze ID/EX Reg
    output reg        ex_reg_write_final, // 0 = Kill write to prevent leakage
    output reg        flush_id_ex,        // 1 = Bubble (NOP)
    output reg        flush_if_id         // 1 = flush wrong instruction
);

    always @(*) begin
        // default state: full speed
        pc_write           = 1'b1;
        if_id_write        = 1'b1;
        id_ex_write        = 1'b1;
        ex_reg_write_final = id_reg_write;
        flush_id_ex        = 1'b0;
        flush_if_id        = 1'b0;

        // 1. HARDWARE DIVIDER STALL (Combinational Priority)
        
        if (ex_is_div && !div_ready) begin
            pc_write           = 1'b0;
            if_id_write        = 1'b0;
            id_ex_write        = 1'b0; 
            ex_reg_write_final = 1'b0; 
        end

       
        else if (ex_mem_read && (ex_rd != 0) && ((ex_rd == id_rs1) || (ex_rd == id_rs2))) begin
            pc_write           = 1'b0;
            if_id_write        = 1'b0;
            flush_id_ex        = 1'b1; 
        end

        else if (ex_branch_taken) begin
            flush_if_id        = 1'b1;
            flush_id_ex        = 1'b1;
        end
    end
endmodule
