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
    memlen : in LEN_TYPE;
    addr : in vec32;
    din : in vec32;
    dout : out vec32
  );
end entity memory;

architecture behav of memory is

  subtype byte_type is VEC8;
  -- type mem is array (0 to 4294967295); -- 2^32-1
  type mem is array (0 to 65535) of byte_type; -- test 16bits address first

  signal sram : mem;

begin

  rw_proc : process( clk, memrd, memwr, memlen )
    variable adr : integer;
  begin
    if (falling_edge(clk)) then
      adr := to_integer(unsigned(addr));
      if (memrd = '1') then
        if (memlen = BYTE) then
          dout <= x"000000" & sram(adr);
        elsif (memlen = HWORD) then
          dout <= x"0000" & sram(adr+1) & sram(adr);
        else
          dout <= sram(adr+3) & sram(adr+2) & sram(adr+1) & sram(adr);
        end if;
      elsif (memwr = '1') then
        if (memlen = BYTE) then
          sram(adr) <= din(7 downto 0);
        elsif (memlen = HWORD) then
          sram(adr) <= din(7 downto 0);
          sram(adr+1) <= din(15 downto 0);
        else
          sram(adr) <= din(7 downto 0);
          sram(adr+1) <= din(15 downto 8);
          sram(adr+2) <= din(23 downto 16);
          sram(adr+3) <= din(31 downto 24);
        end if;
      end if;
    end if;
  end process rw_proc;

end architecture behav;
