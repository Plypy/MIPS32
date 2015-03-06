----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity gate is
  port (
    OE : in std_logic;
    DIR : in std_logic;
    NORTH : inout vec32;
    SOUTH : inout vec32
  );
end entity gate;

architecture behav of gate is
begin

  process( OE, DIR, NORTH, SOUTH )
  begin
    if (OE = '0') then
      NORTH <= (others => 'Z');
      SOUTH <= (others => 'Z');
    elsif (DIR = '0') then
      NORTH <= SOUTH;
    elsif (DIR = '1') then
      SOUTH <= NORTH;
    end if;
  end process;

end architecture behav;