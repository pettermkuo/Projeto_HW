module up( //FALTA COLOCAR OS FIOS DO SIGN EXTEND!!
	input logic CLK, RESET
	);

wire ALU_SRCA;
wire ALU_SRCB;
wire IR_WIRE;
wire PC_WRITE;
wire RESET_WIRE;
wire [63:0] PC_IN;
wire [63:0] PC_OUT;
wire [31:0] MEM_TO_IR;
wire [63:0] A_IN_ALU;
wire [63:0] B_IN_ALU;
wire [6:0] IR6_0;
wire [4:0] IR11_7;
wire [4:0] IR19_15;
wire [4:0] IR24_20;
wire [31:0] IR31_0;
wire [2:0] ALU_SELECTOR;
wire MEM32_WIRE;

uc UC(
	.CLK(CLK),
	.RESET(RESET),
	.ALU_SRCA(ALU_SRCA),
	.ALU_SRCB(ALU_SRCB),
	.RESET_WIRE(RESET_WIRE),
	.ALU_SELECTOR(ALU_SELECTOR),
	.PC_WRITE(PC_WRITE),
	.MEM32_WIRE(MEM32_WIRE),
	.IR_WIRE(IR_WIRE),
	.IR6_0(IR6_0),
	.IR11_7(IR11_7),
	.IR19_15(IR19_15),
	.IR24_20(IR24_20)
	);

mux2 A(
	.SELETOR(ALU_SRCA),
	.A(PC_OUT),
	.B(),
	.SAIDA(A_IN_ALU)
	);
/*
mux2 B(
	.SELETOR(ALU_SRCB),
	.A(),
	.B(),
	.SAIDA(B_IN_ALU)
	);
*/
ula64 ALU (
	.A(A_IN_ALU),
	.B(64'd4),
	.Seletor(ALU_SELECTOR),
	.S(PC_IN),
	.Overflow(),
	.Negativo(),
	.z(),
	.Igual(),
	.Maior(),
	.Menor()
	);

Instr_Reg_RISC_V BANCO(
	.Clk(CLK),
	.Reset(RESET),
	.Load_ir(IR_WIRE),
	.Entrada(MEM_TO_IR),
	.Instr19_15(IR19_15),
	.Instr24_20(IR24_20),
	.Instr11_7(IR11_7),
	.Instr6_0(IR6_0),
	.Instr31_0(IR31_0)
	);

Memoria32 MEMORIA32(
	.raddress(PC_OUT[31:0]),
	.waddress(),
	.Clk(CLK),
	.Datain(),
	.Dataout(MEM_TO_IR),
	.Wr(MEM32_WIRE)
	);

register PC(
	.clk(CLK),
	.reset(RESET),
	.regWrite(PC_WRITE),
	.DadoIn(PC_IN),
	.DadoOut(PC_OUT)
	);
/*
register REGA(
	.clk(CLK),
	.reset(RESET),
	.regWrite(),
	.DadoIn(),
	.DadoOut()
	);

register REGB(
	.clk(CLK),
	.reset(RESET),
	.regWrite(),
	.DadoIn(),
	.DadoOut()
	);
*/

endmodule
