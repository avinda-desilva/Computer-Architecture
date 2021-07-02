// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC, next_PC, next_PC4, PC_Connect;

    wire[31:0] RS_Data, RT_Data, out, B, B_Out, imm32, update_negative;
    wire[31:0] jump, lui_con, data_out, branch_offset, addm_Data;
    wire[31:0] slt_out, RD_Data, RD_DataChange, mem_readout;
    wire[31:0] byte_in, byte_out, byte_connect, addr;


    wire[1:0] control_type;
    wire[2:0] alu_op;
    wire[4:0] R_Dest;


    wire write_enable, lui, rd_src, alu_src2, mem_read, word_we, byte_we, byte_load, slt, addm;
    wire overflow, zero, negative;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, next_PC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (RS_Data, RT_Data, inst[25:21], inst[20:16], R_Dest, RD_Data, write_enable, clock, reset);

    /* add other modules */



    assign update_negative[31:1] = 0;
    assign update_negative[0] = negative;

    assign jump[0] = 0;
    assign jump[1] = 0;
    assign jump[31:28] = PC[31:28];
    assign jump[27:2] = inst[25:0];

    assign lui_con[15:0] = 0;
    assign lui_con[31:16] = inst[15:0];

    assign byte_connect[31:8] = 0;

    mips_decode md1(alu_op, write_enable, rd_src, alu_src2, except, control_type, mem_read,
                    word_we, byte_we, byte_load, lui, slt, addm, inst[31:26], inst[5:0], zero);
    data_mem dm1(data_out, out, RT_Data, word_we, byte_we, clock, reset);

    alu32 a1(next_PC4, , , , PC, 32'b100, 3'b010);
    alu32 a2(PC_Connect, , , , next_PC4, branch_offset, 3'b010);
    alu32 a3(out, overflow, zero, negative, RS_Data, B, alu_op);
    alu32 a4(addm_Data, , , , RT_Data, data_out, 3'b010);

    mux2v #(5) m1_src(R_Dest, inst[15:11], inst[20:16], rd_src);
    mux2v #(32) m2_sltout(slt_out, out, slt, slt);
    mux2v m3_addmfin(RD_Data, RD_DataChange, addm_Data, addm);
    mux2v #(32) m4_luiout(RD_DataChange, mem_readout, lui_con[31:0], lui);
    mux2v #(32) m5_memreadout(mem_readout, slt_out, mem_read, mem_read);
    mux2v #(32) m6_byteload(byte_out, data_out, byte_connect, byte_load);
    mux2v m7_addmB(B, B_Out, 32'b0, addm);
    mux2v #(32) m8_Bout(B_Out, RT_Data, imm32, alu_src2);


    mux4v #(32) m4_1(next_PC, next_PC4, PC_Connect, jump, RS_Data, control_type);
    mux4v #(8) m4_dataoutput(byte_connect[7:0], data_out[31:24], data_out[23:16], data_out[15:8], data_out[7:0], out[1:0]);

    assign imm32 = {{16{inst[15]}},inst[15:0]};
    assign branch_offset[31:2] = imm32[29:0];
    assign branch_offset[0] = 0;
    assign branch_offset[1] = 0;

endmodule // full_machine
