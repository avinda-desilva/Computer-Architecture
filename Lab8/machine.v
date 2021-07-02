module machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0]  inst;

   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];

   wire [4:0]   wr_regnum;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET;
   wire         PCSrc, zero, negative;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

   // NEW WIRES
   wire TakenInterrupt, TimerInterrupt, TimerAddress, not_IO, new_mem_read, new_mem_write;
   wire [31:0]  c0_wr_data, c0_rd_data, t_address, t_data, cycle, new_wr_data, hex_value;
   wire [31:2]  EPC, new_next_PC, new_next_PC_interrupt;

   // NEW MODULES
   assign t_data = rd2_data;
   assign c0_wr_data = rd2_data;
   assign t_address = alu_out_data;
   assign not_IO = ~TimerAddress;
   cp0 cp0_decode(c0_rd_data, EPC, TakenInterrupt, c0_wr_data, wr_regnum, next_PC, MTC0, ERET, TimerInterrupt, clk, reset);
   timer timer_decode(TimerInterrupt, load_data, TimerAddress, t_data, t_address, MemRead, MemWrite, clk, reset);
   mux2v #(32) new_wr_data_mux(new_wr_data, wr_data, c0_rd_data, MFC0);
   mux2v #(30) new_next_pc_mux(new_next_PC, next_PC, EPC, ERET);
   assign hex_value = 32'h80000180;
   mux2v #(30) new_next_pc_interrupt_mux(new_next_PC_interrupt, new_next_PC, hex_value[31:2], TakenInterrupt);

   register #(30, 30'h100000) PC_reg(PC[31:2], new_next_PC_interrupt, clk, /* enable */1'b1, reset);
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;

   instruction_memory imem (inst, PC[31:2]);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET,
                      inst);

   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, new_wr_data,
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
   alu32 alu(alu_out_data, zero, negative, ALUOp, rd1_data, B_data);
   assign new_mem_read = MemRead && not_IO;
   assign new_mem_write = MemWrite && not_IO;
   data_mem data_memory(load_data, alu_out_data, rd2_data, new_mem_read, new_mem_write, clk, reset);
   assign cycle = load_data;
   mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
   mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

endmodule // machine
