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
  signal special, regimm : ALU_TYPE;
begin
  with func_field select special <=
    ALU_ADD when FUNC_SPC_ADD,
    ALU_ADDU when FUNC_SPC_ADDU,
    ALU_SUB when FUNC_SPC_SUB,
    ALU_SUBU when FUNC_SPC_SUBU,
    ALU_AND when FUNC_SPC_AND,
    ALU_OR when FUNC_SPC_OR,
    ALU_XOR when FUNC_SPC_XOR,
    ALU_NOR when FUNC_SPC_NOR;

  with op_field select ALUOP <=
    special when OP_SPECIAL,
    ALU_SUBU when OP_BEQ,
    ALU_SUBU when OP_BNE,
    ALU_SUBU when OP_BLEZ,
    ALU_SUBU when OP_BGTZ,
    ALU_ADD when OP_ADDI,
    ALU_ADDU when OP_ADDIU;

end architecture behav;