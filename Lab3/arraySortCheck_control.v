
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array;
	input clock, reset;
	wire sGarbage, sStart, sWhile, sSorted, sDone, sInc;

	wire sGarbage_next = reset | (sGarbage & ~go);
	wire sStart_next = ((sGarbage & go) | (sDone & go) | (sSorted & go) | (sStart & go)) & ~reset;
	wire sWhile_next = ((sStart & ~go) | (sInc)) & ~reset;
	wire sInc_next = sWhile & ~end_of_array & ~inversion_found & ~reset;
	wire sSorted_next = ((sWhile & end_of_array)  | (sSorted & ~go)) & ~reset;
	wire sDone_next = ((sWhile & inversion_found) | (sDone & ~go)) & ~reset;

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);
	dffe fsWhile(sWhile, sWhile_next, clock, 1'b1, 1'b0);
	dffe fsInc(sInc, sInc_next, clock, 1'b1, 1'b0);
	dffe fsSorted(sSorted, sSorted_next, clock, 1'b1, 1'b0);
	dffe fsDone(sDone, sDone_next, clock, 1'b1, 1'b0);

	assign done = (sSorted) | (sDone);
	assign sorted = (sSorted);
	assign load_input = sStart;
	assign select_index = sInc;
	assign load_index = sStart | sInc;


endmodule
