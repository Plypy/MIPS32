----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity aluc is
  port (
    INST : in VEC32;
    SHAMT : out VEC5;
    ALUOP : out ALU_TYPE
  );
end entity aluc;

architecture behav of aluc is
  alias op_field : VEC6 is INST(31 downto 26);
  alias rs_field : VEC5 is INST(25 downto 21);
  alias rt_field : VEC5 is INST(20 downto 16);
  alias rd_field : VEC5 is INST(15 downto 11);
  alias sh_field : VEC5 is INST(10 downto 6);
  alias func_field : VEC6 is INST(5 downto 0);
  signal special, regimm, srl_type, srlv_type : ALU_TYPE;
begin
  SHAMT <= sh_field;

  srl_type <= ALU_SRL when (rs_field(0) = '0') else ALU_ROTR;
  srlv_type <= ALU_SRLV when (sh_field(0) = '0') else ALU_ROTRV;

  with func_field select special <=
    ALU_SLL when FUNC_SPC_SLL,
    srl_type when FUNC_SPC_SRL,
    ALU_SRA when FUNC_SPC_SRA,
    ALU_SLLV when FUNC_SPC_SLLV,
    srlv_type when FUNC_SPC_SRLV,
    ALU_SRAV when FUNC_SPC_SRAV,

    ALU_ADD when FUNC_SPC_ADD,
    ALU_ADDU when FUNC_SPC_ADDU,
    ALU_SUB when FUNC_SPC_SUB,
    ALU_SUBU when FUNC_SPC_SUBU,
    ALU_AND when FUNC_SPC_AND,
    ALU_OR when FUNC_SPC_OR,
    ALU_XOR when FUNC_SPC_XOR,
    ALU_NOR when FUNC_SPC_NOR,

    ALU_SLT when FUNC_SPC_SLT,
    ALU_SLTU when FUNC_SPC_SLTU;

  with op_field select ALUOP <=
    special when OP_SPECIAL,
    ALU_SUBU when OP_BEQ,
    ALU_SUBU when OP_BNE,
    ALU_SUBU when OP_BLEZ,
    ALU_SUBU when OP_BGTZ,
    ALU_ADD when OP_ADDI,
    ALU_ADDU when OP_ADDIU,
    ALU_SLT when OP_SLTI,
    ALU_SLTU when OP_SLTIU,
    ALU_AND when OP_ANDI,
    ALU_OR when OP_ORI,
    ALU_XOR when OP_XORI,
    ALU_ADDU when OP_LUI,

    ALU_ADDU when OP_LB,
    ALU_ADDU when OP_LBU,
    ALU_ADDU when OP_LH,
    ALU_ADDU when OP_LHU,
    ALU_ADDU when OP_LW,
    ALU_ADDU when OP_SB,
    ALU_ADDU when OP_SH,
    ALU_ADDU when OP_SW;


end architecture behav;