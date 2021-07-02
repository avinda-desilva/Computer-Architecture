// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire add_operation, sub_operation, and_operation, or_operation, nor_operation, xor_operation;
    wire addi_operation, andi_operation, ori_operation, xori_operation;
    wire bne_operation, beq_operation, j_operation, jr_operation, lui_operation, slt_operation;
    wire lw_operation, lbu_operation, sw_operation, sb_operation, addm_operation;

    assign and_operation = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
    assign or_operation = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
    assign add_operation = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
    assign sub_operation = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
    assign nor_operation = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
    assign xor_operation = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);

    assign andi_operation = (opcode == `OP_ANDI);
    assign ori_operation = (opcode == `OP_ORI);
    assign addi_operation = (opcode == `OP_ADDI);
    assign xori_operation = (opcode == `OP_XORI);

    assign bne_operation = (opcode == `OP_BNE);
    assign beq_operation = (opcode == `OP_BEQ);
    assign j_operation = (opcode == `OP_J);
    assign jr_operation = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
    assign lui_operation = (opcode == `OP_LUI);
    assign slt_operation = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
    assign lw_operation = (opcode == `OP_LW);
    assign lbu_operation = (opcode == `OP_LBU);
    assign sw_operation = (opcode == `OP_SW);
    assign sb_operation = (opcode == `OP_SB);
    assign addm_operation = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);

    //slt = 011; lbu = 010;


    assign alu_src2 = (addi_operation | andi_operation | ori_operation | xori_operation | lw_operation | sw_operation | lbu_operation | sb_operation);
    assign rd_src = (addi_operation | andi_operation | ori_operation | xori_operation | lw_operation | sw_operation | lbu_operation | sb_operation | lui_operation);

    assign except = ~(add_operation | sub_operation | and_operation | or_operation |
                      nor_operation | xor_operation |addi_operation | andi_operation |
                      ori_operation | xori_operation | beq_operation | bne_operation |
                      j_operation | jr_operation | lui_operation | slt_operation | lw_operation |
                      lbu_operation | sw_operation | sb_operation | addm_operation);

    assign writeenable = (add_operation | sub_operation | and_operation | or_operation |
                      nor_operation | xor_operation |addi_operation | andi_operation |
                      ori_operation | xori_operation | lw_operation |lbu_operation |
                      lui_operation | slt_operation | addm_operation);

    assign alu_op[0] = (sub_operation | or_operation | xor_operation | ori_operation | xori_operation | bne_operation | beq_operation | slt_operation);
    assign alu_op[1] = (add_operation | sub_operation| nor_operation | xor_operation | addi_operation | xori_operation | bne_operation | beq_operation | addm_operation | lw_operation | sw_operation | slt_operation | lbu_operation | sb_operation);
    assign alu_op[2] = (and_operation | or_operation | nor_operation | xor_operation | andi_operation | ori_operation | xori_operation );

    assign control_type[0] = jr_operation | (bne_operation & ~zero) | (beq_operation & zero);
    assign control_type[1] = j_operation | jr_operation;
    assign mem_read = lw_operation | lbu_operation;
    assign word_we = sw_operation;
    assign byte_we = sb_operation;
    assign byte_load = lbu_operation;
    assign slt = slt_operation;
    assign lui = lui_operation;
    assign addm = addm_operation;


endmodule // mips_decode
