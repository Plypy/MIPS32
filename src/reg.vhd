----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity reg is
  generic ( n : INTEGER);
  port (
    WR : in std_logic;
    OE : in std_logic;
    RST : in std_logic;
    DIN : in std_logic_vector(n-1 downto 0);
    DOUT : out std_logic_vector(n-1 downto 0)
  );
end entity reg;

architecture behav of reg is
begin

  work_proc : process( RST, WR, OE )
    variable data : std_logic_vector(n-1 downto 0);
  begin
    if RST = '1' then
      data := (others => '0');
    elsif (rising_edge(WR)) then
      data := DIN;
    end if;
    if (OE = '1') then
      DOUT <= data;
    else
      DOUT <= (others => 'Z');
    end if;
  end process work_proc;

end architecture behav;
