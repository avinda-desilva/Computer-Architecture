module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

    // New Wires
    wire         stall, forward_a, forward_b, reg_write_MW, mem_write_MW, mem_read_MW, mem_to_reg_MW, reg_dst_MW;
    wire [31:2]  PC_plus4_new;
    wire [31:0]  inst_pipeline, rd1_data_new, rd2_data_new, rd1_data_MW, rd2_data_MW, alu_out_data_MW;
    wire         decode_pipe, enable;
    wire [4:0]   wr_regnum_MW;
    wire [31:0]  rd1_data_old, rd2_data_old;
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_new, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_pipeline, PC[31:2]);


    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break

    register #(5) wr_regnum_pipeline_de(wr_regnum_MW, wr_regnum, clk, enable, PCSrc);
    register #(32) forwardb_pipeline_de(rd2_data_MW, rd2_data_old, clk, enable, PCSrc);
    register #(32) alu_result_pipeline_de(alu_out_data_MW, alu_out_data, clk, enable, PCSrc);
    regfile rf (rd1_data_old, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               reg_write_MW, clk, reset);

    mux2v #(32) imm_mux(B_data, rd2_data_old, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, mem_read_MW, mem_write_MW, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, mem_to_reg_MW);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

    mux2v #(32) forward_a_mux(rd1_data, rd1_data_old, alu_out_data_MW, forward_a);
    mux2v #(32) forward_b_mux(rd2_data_old, rd2_data, alu_out_data_MW, forward_b);

    assign forward_a = (rs != 0) && reg_write_MW && (rs == wr_regnum_MW);
    assign forward_b = (rt != 0) && reg_write_MW && (rt == wr_regnum_MW);
    assign stall = mem_read_MW  && (((rs != 0) && (rs == wr_regnum_MW)) || ((rt != 0) && (rt == wr_regnum_MW)));

    assign decode_pipe = PCSrc || reset;
    register #(32) decode_imem(inst, inst_pipeline, clk, ~stall, decode_pipe);
    register #(30) decode_plus_4(PC_plus4_new, PC_plus4, clk, ~stall, decode_pipe);

    assign enable = 1'b1;
    register #(1) mem_to_reg_pipeline_mw(mem_to_reg_MW, MemToReg, clk, enable, PCSrc);
    register #(1) reg_dist_pipeline_mw(reg_dst_MW, RegDst, clk, enable, PCSrc);
    register #(1) mem_read_pipeline_mw(mem_read_MW, MemRead, clk, enable, PCSrc);
    register #(1) mem_write_pipeline_mw(mem_write_MW, MemWrite, clk, enable, PCSrc);
    register #(1) reg_write_pipeline_mw(reg_write_MW, RegWrite, clk, enable, PCSrc);

endmodule // pipelined_machine
