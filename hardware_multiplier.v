


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

module hardware_multiplier (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  funct3,
    output reg  [31:0] result
);
   
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    
    //  for calculation  of full 64-bit results:
    wire signed [63:0] mult_ss = signed_a * signed_b;                // signed x signed
    wire        [63:0] mult_uu = a * b;                                  // unsigned x unsigned
    wire signed [63:0] mult_su = signed_a * $signed({1'b0, b});      // signed x unsigned

    always @(*) begin
        case (funct3)
            3'b000: result = mult_ss[31:0];       // MUL    (lower 32 bits, sign not  matter)
            3'b001: result = mult_ss[63:32];   // MULH   (upper 32 bits, ssigned x signed)
            3'b010: result = mult_su[63:32]; // MULHSU (upper 32 bits, signed x unsigned)
            3'b011: result = mult_uu[63:32]; // MULHU  (upper 32 bits, unsigned x Unsigned)
            default: result = 32'b0;
        endcase
    end
endmodule
