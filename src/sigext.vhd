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
    sel : in std_logic_vector(1 downto 0);
    dout : out VEC32
  );
end entity sigext;

architecture behav of sigext is
  alias imme : VEC16 is din(15 downto 0);
  alias jump : VEC26 is din()
begin
  ext_proc : process( din, sel )
  begin
    case sel is
    when "00" => --imme zero extend
      dout <= x"0000" & imme;
    when "01" => --imme sign extend
      dout <= std_logic_vector(resize(signed(imme), dout'length));
    when "10" => --imme address extend
      dout <= std_logic_vector(resize(signed(imme & "00"), dout'length));
    when "11" => --jump extend
      dout <= "0000" & din & "00";
    end case;

  end process ext_proc;
  dout <= std_logic_vector(resize(unsigned(din), dout'length)) when (sel = '1') else
    std_logic_vector(resize(signed(din), dout'length));
end architecture behav;
