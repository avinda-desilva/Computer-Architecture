// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    wire a1, o1, no1, xo1;
    input [1:0] control;
    and A_gate(a1, A, B);
    or B_gate(o1, A, B);
    nor C_gate(no1, A, B);
    xor D_gate(xo1, A, B);
    mux4 logicunit(out, a1, o1, no1, xo1, control);

endmodule // logicunit
