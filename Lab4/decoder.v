// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output  writeenable, rd_src, alu_src2, except;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

		wire add_operation, sub_operation, and_operation, or_operation, nor_operation, xor_operation;
    wire addi_operation, andi_operation, ori_operation, xori_operation;

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

    assign alu_src2 = (addi_operation | andi_operation | ori_operation | xori_operation);
    assign rd_src = (addi_operation | andi_operation | ori_operation | xori_operation);

    assign except = ~(add_operation | sub_operation | and_operation | or_operation |
                      nor_operation | xor_operation |addi_operation | andi_operation |
                      ori_operation | xori_operation);
    assign writeenable = ~except;

    assign alu_op[0] = (sub_operation | or_operation | xor_operation | ori_operation | xori_operation);
    assign alu_op[1] = (add_operation | sub_operation| nor_operation | xor_operation | addi_operation | xori_operation);
    assign alu_op[2] = (and_operation | or_operation | nor_operation | xor_operation | andi_operation | ori_operation | xori_operation);



endmodule // mips_decode
