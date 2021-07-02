module blackbox_test;

      reg z_in, b_in, v_in;

      wire r_out;

      blackbox b_box (r_out, z_in, b_in, v_in);

      initial begin                             // initial = run at beginning of simulation
                                                // begin/end = associate block with initial

          $dumpfile("blackbox.vcd");                  // name of dump file to create
          $dumpvars(0,blackbox_test);                 // record all signals of module "sc_test" and sub-modules
                                                // remember to change "sc_test" to the correct
                                                // module name when writing your own test benches

          z_in = 0; b_in = 0; v_in = 0; # 10;             // set initial values and wait 10 time units
          z_in = 0; b_in = 0; v_in = 1; # 10;             // change inputs and then wait 10 time units
          z_in = 0; b_in = 1; v_in = 0; # 10;             // as above
          z_in = 0; b_in = 1; v_in = 1; # 10;
          z_in = 1; b_in = 0; v_in = 0; # 10;
          z_in = 1; b_in = 0; v_in = 1; # 10;
          z_in = 1; b_in = 1; v_in = 0; # 10;
          z_in = 1; b_in = 1; v_in = 1; # 10;

          $finish;                              // end the simulation
      end

      initial
          $monitor("At time %2t, z_in = %d b_in = %d v_in = %d r_out = %d",
                   $time, z_in, b_in, v_in, r_out);

endmodule // blackbox_test
