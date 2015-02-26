----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity sigext is
  port (
    din : in VEC16;
    sel : in std_logic;
    dout : out VEC32
  );
end entity sigext;

architecture behav of sigext is

begin
  dout <= std_logic_vector(resize(unsigned(din), dout'length)) when (sel = '1') else
    std_logic_vector(resize(signed(din), dout'length));
end architecture behav;
