`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
  wr_data, regnum, next_pc,
  MTC0, ERET, TimerInterrupt, clock, reset);
  output [31:0] rd_data;
  output [29:0] EPC;
  output        TakenInterrupt;
  input  [31:0] wr_data;
  input   [4:0] regnum;
  input  [29:0] next_pc;
  input         MTC0, ERET, TimerInterrupt, clock, reset;

  // your Verilog for coprocessor 0 goes here
  wire  [31:0] user_status, cause_register, status_register, decode_out;
  wire        exception_level, exception_reset, epc_enable, int_check_1, int_check_2, not_status;
  wire [31:2] epc_out, epc_in;
  wire  [1:0] rd_op;
  assign  rd_op[0] = (regnum == `CAUSE_REGISTER) || (regnum == `EPC_REGISTER);
  assign  rd_op[1] = (regnum == `EPC_REGISTER);
  or o1(exception_reset, reset, ERET);
  or o2(epc_enable, decode_out[14], TakenInterrupt);
  and a1(int_check_1,cause_register[15],status_register[15]);
  and a2(int_check_2,status_register[0],not_status);
  not n1(not_status, status_register[1]);
  and a3(TakenInterrupt,int_check_1,int_check_2);

  //assign user_status = 31'd507;
  register #(32) user_status_reg(user_status, wr_data, clock, decode_out[12], reset);
  register #(1)  exception_reg(exception_level, 1'b1, clock, TakenInterrupt, exception_reset);
  register #(30) epc_reg(epc_out, epc_in, clock, epc_enable, reset);

  decoder32 regnum_decoder(decode_out, regnum, MTC0);

  mux2v #(30) pc_mux(epc_in, wr_data[31:2], next_pc, TakenInterrupt);
  mux3v #(32) rd_mux(rd_data, status_register, cause_register, {epc_out, 2'b0}, rd_op);
  assign EPC = epc_out;

  assign status_register[31:16] = 16'b0;
  assign status_register[7:2] = 6'b0;
  assign status_register[15:8] = user_status[15:8];
  assign status_register[1] = exception_level;
  assign status_register[0] = user_status[0];

  assign cause_register[31:16] = 16'b0;
  assign cause_register[14:0] = 15'b0;
  assign cause_register[15] = TimerInterrupt;

endmodule
