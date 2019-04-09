module up( //FALTA COLOCAR OS FIOS DO SIGN EXTEND!!
	input logic CLK, RESET//ok
	);

wire ALU_SRCA;
wire [1:0] ALU_SRCB;
wire IR_WIRE;
wire LOAD_A;
wire LOAD_B;
wire PC_WRITE;//ok
wire RESET_WIRE;//ok
wire MEM32_WIRE;//ok
wire BANCO_WIRE;//ok
wire LOAD_A_OUT; //ok
wire LOAD_MDR; //ok
wire MEM_TO_REG; //ok
wire WRITE_REG; //ok
wire DMEM_RW; //ok
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
wire [63:0] RS1;
wire [63:0] RS2;
wire [63:0] REG_A_MUX;//REGA
wire [63:0] REG_B_MUX;//REGB
wire [63:0] SIGN_OUT;
wire [63:0] SHIFT_OUT;


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
	.IR24_20(IR24_20),
	.LOAD_A(LOAD_A),
	.LOAD_B(LOAD_B),
	.BANCO_WIRE(BANCO_WIRE)
	);

mux2 MUX_A(
	.SELETOR(ALU_SRCA),
	.ENTRADA_1(PC_OUT),
	.ENTRADA_2(REG_A_MUX),
	.ENTRADA_3(64'd0),
	.SAIDA(A_IN_ALU)
	);

mux4 MUX_B(
	.SELETOR(ALU_SRCB),
	.A(REG_B_MUX),
	.B(64'd4),
	.C(SIGN_OUT),
	.D(),
	.SAIDA(B_IN_ALU)
	);

ula64 ALU (
	.A(A_IN_ALU),
	.B(),
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

bancoReg BANCOREG(
	.write(BANCO_WIRE), 
	.clock(CLK),
        .reset(RESET),
        .regreader1(IR19_15),
        .regreader2(IR24_20),
        .regwriteaddress(IR11_7),
        .datain(),
        .dataout1(RS1),
        .dataout2(RS2)
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

register REG_A(
	.clk(CLK),
	.reset(RESET),
	.regWrite(LOAD_A),
	.DadoIn(RS1),
	.DadoOut(REG_A_MUX)
	);

register REG_B(
	.clk(CLK),
	.reset(RESET),
	.regWrite(LOAD_B),
	.DadoIn(RS2),
	.DadoOut(REG_B_MUX)
	);

SignExt SIGNEXT(
	.entrada(IR31_0),
	.saida(SIGN_OUT)
	);

ShiftL1 SHIFTL1(
	.entrada(SIGN_OUT),
	.saida(SHIFT_OUT)
	);

endmodule
