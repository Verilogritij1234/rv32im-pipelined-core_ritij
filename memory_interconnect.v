module memory_interconnect (
    input  wire        clk,
    input  wire        we,         //  signal for write Enable from cpu   
    input  wire        reset,
    input  wire [31:0] addr,       // address from cpu
    input  wire [31:0] wdata,      // data  from cpu  to write
    output wire [31:0] rdata       // data back to cpu 
);

  
    wire is_ram  = (addr < 32'h00000400);
    
    wire is_uart = (addr == 32'h40000000);

    //  route  the write enables on the basis of  address:
    wire ram_we  = we & is_ram;
    wire uart_we = we & is_uart;

  
    wire [31:0] ram_rdata;
    //  RAM block instantiations:
    parameterized_RAM #( .DATA_WIDTH(1024), .ADDR_WIDTH(32) ) dataRam (
        .clk(clk),
        .we(ram_we),            // only write if Address is in RAM limits 
        .address(addr),
        .data_in(wdata),
        .data_out(ram_rdata)
    );

    // UART declaration for seeing output of the CPU core: 
    always @(posedge clk) begin
        if (uart_we) begin
            $write("%c", wdata[7:0]); //  it print the lowest 8 bits as an ASCII character
            
            `ifdef SIMULATION
             $fflush(); //  Force the console to print immediately
            `endif
        end
    end

    // read data mux:
    assign rdata = is_ram ? ram_rdata : 32'b0;

endmodule