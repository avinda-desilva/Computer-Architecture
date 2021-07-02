module test;
    reg       clk = 0, enable = 0, reset = 1;  // start by reseting the register file

    /* Make a regular pulsing clock with a 10 time unit period. */
    always #5 clk = !clk;
    //always #4 enable = !enable;
    reg [4:0] regnum;
    reg [31:0] d;

    wire [31:0] q;
    initial begin
        $dumpfile("register.vcd");
        $dumpvars(0, test);
        # 10  reset = 0;      // stop reseting the register

        # 10
          // write 88 to the register
          enable = 1;
          regnum = 2;
          d = 88;

        # 10
          // try writing to the register when its disabled
          enable = 0;
	  regnum = 2;
	  d = 89;


        #10
        // Add your own testcases here!
        enable = 1;
    regnum = 3;
    d = 45;

        #10
        enable = 1;
    regnum = 4;
    d = 67;

      #10
      enable = 0;
  regnum = 4;
  d = 96;

      #10
      enable = 1;
  regnum = 4;
  d = 12;
      #10
      enable = 1;
  regnum = 4;
  d = 17;

      #10
      enable = 1;
  regnum = 4;
  d = 29;

      #10
      enable = 1;
  regnum = 4;
  d = 45;

      #10
      enable = 1;
  regnum = 4;
  d = 87;

      #10
      enable = 1;
  regnum = 4;
  d = 10;

  //RESET TEST
  reset = 1;

  enable = 1;
  regnum = 4;
  d = 46;

  enable = 1;
  regnum = 4;
  d = 8;

  enable = 1;
  regnum = 4;
  d = 678;

  enable = 1;
  regnum = 4;
  d = 45;

  enable = 1;
  regnum = 4;
  d = 98;

  enable = 1;
  regnum = 4;
  d = 134;

  enable = 1;
  regnum = 4;
  d = 75;

        # 700 $finish;
    end

    initial begin
    end

    register reg1(q, d, clk, enable, reset);

endmodule // test
