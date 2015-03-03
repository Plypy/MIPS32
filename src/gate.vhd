----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity gate is
  port (
    oe : in std_logic;
    dir : in std_logic;
    north : inout vec32;
    south : inout vec32
  );
end entity gate;

architecture behav of gate is
begin

  process( oe, dir, north, south )
  begin
    if (oe = '0') then
      north <= (others => 'Z');
      south <= (others => 'Z');
    elsif (dir = '0') then
      north <= south;
    elsif (dir = '1') then
      south <= north;
    end if;
  end process;

end architecture behav;