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
    variable adr0, adr1, adr2 : integer;
  begin
    if (falling_edge(CLK)) then
      adr0 := to_integer(unsigned(ADDR));
      adr1 := to_integer(unsigned(ADDR(31 downto 1) & '0'));
      adr2 := to_integer(unsigned(ADDR(31 downto 2) & '0' & '0'));
      if (MEMRD = '1') then
        if (MEMLEN = BYTE) then
          DOUT <= x"000000" & sram(adr0);
        elsif (MEMLEN = HWORD) then
          DOUT <= x"0000" & sram(adr1+1) & sram(adr1);
        else
          DOUT <= sram(adr2+3) & sram(adr2+2) & sram(adr2+1) & sram(adr2);
        end if;
      elsif (MEMWR = '1') then
        if (MEMLEN = BYTE) then
          sram(adr0) <= DIN(7 downto 0);
        elsif (MEMLEN = HWORD) then
          sram(adr1) <= DIN(7 downto 0);
          sram(adr1+1) <= DIN(15 downto 0);
        else
          sram(adr2) <= din(7 downto 0);
          sram(adr2+1) <= din(15 downto 8);
          sram(adr2+2) <= din(23 downto 16);
          sram(adr2+3) <= din(31 downto 24);
        end if;
      end if;
    end if;
  end process rw_proc;

end architecture behav;
