module decoder_test;
    reg [5:0] opcode, funct;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

             opcode = `OP_OTHER0; funct = `OP0_ADD; // try addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // try subtraction

        // add more tests here!
        # 10 opcode = `OP_OTHER0; funct = `OP0_AND; // testing and
        # 10 opcode = `OP_OTHER0; funct = `OP0_OR; // testing or
        # 10 opcode = `OP_OTHER0; funct = `OP0_NOR; // testing nor
        # 10 opcode = `OP_OTHER0; funct = `OP0_XOR; // testing xor
        # 10 opcode = `OP_ADDI; funct = `OP_OTHER0; // testing add immediate
        # 10 opcode = `OP_ANDI; funct = `OP_OTHER0; // testing and immediate
        # 10 opcode = `OP_ORI; funct = `OP_OTHER0; // testing or immediate
        # 10 opcode = `OP_XORI; funct = `OP_OTHER0; // testing xor immediate
        # 10 opcode = `OP_OTHER0; funct = `OP_ADDI; // making sure l-type only works in opcode
        # 10 opcode = `OP_OTHER1; funct = `OP0_AND; // testing except flag
        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       alu_src2, rd_src, writeenable, except;
    mips_decode decoder(alu_src2, rd_src, writeenable, alu_op, except,
                        opcode, funct);
endmodule // decoder_test
