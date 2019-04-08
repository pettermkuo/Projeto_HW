module SignExt(
		input logic [31:0]entrada,
		output logic [63:0]saida
		);
	always_comb
	begin 
		saida[63:12] = 0;
		saida[11:0] = entrada[31:20];	
	end
endmodule
