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
		end
		1100011://BEQ
		begin
		end
		1100111://BNE
		begin
		end
		0110111://LUI
		begin
		end
	endcase
	end
endmodule
		/*
		saida[63:12] = 0;
		saida[11:0] = entrada[31:20];	
		*/
