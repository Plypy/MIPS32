----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity sigext is
  port (
    din : in VEC26;
    sel : in VEC2;
    dout : out VEC32
  );
end entity sigext;

architecture behav of sigext is
  alias imme : VEC16 is din(15 downto 0);
  alias jump : VEC26 is din(25 downto 0);
begin
  ext_proc : process( din, sel )
  begin
    case sel is
    when ZERO_EXTEND => --imme zero extend
      dout <= x"0000" & imme;
    when SIGN_EXTEND => --imme sign extend
      dout <= std_logic_vector(resize(signed(imme), dout'length));
    when ADDR_EXTEND => --imme address extend
      dout <= std_logic_vector(resize(signed(imme & "00"), dout'length));
    when JUMP_EXTEND => --jump extend
      dout <= "0000" & jump & "00";
    end case;

  end process ext_proc;
end architecture behav;
