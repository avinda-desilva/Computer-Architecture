//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB;
        # 10 A = 13; B = 7; control = `ALU_SUB;
        # 10 A = 27; B = 43; control = `ALU_AND;
        # 10 A = 76; B = -53; control = `ALU_NOR;
        # 10 A = -26; B = 78; control = `ALU_XOR;
        # 10 A = 53; B = 53; control = `ALU_SUB;
        # 10 A = -85; B = -85; control = `ALU_SUB;
        # 10 A = 7; B = 2137443672; control = `ALU_SUB;
        # 10 A = 2137443672; B = 2137443672; control = `ALU_ADD;
        # 10 A = -2137443672; B = -2137443672; control = `ALU_ADD;
        # 10 A = 337443672; B = -2137443672; control = `ALU_SUB;


        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);
endmodule // alu32_test
