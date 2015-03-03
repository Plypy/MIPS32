----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity memory is
  port (
    clk : in std_logic;
    memrd : in std_logic;
    memwr : in std_logic;
    addr : in vec32;
    din : in vec32;
    dout : out vec32
  );
end entity memory;

architecture behav of memory is

  subtype byte is VEC8;
  -- type mem is array (0 to 4294967295); -- 2^32-1
  type mem is array (0 to 65535); -- test 16bits address first

  signal sram : mem;

begin

  rw_proc : process( clk, memrd, memwr )
    variable adr : integer;
  begin
    if (falling_edge(clk)) then
      adr := to_integer(unsigned(addr));
      if (memrd = '1') then
        dout <= sram(adr);
      elsif (memwr = '1') then
        sram(adr) <= din;
      end if;
    end if;
  end process rw_proc;

end architecture behav;
