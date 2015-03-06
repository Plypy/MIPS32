----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity memory is
  port (
    CLK : in std_logic;
    MEMRD : in std_logic;
    MEMWR : in std_logic;
    MEMLEN : in LEN_TYPE;
    ADDR : in VEC32;
    DIN : in VEC32;
    DOUT : out VEC32
  );
end entity memory;

architecture behav of memory is

  subtype byte_type is VEC8;
  -- type mem is array (0 to 4294967295); -- 2^32-1
  type mem is array (0 to 65535) of byte_type; -- test 16bits address first

  signal sram : mem;

begin

  rw_proc : process( CLK, MEMRD, MEMWR, MEMLEN )
    variable adr : integer;
  begin
    if (falling_edge(CLK)) then
      adr := to_integer(unsigned(ADDR));
      if (MEMRD = '1') then
        if (MEMLEN = BYTE) then
          DOUT <= x"000000" & sram(adr);
        elsif (MEMLEN = HWORD) then
          DOUT <= x"0000" & sram(adr+1) & sram(adr);
        else
          DOUT <= sram(adr+3) & sram(adr+2) & sram(adr+1) & sram(adr);
        end if;
      elsif (MEMWR = '1') then
        if (MEMLEN = BYTE) then
          sram(adr) <= DIN(7 downto 0);
        elsif (MEMLEN = HWORD) then
          sram(adr) <= DIN(7 downto 0);
          sram(adr+1) <= DIN(15 downto 0);
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
