module ShiftL1(
		input logic [63:0]entrada,
		output logic [63:0]saida
		);
	always_comb
	begin
		saida[63:1] = entrada[62:0];
		saida[0] = 0;
	end
endmodule
