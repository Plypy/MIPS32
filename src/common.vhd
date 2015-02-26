----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Common is
  type RW_TYPE is (R, W);
  type ALU_TYPE is (ALU_ADD, ALU_ADDU);

  -- type alias
  subtype VEC5 is std_logic_vector(4 downto 0);
  subtype VEC6 is std_logic_vector(5 downto 0);
  subtype VEC16 is std_logic_vector(15 downto 0);
  subtype VEC26 is std_logic_vector(25 downto 0);
  subtype VEC32 is std_logic_vector(31 downto 0);

  --constants
  -- OPCODE
  constant OP_SPECIAL : VEC6 := "000000";
  constant OP_REGIMM : VEC6 := "000001";

  constant OP_ADDI : VEC6 := "001000";
  constant OP_ADDIU : VEC6 := "001001";
  constant OP_SLTI : VEC6 := "001010";
  constant OP_SLTIU : VEC6 := "001011";
  constant OP_ANDI : VEC6 := "001100";
  constant OP_ORI : VEC6 := "001101";
  constant OP_XORI : VEC6 := "001110";
  constant OP_LUI : VEC6 := "001111";

  -- FUNC field
  constant FUNC_SPC_MULT : VEC6 := "011000";

  constant FUNC_SPC_ADD : VEC6 := "100000";
  constant FUNC_SPC_ADDU : VEC6 := "100001";
  constant FUNC_SPC_SUB : VEC6 := "100010";
  constant FUNC_SPC_SUBU : VEC6 := "100011";
  constant FUNC_SPC_AND : VEC6 := "100100";
  constant FUNC_SPC_OR : VEC6 := "100101";
  constant FUNC_SPC_XOR : VEC6 := "100110";
  constant FUNC_SPC_NOR : VEC6 := "100111";
end Common;