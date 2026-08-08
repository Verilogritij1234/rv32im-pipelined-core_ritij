#
# Copyright (c) 2026, Ritij Kaushal
# All rights reserved.
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






