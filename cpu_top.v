module cpu_top (
    input  wire        clk, 
    input  wire        reset,
    output wire [31:0] out_data,
    inout  VPWR,  
    inout  VGND
);

  // declaratons of the important wires 
    wire        wb_reg_write;
    wire        wb_mem_to_reg;
    wire [31:0] wb_read_data;
    wire [31:0] wb_alu_result;
    wire [4:0]  wb_rd;
    wire [31:0] wb_data; 

    wire        pc_write;
    wire        if_id_write;
    wire        flush_if_id;
    wire        flush_id_ex;
    wire [1:0]  forward_a;
    wire [1:0]  forward_b;

    wire        ex_branch_taken;
    wire [31:0] ex_branch_target;


    
    // Stage 1: instruction fetch(IF)
    
    wire [31:0] if_pc;
    wire [31:0] if_instr;

    program_counter #(.WIDTH(32)) pc (
        .clk(clk),
        .reset(reset),
        .enable(pc_write),            // Stalls the PC if 0
        .load_en(ex_branch_taken),    
        .load_addr(ex_branch_target), 
        .pc(if_pc) 
    );

    rom #( .DEPTH(1024), .WIDTH(32) ) instr_mem (
        .addr_rd(if_pc[11:2]), 
        .data_rom_out(if_instr)
    );

    
    //  pipeline  register 1: IF/ID
    
    wire [31:0] id_pc;
    wire [31:0] id_instr;

    if_id_reg pipeline_reg_1 (
        .clk(clk),
        .reset(reset),
        .stall(~if_id_write), // Hazard unit freezes this register
        .flush(flush_if_id),  // Hazard unit clears it on branches
        
        .if_pc(if_pc),
        .if_instr(if_instr),
        
        .id_pc(id_pc),
        .id_instr(id_instr)
    );

    
    // Stage 2: instruction decode(ID)
   
    wire [6:0] opcode = id_instr[6:0];
    wire [4:0] rs1    = id_instr[19:15];
    wire [4:0] rs2    = id_instr[24:20];
    wire [4:0] rd     = id_instr[11:7];
    wire [2:0] funct3 = id_instr[14:12];
    wire [6:0] funct7 = id_instr[31:25];


    wire [31:0] imm_i = {{20{id_instr[31]}}, id_instr[31:20]};
    wire [31:0] imm_s = {{20{id_instr[31]}}, id_instr[31:25], id_instr[11:7]};
    wire [31:0] imm_b = {{20{id_instr[31]}}, id_instr[7], id_instr[30:25], id_instr[11:8], 1'b0}; 
   
    wire [31:0] imm_j = {{12{id_instr[31]}}, id_instr[19:12], id_instr[20], id_instr[30:21], 1'b0};
   
    wire [31:0] imm_u = {id_instr[31:12], 12'b0};

   
    wire [31:0] id_imm = (opcode == 7'b0100011) ? imm_s : //  for  Store
                         (opcode == 7'b1100011) ? imm_b : //  for  Branch
                         (opcode == 7'b1101111) ? imm_j : //   for JAL 
                         (opcode == 7'b0110111 || opcode == 7'b0010111) ? imm_u : //  for  U-Type
                         imm_i; ///  Default to immidiate type op

    wire id_reg_write, id_mem_write, id_mem_to_reg, id_branch, id_alu_src;
    wire [1:0] id_alu_op;

    control_unit cu (
        .opcode(opcode),
        .branch(id_branch),
        .mem_to_reg(id_mem_to_reg),
        .alu_op(id_alu_op),
        .mem_write(id_mem_write),
        .alu_src(id_alu_src),
        .reg_write(id_reg_write)
    );

    wire [31:0] id_reg_a, id_reg_b;
    
    regfile rf (
        .clk(clk),
        .we(wb_reg_write),      
        .rs1(rs1),
        .rs2(rs2),
        .rd(wb_rd),            
        .wd(wb_data),           
        .rd1(id_reg_a),
        .rd2(id_reg_b)
    );

    
    // pipeline register 2: ID/EX
    
    wire        ex_reg_write, ex_mem_write, ex_mem_to_reg, ex_branch, ex_alu_src;
    wire [1:0]  ex_alu_op;
    wire [31:0] ex_pc, ex_reg_a, ex_reg_b, ex_imm;
    wire [4:0]  ex_rs1, ex_rs2, ex_rd;
    wire [2:0]  ex_funct3;
    wire [6:0]  ex_funct7;
    wire [6:0]  ex_opcode;

    wire id_ex_write;


    id_ex_reg pipeline_reg_2 (
        .clk(clk),
        .reset(reset),
        .stall(~id_ex_write),  
        .flush(flush_id_ex),  
        
        .id_reg_write(ex_reg_write_final), 


        .id_mem_write(id_mem_write), 
        .id_mem_to_reg(id_mem_to_reg),
        .id_branch(id_branch), 
        .id_alu_src(id_alu_src), 
        .id_alu_op(id_alu_op),
        .id_pc(id_pc), 
        .id_reg_a(id_reg_a), 
        .id_reg_b(id_reg_b), 
        .id_imm(id_imm),
        .id_rs1(rs1), 
        .id_rs2(rs2), 
        .id_rd(rd), 
        .id_funct3(funct3), 
        .id_funct7(funct7),
        .id_opcode(opcode),

        .ex_reg_write(ex_reg_write), 
        .ex_mem_write(ex_mem_write), 
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_branch(ex_branch), 
        .ex_alu_src(ex_alu_src), 
        .ex_alu_op(ex_alu_op),
        .ex_pc(ex_pc), 
        .ex_reg_a(ex_reg_a), 
        .ex_reg_b(ex_reg_b), 
        .ex_imm(ex_imm),
        .ex_rs1(ex_rs1), 
        .ex_rs2(ex_rs2), 
        .ex_rd(ex_rd), 
        .ex_funct3(ex_funct3), 
        .ex_funct7(ex_funct7),
        .ex_opcode(ex_opcode)
    );

    
    // Stage 3: execute(EX)
    


    wire [3:0]  ex_alu_opcode;
    wire [31:0] ex_alu_result;
    wire        ex_zero;

    // jump instructions
    wire ex_is_jal  = (ex_opcode == 7'b1101111);
    wire ex_is_jalr = (ex_opcode == 7'b1100111);
    wire ex_is_jump = ex_is_jal | ex_is_jalr;

    alu_control alu_ctrl (
        .alu_op(ex_alu_op),
        .funct3(ex_funct3),
        .funct7(ex_funct7),
        .alu_opcode(ex_alu_opcode)
    );

  /// forwarding  multiplexers :
    wire [31:0] mem_alu_result; 

    wire [31:0] forwarded_a = (forward_a == 2'b10) ? mem_alu_result : 
                              (forward_a == 2'b01) ? wb_data : 
                                                     ex_reg_a;

    wire [31:0] forwarded_b = (forward_b == 2'b10) ? mem_alu_result : 
                              (forward_b == 2'b01) ? wb_data : 
                                                     ex_reg_b;

    
    wire [31:0] target_base = ex_is_jalr ? forwarded_a : ex_pc;
    assign ex_branch_target = target_base + ex_imm;
    
    // branch condition logic:
    wire ex_is_beq = (ex_funct3 == 3'b000) & ex_zero;
    wire ex_is_bne = (ex_funct3 == 3'b001) & ~ex_zero;
    wire branch_condition_met = ex_branch & (ex_is_beq | ex_is_bne);

    assign ex_branch_taken = branch_condition_met | ex_is_jump;

  
    wire [31:0] final_alu_a = ex_is_jump ? ex_pc : forwarded_a;
    wire [31:0] final_alu_b = ex_is_jump ? 32'd4 : (ex_alu_src ? ex_imm : forwarded_b);

    wire carry_out, borrow, parity, invalid_op;
      
    ALU #( .BUS_WIDTH(32) ) myalu (
        .a(final_alu_a),       
        .b(final_alu_b),          
        .carry_in(1'b0),
        .opcode(ex_is_jump ? 4'd2 : ex_alu_opcode), 
        .y(ex_alu_result),
        .carry_out(carry_out),
        .borrow(borrow),
        .zero(ex_zero),
        .parity(parity),
        .invalid_op(invalid_op)
    );



// Stage 3: execution   unit:


///  for M-extension instructions (multiplication and divide)
wire ex_is_div = (ex_opcode == 7'b0110011) && (ex_funct7 == 7'b0000001) && (ex_funct3 == 3'b100);
wire ex_is_rem = (ex_opcode == 7'b0110011) && (ex_funct7 == 7'b0000001) && (ex_funct3 == 3'b110);
wire ex_is_mul = (ex_opcode == 7'b0110011) && (ex_funct7 == 7'b0000001) && (ex_funct3 == 3'b000);


wire ex_stall_req = ex_is_div || ex_is_rem;

// hardware  divider control signals
wire start_div = ex_stall_req && !div_busy && !div_ready;
wire safe_ex_mem_reg_write = ex_reg_write && (!ex_stall_req || div_ready);

wire [31:0] div_quotient, div_remainder;
wire div_ready, div_busy;

// hardware divider block 
divider hw_divider (
    .clk(clk),
    .reset(reset),
    .start(start_div),
    .dividend(forwarded_a),     // rs1
    .divisor(forwarded_b),      // rs2
    .quotient(div_quotient),
    .remainder(div_remainder),
    .ready(div_ready),
    .busy(div_busy)
);

//  hardware multiplier block 
wire [31:0] ex_mul_result;
hardware_multiplier my_multiplier (
    .a(final_alu_a),       
    .b(final_alu_b),
    .funct3(ex_funct3),
    .result(ex_mul_result) // outputs delivers to  ex_mul_result wire 
);


wire [31:0] div_res_mux = (ex_is_rem) ? div_remainder : div_quotient;

wire [31:0] final_ex_result = 
    (ex_is_mul)    ? ex_mul_result :    // if  it is  multiply, pick the multiplier
    (ex_stall_req) ? div_res_mux :            // if it is  div/rem, pick the divider
                     ex_alu_result;       //  else pick the standard alu




//   pipeline register  3: EX/MEM

    wire        mem_reg_write, mem_mem_write, mem_mem_to_reg, mem_branch_taken;
    wire [31:0] mem_branch_target, mem_store_data;
    wire [4:0]  mem_rd;

wire flush_ex_mem = ex_stall_req && !div_ready;

ex_mem_reg pipeline_reg_3 (
    .clk(clk),
    .reset(reset),
    
    .ex_reg_write(safe_ex_mem_reg_write && !flush_ex_mem), 
    .ex_mem_write(ex_mem_write && !flush_ex_mem), 
    
    .ex_mem_to_reg(ex_mem_to_reg),
    .ex_branch_taken(ex_branch_taken),
    .ex_branch_target(ex_branch_target),
    
    .ex_alu_result(final_ex_result), 
    .ex_reg_b(forwarded_b), 
    .ex_rd(ex_rd),
    
    // Outputs to Stage 4 (MEM)
    .mem_reg_write(mem_reg_write),
    .mem_mem_write(mem_mem_write),
    .mem_mem_to_reg(mem_mem_to_reg),
    .mem_branch_taken(mem_branch_taken),
    .mem_branch_target(mem_branch_target),
    .mem_alu_result(mem_alu_result),
    .mem_store_data(mem_store_data),
    .mem_rd(mem_rd)
);



    wire [31:0] mem_read_data;
 ///    output wire uart_tx_out; 

    memory_interconnect bus (
        .clk(clk),
        .reset(reset),         
        .we(mem_mem_write),
        .addr(mem_alu_result),
        .wdata(mem_store_data),
        .rdata(mem_read_data)
    );

    
    // pipeline register   4: MEM/WB
    
    mem_wb_reg pipeline_reg_4 (
        .clk(clk),
        .reset(reset),
        
        .mem_reg_write(mem_reg_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_read_data(mem_read_data),
        .mem_alu_result(mem_alu_result),
        .mem_rd(mem_rd),
        
        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg),
        .wb_read_data(wb_read_data),
        .wb_alu_result(wb_alu_result),
        .wb_rd(wb_rd)
    );

    
    // Stage 5: writeback (WB)
    
    assign wb_data = wb_mem_to_reg ? wb_read_data : wb_alu_result;
    assign out_data = wb_data;


hazard_detection hazard_unit (
    .id_rs1(rs1),
    .id_rs2(rs2),
    .ex_mem_read(ex_mem_to_reg),
    .ex_rd(ex_rd),
    .ex_branch_taken(ex_branch_taken),
    
   
    .ex_is_div(ex_stall_req),      
    .div_ready(div_ready),           // from  divider module output
    .id_reg_write(id_reg_write), // from your control unit
    
    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .id_ex_write(id_ex_write),
    .ex_reg_write_final(ex_reg_write_final), 
    .flush_id_ex(flush_id_ex),
    .flush_if_id(flush_if_id)
);

    forwarding_unit fwd_unit (
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .mem_reg_write(mem_reg_write),
        .mem_rd(mem_rd),
        .wb_reg_write(wb_reg_write),
        .wb_rd(wb_rd),
        
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

endmodule


