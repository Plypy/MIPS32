----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity locker is
  generic (n : integer);
  port (
    OE : in std_logic;
    DIN : in std_logic_vector(n-1 downto 0);
    DOUT : out std_logic_vector(n-1 downto 0)
  );
end entity locker;

architecture behav of locker is
begin
  work_proc : process( OE, DIN )
  begin
    if (OE = '1') then
      DOUT <= DIN;
    else
      DOUT <= (others => 'Z');
    end if;
  end process work_proc;
end architecture behav;
