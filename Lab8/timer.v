module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;
    wire reset_value, timer_write, timer_read, acknowledge, interrupt_enable, interrupt_reset;
    wire          interrupt_1, interrupt_2;
    wire [31:0]    cycle_out, interrupt_out, alu_wire;
    // complete the timer circuit here
    //assign reset_value = 32'hffffffff;
    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
    // added modules
    alu32 #(32) alu1(alu_wire, , , `ALU_ADD, cycle_out, 32'b1);
    register #(32) cycle_counter(cycle_out, alu_wire, clock, 1'b1, reset);
    register #(32, 32'hffffffff) interrupt_cycle(interrupt_out, data, clock, timer_write, reset);
    assign interrupt_enable = (interrupt_out == cycle_out);
    or o2(interrupt_reset, acknowledge, reset);
    // and
    assign interrupt_1 = (address == 32'hffff001c);
    assign interrupt_2 = (address == 32'hffff006c);
    and a1(timer_read, MemRead, interrupt_1);
    and a2(timer_write, MemWrite, interrupt_1);
    and a3(acknowledge, MemWrite, interrupt_2);
    or o1(TimerAddress, interrupt_1, interrupt_2);
    tristate tri_1(cycle, cycle_out, timer_read);
    register #(1) interrupt_line(TimerInterrupt, 1'b1, clock, interrupt_enable, interrupt_reset);

endmodule
