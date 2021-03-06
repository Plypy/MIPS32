----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Common is
  type RW_TYPE is (R, W);
  type ALU_TYPE is (ALU_ADD, ALU_ADDU, ALU_SUB, ALU_SUBU,
    ALU_AND, ALU_OR, ALU_XOR, ALU_NOR,
    ALU_SLL, ALU_SRL, ALU_ROTR, ALU_SRA,
    ALU_SLLV, ALU_SRLV, ALU_ROTRV, ALU_SRAV,
    ALU_SLT, ALU_SLTU);
  type LEN_TYPE is (BYTE, HWORD, WORD);
  type STATE_TYPE is (FI0, FI1,
                      DE0, EX0,
                      MA0, MA1, MA2,
                      WB0);
  type INST_TYPE is (R_TYPE, R_JTYPE, R_JLTYPE, I_TYPE, I_BTYPE, I_MTYPE,
                    J_TYPE, JL_TYPE);
  type EXT_TYPE is (SIGN_EXTEND, ZERO_EXTEND, ADDR_EXTEND, UP_EXTEND);

  -- type alias
  subtype VEC2 is std_logic_vector(1 downto 0);
  subtype VEC5 is std_logic_vector(4 downto 0);
  subtype VEC6 is std_logic_vector(5 downto 0);
  subtype VEC8 is std_logic_vector(7 downto 0);
  subtype VEC16 is std_logic_vector(15 downto 0);
  subtype VEC26 is std_logic_vector(25 downto 0);
  subtype VEC28 is std_logic_vector(27 downto 0);
  subtype VEC32 is std_logic_vector(31 downto 0);
  subtype VEC33 is std_logic_vector(32 downto 0);

  --constants
  -- extend mode
  -- constant SIGN_EXTEND : VEC2 := "00";
  -- constant ZERO_EXTEND : VEC2 := "01";
  -- constant ADDR_EXTEND : VEC2 := "10";
  -- constant JUMP_EXTEND : VEC2 := "11";

  -- OPCODE
  constant OP_SPECIAL : VEC6 := "000000";
  constant OP_REGIMM : VEC6 := "000001";
  constant OP_J : VEC6 := "000010";
  constant OP_JAL : VEC6 := "000011";
  constant OP_BEQ : VEC6 := "000100";
  constant OP_BNE : VEC6 := "000101";
  constant OP_BLEZ : VEC6 := "000110";
  constant OP_BGTZ : VEC6 := "000111";

  -- arith
  constant OP_ADDI : VEC6 := "001000";
  constant OP_ADDIU : VEC6 := "001001";
  constant OP_SLTI : VEC6 := "001010";
  constant OP_SLTIU : VEC6 := "001011";
  constant OP_ANDI : VEC6 := "001100";
  constant OP_ORI : VEC6 := "001101";
  constant OP_XORI : VEC6 := "001110";
  constant OP_LUI : VEC6 := "001111";

  -- load
  constant OP_LB : VEC6 := "100000";
  constant OP_LH : VEC6 := "100001";
  constant OP_LWL : VEC6 := "100010";
  constant OP_LW : VEC6 := "100011";
  constant OP_LBU : VEC6 := "100100";
  constant OP_LHU : VEC6 := "100101";
  constant OP_LWR : VEC6 := "100110";

  -- store
  constant OP_SB : VEC6 := "101000";
  constant OP_SH : VEC6 := "101001";
  constant OP_SWL : VEC6 := "101010";
  constant OP_SW : VEC6 := "101011";

  -- These 2 instructions below are not listed in the standard
  constant LLO : VEC6 := "011000";
  constant LHI : VEC6 := "011001";

  -- FUNC field
  constant FUNC_SPC_SLL : VEC6 := "000000";
  -- constant FUNC_SPC_MOVCI : VEC6 := "000001"; -- We don't deal with float
  constant FUNC_SPC_SRL : VEC6 := "000010"; -- furthermore bit21 decides whether to perform ROTR
  constant FUNC_SPC_SRA : VEC6 := "000011";
  constant FUNC_SPC_SLLV : VEC6 := "000100";
  constant FUNC_SPC_SRLV : VEC6 := "000110"; -- furthermore bit6 decides whether to perform ROTR
  constant FUNC_SPC_SRAV : VEC6 := "000111";

  constant FUNC_SPC_JR : VEC6 := "001000";
  constant FUNC_SPC_JALR : VEC6 := "001001";

  constant FUNC_SPC_MULT : VEC6 := "011000";
  constant FUNC_SPC_MULTU : VEC6 := "011001";
  constant FUNC_SPC_DIV : VEC6 := "011010";
  constant FUNC_SPC_DIVU : VEC6 := "011011";

  constant FUNC_SPC_ADD : VEC6 := "100000";
  constant FUNC_SPC_ADDU : VEC6 := "100001";
  constant FUNC_SPC_SUB : VEC6 := "100010";
  constant FUNC_SPC_SUBU : VEC6 := "100011";
  constant FUNC_SPC_AND : VEC6 := "100100";
  constant FUNC_SPC_OR : VEC6 := "100101";
  constant FUNC_SPC_XOR : VEC6 := "100110";
  constant FUNC_SPC_NOR : VEC6 := "100111";

  constant FUNC_SPC_SLT : VEC6 := "101010";
  constant FUNC_SPC_SLTU : VEC6 := "101011";

  function boolean_to_std_logic(cond : boolean) return std_logic;
end Common;

package body Common is
  function boolean_to_std_logic(cond : boolean) return std_logic is
  begin
    if (cond) then
      return ('1');
    else
      return ('0');
    end if;
  end function boolean_to_std_logic;
end package body;