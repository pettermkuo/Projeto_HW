module SignExt(
		input logic [31:0]entrada,
		input logic [6:0] IR6_0,
		output logic [63:0]saida
		);
	always_comb
	begin 
	case(IR6_0)
		0010011://ADDI
		begin
			saida[63:12] = 0;
			saida[11:0] = entrada[31:20];
		end
		1100011://BEQ
		begin
			saida[0] = 0;
			saida[4:1] = entrada[11:8];
			saida[10:5] = entrada[30:25];
			saida[11] = entrada[7];
			saida[12] = entrada[31];
			saida[64:13] = 0;
		end
		1100111://BNE
		begin
			saida[0] = 0;
			saida[4:1] = entrada[11:8];
			saida[10:5] = entrada[30:25];
			saida[11] = entrada[7];
			saida[12] = entrada[31];
			saida[64:13] = 0;
		end
		0110111://LUI
		begin
		end
	endcase
	end
endmodule
