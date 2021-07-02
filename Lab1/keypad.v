module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire abc;
   assign valid = (d & (a | b | c)) | (e & (a | b | c)) | (f & (a | b | c)) | (g & b);

   assign number[0] = (d & (a | c)) | (e & b) | (f & (a | c));
   assign number[1] = (d & (b | c)) | (e & c) | (f & a);
   assign number[2] = (e & (a | b | c)) | (f & a);
   assign number[3] = (f & (b | c));

endmodule // keypad
