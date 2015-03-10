----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity alu is
  port (
    OP : in ALU_TYPE;
    A : in vec32;
    B : in vec32;
    C : out vec33; --result
    -- flags
    Z : out std_logic
  );
end entity alu;

architecture behav of alu is
  signal C_tmp : vec33 := ("0" & x"00000000");
begin
  C <= C_tmp;
  Z <= '1' when (C_tmp = ("0" & x"00000000")) else '0';

  work_proc : process( OP, A, B )
    variable au : unsigned(31 downto 0);
    variable bu : unsigned(31 downto 0);
  begin
    au := unsigned(A);
    bu := unsigned(B);
    case OP is
      -- add works exactly the same as addu except it will trap on overflow
      when ALU_ADD =>
        C_tmp <= std_logic_vector(resize(au + bu, C_tmp'length));
      when ALU_ADDU =>
        C_tmp <= std_logic_vector(resize(au + bu, C_tmp'length));
      when ALU_SUB => -- likewise
        C_tmp <= std_logic_vector(resize(au - bu, C_tmp'length));
      when ALU_SUBU =>
        C_tmp <= std_logic_vector(resize(au - bu, C_tmp'length));
      when ALU_AND =>
        C_tmp <= '0' & (A and B);
      when ALU_OR =>
        C_tmp <= '0' & (A or B);
      when ALU_XOR =>
        C_tmp <= '0' & (A xor B);
      when ALU_NOR =>
        C_tmp <= '0' & (A nor B);
    end case;
  end process work_proc;
end architecture behav;