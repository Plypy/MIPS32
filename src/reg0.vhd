----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity reg0 is
  port (
    WR : in std_logic;
    OE : in std_logic;
    RST : in std_logic;
    DIN : in std_logic;
    DOUT : out std_logic
  );
end entity reg0;

architecture behav of reg0 is
begin

  work_proc : process( RST, WR, OE )
    variable data : std_logic;
  begin
    if RST = '1' then
      data := '0';
    elsif (rising_edge(WR)) then
      data := DIN;
    end if;
    if (OE = '1') then
      DOUT <= data;
    else
      DOUT <= 'Z';
    end if;
  end process work_proc;

end architecture behav;
