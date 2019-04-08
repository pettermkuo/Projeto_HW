module mux4(
	input logic [1:0] SELETOR,
	input logic [63:0]A, B, C, D,
	output logic [63:0] SAIDA
	);

	always_comb
			case(SELETOR)
				0: SAIDA=A;
				1: SAIDA=B;
				2: SAIDA=C;
				3: SAIDA=D;
			endcase 
endmodule
