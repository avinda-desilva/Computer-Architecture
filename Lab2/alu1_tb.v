module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v

reg [2:0] control = 0;

     // cycle through all combinations of A, B, C, D every 16 time units
     reg A = 0;
     always #1 A = !A;
     reg B = 0;
     always #2 B = !B;
     reg cin_in = 0;
     always #4 cin_in = !cin_in;

     initial begin
         $dumpfile("alu1.vcd");
         $dumpvars(0, alu1_test);

         // control is initially 0
         # 16 control = 1; // wait 16 time units (why 16?) and then set it to 1
         # 16 control = `ALU_ADD; // wait 16 time units and then set it to 2
         # 16 control = `ALU_SUB; // wait 16 time units and then set it to 3
         # 16 control = `ALU_AND;
         # 16 control = `ALU_OR;
         # 16 control = `ALU_NOR;
         # 16 control = `ALU_XOR;
         # 16 $finish; // wait 16 time units and then end the simulation
     end

     wire out, carryout;
     alu1 a1(out, carryout, A, B, cin_in, control);

     // you really should be using gtkwave instead
     /*
     initial begin
         $display("A B cin_in cout out");
         $monitor("%d %d %d %d %d %d (at time %t)", A, B, cin_in, carryout, control, out, $time);
     end
     */
endmodule // alu1_test
