module uc(
	input logic CLK,
	input logic RESET,
	input logic [31:0] IR31_0,
	input logic [4:0] IR11_7, IR19_15, IR24_20,
	input logic [6:0] IR6_0,
	output logic ALU_SRCA, RESET_WIRE, PC_WRITE, IR_WIRE, MEM32_WIRE, LOAD_A, LOAD_B, BANCO_WIRE,	
	output logic [2:0] ALU_SELECTOR,
	output logic [6:0] ESTADO_ATUAL,
	output logic [1:0] ALU_SRCB
	);

	enum logic [6:0]{
		RESET_ESTADO, //0
		BUSCA, //1
		SOMA, //2
		DECODE, //3
		R, //4
		ADDI, //5
		SD, //6 
		LD, //7
		BEQ, BEQ2, //8,9
		BNE, BNE2, // 10,11
		LUI //12
	}ESTADO, PROX_ESTADO;
	
	always_ff@(posedge CLK, posedge RESET)
	begin
		if(RESET)
		begin
			ESTADO<=RESET_ESTADO;
		end
		else 
		begin
			ESTADO<=PROX_ESTADO;
		end
	end
	
	assign ESTADO_ATUAL = ESTADO;

	always_comb 
	case(ESTADO)
		RESET_ESTADO:
		begin
			PC_WRITE = 0;
			RESET_WIRE = 1;
			ALU_SRCA = 0;
			ALU_SRCB = 0;
			ALU_SELECTOR = 0;
			MEM32_WIRE = 0;
			IR_WIRE = 0;
			LOAD_A = 0;
			LOAD_B = 0;
			//BANCO_WIRE = ;
			PROX_ESTADO = BUSCA;
		end

		BUSCA:
		begin
			PC_WRITE = 0;
			RESET_WIRE = 0;
			ALU_SRCA = 0;
			ALU_SRCB = 0;
			ALU_SELECTOR = 0;
			MEM32_WIRE = 0;
			IR_WIRE = 1;
			LOAD_A = 0;
			LOAD_B = 0;
			//BANCO_WIRE = ;
			PROX_ESTADO = SOMA;
		end

		SOMA:
		begin
			PC_WRITE = 1;
			RESET_WIRE = 0;
			ALU_SRCA = 0;
			ALU_SRCB = 1;
			ALU_SELECTOR = 1;
			MEM32_WIRE = 0;
			IR_WIRE = 0;
			LOAD_A = 0;
			LOAD_B = 0;
			//BANCO_WIRE = ;
			PROX_ESTADO = DECODE;
		end

		DECODE:
		begin
			case(IR6_0)//LER OPCODE
				0110011://ADD,SUB
					begin
						PROX_ESTADO = R;
					end

				0010011://ADDI
					begin
						PROX_ESTADO = ADDI;
					end

				0000011://LD
					begin
						PROX_ESTADO = LD;
					end

				0100011://SD
					begin
						PROX_ESTADO = SD;
					end

				1100011://BEQ1
					begin
						PROX_ESTADO = BEQ;
					end

				1100111://BNE
					begin
						PROX_ESTADO = BNE;
					end

				0110111://LUI
					begin
						PROX_ESTADO = LUI;
					end
			endcase
		end

		R:
			begin
				/*
				case(IR31_0 [31:25]) //CONFIRMAR QUE A FUNCT7 TA NESSE INTERVALO E VE SE PODE DEIXAR ASSIM
				0000000: //ADD
				begin
					PC_WRITE = 0;
					RESET_WIRE = 0;
					ALU_SRCA = 1; //SELECIONA O REG_A_MUX
					ALU_SRCB = 0; //SELECIONA O REG_B_MUX
					ALU_SELECTOR = 1; //SOMA 001
					MEM32_WIRE = 0;
					IR_WIRE = 0;
					LOAD_A = 1; //?
					LOAD_B = 1; //?
					PROX_ESTADO = BUSCA;
				end
				0100000: //SUB
				begin
					PC_WRITE = 0;
					RESET_WIRE = 0;
					ALU_SRCA = 1; //SELECIONA O REG_A_MUX
					ALU_SRCB = 0; //SELECIONA O REG_B_MUX
					ALU_SELECTOR = 2; //SUB 010
					MEM32_WIRE = 0;
					IR_WIRE = 0;
					LOAD_A = 1; //?
					LOAD_B = 1; //?
					PROX_ESTADO = BUSCA;
				end
				*/
		end

		ADDI:
			begin
				PC_WRITE = 0;
				RESET_WIRE = 0;
				ALU_SRCA = 1;
				ALU_SRCB = 2;
				ALU_SELECTOR = 1;
				MEM32_WIRE = 0;
				IR_WIRE = 0;
				LOAD_A = 0;
				LOAD_B = 0;
				//BANCO_WIRE = ;
				PROX_ESTADO = BUSCA;
			end

		SD:
			begin
			end

		LD:
			begin
			end

		BEQ:
			begin
				PC_WRITE = 0;
				RESET_WIRE = 0;
				ALU_SRCA = 1;
				ALU_SRCB = 0;
				ALU_SELECTOR = 011;//3
				MEM32_WIRE = 0;
				IR_WIRE = 1;
				LOAD_A = 1;
				LOAD_B = 1;
				//BANCO_WIRE = ;
				PROX_ESTADO = BEQ2;
			end

		BNE:
			begin
				PC_WRITE = 0;
				RESET_WIRE = 0;
				ALU_SRCA = 1;
				ALU_SRCB = 0;
				ALU_SELECTOR = 011;//3
				MEM32_WIRE = 0;
				IR_WIRE = 1;
				LOAD_A = 1;
				LOAD_B = 1;
				//BANCO_WIRE = ;
				PROX_ESTADO = BNE2;
			end

		LUI:
			begin
			end

		
	endcase
endmodule
