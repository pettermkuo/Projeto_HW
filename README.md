## Módulos cedidos

1. Banco de Registradores 	(bancoReg.sv)
2. Módulo de Deslocamento 	(Deslocamento.sv)
3. Registrador de Instruções (Instr_Reg_RISC_V.vhd)
4. Memória de Instruções de 32 bits (Memoria32.sv)
5. Memória de Dados de 64 bits (Memoria64.sv)
6. Registrador de Propósito Geral (register.sv)
7. Unidade Lógico Aritmética de 64 bits (ula64.vhd)

Os arquivos instructions.mif e dados.mif devem estar na mesma pasta dos arquivos de memória de instrução e dados, respectivamente, na compilação do projeto. Estes arquivos contém os valores presentes na memória.
Para gerar arquivos mif é possível fazer uso do montador disponível também neste repositório.

Os arquivos ramOnChip32.v e ramOnChip64.v também devem estar na mesma pasta dos arquivos de memória, uma vez que são arquivos necessários para o funcionamento da memória. 