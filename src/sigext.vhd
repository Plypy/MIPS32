----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity sigext is
  port (
    DIN : in VEC26;
    SEL : in VEC2;
    DOUT : out VEC32
  );
end entity sigext;

architecture behav of sigext is
  alias imme : VEC16 is DIN(15 downto 0);
  alias jump : VEC26 is DIN(25 downto 0);
begin
  ext_proc : process( DIN, SEL )
  begin
    case SEL is
    when ZERO_EXTEND => --imme zero extend
      DOUT <= x"0000" & imme;
    when SIGN_EXTEND => --imme sign extend
      DOUT <= std_logic_vector(resize(signed(imme), DOUT'length));
    when ADDR_EXTEND => --imme address extend
      DOUT <= std_logic_vector(resize(signed(imme & "00"), DOUT'length));
    when JUMP_EXTEND => --jump extend
      DOUT <= "0000" & jump & "00";
    when others => -- shouldn't happen
      DOUT <= (others => 'Z');
    end case;

  end process ext_proc;
end architecture behav;
