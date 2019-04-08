module mux2(
	input SELETOR,
	input logic [63:0]ENTRADA_1, ENTRADA_2,
	output logic [63:0] SAIDA
	);

	always_comb
			case(SELETOR)
				0: SAIDA=ENTRADA_1;
				1: SAIDA=ENTRADA_2;
			endcase 
endmodule
