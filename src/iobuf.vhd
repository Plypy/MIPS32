----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Common.all;

entity iobuf is
  port (
    CLK  : in std_logic;
    DATA : inout std_logic;
    RW : in RW_TYPE;
    DATA_FROM_BUS : out std_logic;
    DATA_TO_BUS : in std_logic
  );
end entity iobuf;

architecture behav of iobuf is

  signal data_in : std_logic;
  signal data_out : std_logic;

begin

  input : process( CLK )
  begin
    if (falling_edge(CLK)) then
      DATA_FROM_BUS <= data_in;
    end if;
  end process input;

  output : process( CLK )
  begin
    if (rising_edge(CLK)) then
      data_out <= DATA_TO_BUS;
    end if;
  end process output;

  deliver : process( RW, DATA )
  begin
    if (RW = R) then
      DATA <= 'Z';
    else
      DATA <= data_out;
    end if;
    data_in <= DATA;
  end process deliver;

end architecture behav;