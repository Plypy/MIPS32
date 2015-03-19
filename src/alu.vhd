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
    A : in VEC32;
    B : in VEC32;
    S : in VEC5;
    C : out VEC33; --result
    -- flags
    Z : out std_logic
  );
end entity alu;

architecture behav of alu is
  signal C_tmp : VEC33 := ("0" & x"00000000");
begin
  C <= C_tmp;
  Z <= '1' when (C_tmp = ("0" & x"00000000")) else '0';

  work_proc : process( OP, A, B )
    variable as : signed(31 downto 0);
    variable bs : signed(31 downto 0);
    variable au : unsigned(31 downto 0);
    variable bu : unsigned(31 downto 0);
    variable shift : integer;
    variable shiftv : integer;
  begin
    as := signed(A);
    bs := signed(B);
    au := unsigned(A);
    bu := unsigned(B);
    shift := to_integer(unsigned(S));
    shiftv := to_integer(unsigned(au(4 downto 0)));
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

      -- shifts
      when ALU_SLL =>
        C_tmp <= '0' & std_logic_vector(shift_left(bu, shift));
      when ALU_SRL =>
        C_tmp <= '0' & std_logic_vector(shift_right(bu, shift));
      when ALU_ROTR =>
        C_tmp <= '0' & std_logic_vector(bu ror shift);
      when ALU_SRA =>
        C_tmp <= '0' & std_logic_vector(shift_right(bs, shift));
      when ALU_SLLV =>
        C_tmp <= '0' & std_logic_vector(shift_left(bu, shiftv));
      when ALU_SRLV =>
        C_tmp <= '0' & std_logic_vector(shift_right(bu, shiftv));
      when ALU_ROTRV =>
        C_tmp <= '0' & std_logic_vector(bu ror shiftv);
      when ALU_SRAV =>
        C_tmp <= '0' & std_logic_vector(shift_right(bs, shiftv));

      when ALU_SLT =>
        C_tmp <= x"00000000" & boolean_to_std_logic(as < bs);
      when ALU_SLTU =>
        C_tmp <= x"00000000" & boolean_to_std_logic(au < bu);
    end case;
  end process work_proc;
end architecture behav;