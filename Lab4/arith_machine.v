// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    //   [31:0]
    wire [31:0] inst;
    wire [31:0] PC;
    wire [31:0] next_PC;
    wire [31:0] RS_Data;
    wire [31:0] RT_Data;
    wire [31:0] B;
    wire [31:0] out;
    wire [31:0] imm32;

    //   [4:0]
    wire [4:0] R_Dest;

    //   [2:0]
    wire [2:0] alu_op;

    wire write_enable, alu_src2, rd_src, overflow, zero, negative;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, next_PC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (RS_Data, RT_Data, inst[25:21], inst[20:16], R_Dest, out, write_enable, clock, reset);


    /* add other modules */

    alu32 a1(next_PC, , , , PC, 32'b100, 3'b010);
    mux2v #(5) mu1(R_Dest, inst[15:11], inst[20:16], rd_src);
    assign imm32 = {{16{inst[15]}} , inst[15:0]};
    alu32 a2(out, overflow, zero, negative, RS_Data, B, alu_op);
    mips_decode md1(alu_op, write_enable, rd_src, alu_src2, except, inst[31:26], inst[5:0]);
    mux2v mu2(B, RT_Data, imm32, alu_src2);


endmodule // arith_machine
