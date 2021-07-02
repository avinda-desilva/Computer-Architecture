module decoder_test;
    reg [5:0] opcode, funct;
    reg       zero  = 0;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

        // remember that all your instructions from last week should still work
             opcode = `OP_OTHER0; funct = `OP0_ADD; // see if addition still works
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // see if subtraction still works


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
        // test all of the others here

        // as should all the new instructions from this week
        # 10 opcode = `OP_BEQ; zero = 0; // try a not taken beq
        # 10 opcode = `OP_BEQ; zero = 1; // try a taken beq
        # 10 opcode = `OP_BNE; zero = 1; // try a not taken bne
        # 10 opcode = `OP_BNE; zero = 0; // try a taken bne
        # 10 opcode = `OP_J; // testing jump
        # 10 opcode = `OP_OTHER0; funct = `OP0_JR; // testing jump register
        # 10 opcode = `OP_LUI; // testing load upper imm
        # 10 opcode = `OP_OTHER0; funct = `OP0_SLT; // testing set less than
        # 10 opcode = `OP_LW; // testing load word
        # 10 opcode = `OP_LBU; // testing load byte unsigned
        # 10 opcode = `OP_SW; // testing store word
        # 10 opcode = `OP_SB; // testing store byte
        # 10 opcode = `OP_OTHER0; funct = `OP0_ADDM; // testing addm
        # 10 opcode = `OP_LUI; funct = `OP0_ADD; // testing more except flags
        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       writeenable, rd_src, alu_src2, except;
    wire [1:0] control_type;
    wire       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                        mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                        opcode, funct, zero);
endmodule // decoder_test
