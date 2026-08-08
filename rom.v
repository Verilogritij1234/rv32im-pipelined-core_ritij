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


module rom
#(parameter DEPTH  = 16,
 parameter WIDTH = 32,
 parameter DEPTH_LOG  = $clog2(DEPTH))
 (addr_rd,data_rom_out);
 input [(DEPTH_LOG-1):0]addr_rd;
 output   [(WIDTH-1):0]data_rom_out;
// declare a ROM array
 reg [(WIDTH-1):0] rom[0:(DEPTH-1)];


 // load the rom with data from rom_init.hex file 
 initial begin
    //   $readmemh("program.hex",rom,0,DEPTH-1);  // for reading hexadecimal data from the file
      $readmemh("instruction_set.hex",rom,0,DEPTH-1);  // for reading hexadecimal data from the file
    //   $readmemb("rom_init.txt",rom,0,DEPTH-1);  //  for reading  binary data from the file 
 end

// read is synchronous
 // always@(posedge clk) begin
 assign  data_rom_out = rom[addr_rd];
 // end
endmodule






