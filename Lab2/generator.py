## a code generator for the ALU chain in the 32-bit ALU
## look at example_generator.py for inspiration
##
## python generator.py
from __future__ import print_function

width = 32
for i in range(0, width):
    print("    dffe df{0}(q[{0}], d[{0}], clk, enable, reset);".format(i))
