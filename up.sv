module up( 
 input logic CLK, RESET
 );
wire RESET_WIRE;
wire ALU_SRCA;//ok
wire IR_WIRE;//ok
wire LOAD_A;//ok
wire LOAD_B;//ok
wire PC_WRITE;//ok
wire MEM32_WIRE;//ok
wire BANCO_WIRE;//ok
wire LOAD_MDR;//ok
wire LOAD_ALU_OUT;//ok
wire WRITE_REG;//?
wire DMEM_RW;//ok
wire Igual;//?
wire MUX_MR_WIRE;//ok
wire [1:0] ALU_SRCB;//ok
wire [1:0] Shift;//?
wire [2:0] ALU_SELECTOR;//ok
wire [4:0] IR19_15;//ok
wire [4:0] IR24_20;//ok
wire [4:0] IR11_7;//ok
wire [6:0] IR6_0;//ok
wire [15:0] SAIDA_ESTADO;//ok
wire [31:0] IR31_0;//ok
wire [31:0] MEM_TO_IR_32;//ok
wire [31:25]FUNCT7;
wire [63:0] MEM_TO_REG;//ok
wire [63:0] ALUOUT_TO_MUX;
wire [63:0] REGMEM_TO_MUX;
wire [63:0] MUX_TO_WRITE_DATA;
wire [63:0] ALU_OUT_TO_MEM;
wire [63:0] PC_IN;//ok
wire [63:0] PC_OUT;//ok
wire [63:0] MEM_TO_IR_64;//?
wire [63:0] A_IN_ALU;//ok
wire [63:0] B_IN_ALU;//ok
wire [63:0] RS1;//ok
wire [63:0] RS2;//ok
wire [63:0] REG_A_MUX;//ok
wire [63:0] REG_B_MUX;//ok
wire [63:0] SIGN_OUT;//ok
wire [63:0] SHIFT_OUT;//ok

uc UC(
 .CLK(CLK),//OK
 .RESET(RESET),//OK
 .ALU_SRCA(ALU_SRCA),//OK
 .ALU_SRCB(ALU_SRCB),
 .RESET_WIRE(RESET_WIRE),//OK
 .ALU_SELECTOR(ALU_SELECTOR),
 .PC_WRITE(PC_WRITE),//OK
 .MEM32_WIRE(MEM32_WIRE),//OK
 .DMEM_RW(DMEM_RW),//OK
 .IR_WIRE(IR_WIRE),//OK
 .IR6_0(IR6_0),//OK
 .IR11_7(IR11_7),//OK
 .IR19_15(IR19_15),//OK
 .IR24_20(IR24_20),//OK
 .IR31_0(IR31_0),//OK
 .LOAD_A(LOAD_A),//OK
 .LOAD_B(LOAD_B),//OK
 .BANCO_WIRE(BANCO_WIRE),//OK
 .LOAD_MDR(LOAD_MDR),//OK
 .Igual(Igual),
 .SAIDA_ESTADO(SAIDA_ESTADO),
 .LOAD_ALU_OUT(LOAD_ALU_OUT),//OK
 .FUNCT7(FUNCT7)
 );
mux2 MUX_A( //ok
 .SELETOR(ALU_SRCA),
 .ENTRADA_1(PC_OUT),
 .ENTRADA_2(REG_A_MUX),
 .SAIDA(A_IN_ALU)
 );
mux2 MUX_MR( //ok
 .SELETOR(MUX_MR_WIRE),
 .ENTRADA_1(ALUOUT_TO_MUX),
 .ENTRADA_2(REGMEM_TO_MUX),
 .SAIDA(MUX_TO_WRITE_DATA)
 );
mux4 MUX_B( //ok
 .SELETOR(ALU_SRCB),
 .A(REG_B_MUX),
 .B(64'd4),
 .C(SIGN_OUT),
 .D(SHIFT_OUT),
 .SAIDA(B_IN_ALU)
 );
ula64 ALU ( //ok
 .A(A_IN_ALU),
 .B(B_IN_ALU),
 .Seletor(ALU_SELECTOR),
 .S(PC_IN),
 .Overflow(),
 .Negativo(),
 .z(),
 .Igual(Igual),
 .Maior(),
 .Menor()
 );
Instr_Reg_RISC_V BANCO(//ok
 .Clk(CLK),
 .Reset(RESET),
 .Load_ir(IR_WIRE),
 .Entrada(MEM_TO_IR_32),
 .Instr19_15(IR19_15),
 .Instr24_20(IR24_20),
 .Instr11_7(IR11_7),
 .Instr6_0(IR6_0),
 .Instr31_0(IR31_0)
 );
bancoReg BANCOREG(//ok
 .write(BANCO_WIRE), //p
 .clock(CLK),
        .reset(RESET),
        .regreader1(IR19_15),
        .regreader2(IR24_20),
        .regwriteaddress(IR11_7),
        .datain(MUX_TO_WRITE_DATA),
        .dataout1(RS1),
        .dataout2(RS2)
);
Memoria32 MEMORIA32(//p
 .raddress(PC_OUT[31:0]), //endereÃ§o de ler
 .waddress(), //endereÃ§o de esrever (mem32 nunca escreve)
 .Clk(CLK),
 .Datain(),
 .Dataout(MEM_TO_IR_32),
 .Wr(MEM32_WIRE) //define se Ã© leitura ou escrita
 );
Memoria64 MEMORIA64(//p
 .raddress(ALU_OUT_TO_MEM), //endereÃ§o de ler //PC_IN pq eh a saida do alu_out
 .waddress(ALU_OUT_TO_MEM), //endereÃ§o de escrever
 .Clk(CLK),
 .Datain(REG_B_MUX),
 .Dataout(MEM_TO_REG), //saida vai ser a entrada do memory data reg
 .Wr(DMEM_RW) //wr se for 0 le, se for 1 escreve
 );
register PC(//ok
 .clk(CLK),
 .reset(RESET),
 .regWrite(PC_WRITE),
 .DadoIn(PC_IN),
 .DadoOut(PC_OUT)
 );
register REG_A(//ok
 .clk(CLK),
 .reset(RESET),
 .regWrite(LOAD_A),
 .DadoIn(RS1),
 .DadoOut(REG_A_MUX)
 );
register REG_B(//ok
 .clk(CLK),
 .reset(RESET),
 .regWrite(LOAD_B),
 .DadoIn(RS2),
 .DadoOut(REG_B_MUX)
 );
 
SignExt SIGNEXT(//ok
 .entrada(IR31_0),
 .saida(SIGN_OUT),
 .IR6_0(IR6_0)
 );
ShiftL1 SHIFTL1(//ok
 .entrada(SIGN_OUT),
 .saida(SHIFT_OUT)
 );
register ALU_OUT(//ok
 .clk(CLK),
 .reset(RESET),
 .regWrite(LOAD_ALU_OUT),
 .DadoIn(PC_IN),
 .DadoOut(ALU_OUT_TO_MEM)
 );
endmodule
