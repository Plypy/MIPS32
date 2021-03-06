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
    -- signed : in std_logic
  );
end entity memory;

architecture behav of memory is

  subtype byte_type is VEC8;
  -- type mem is array (0 to 4294967295); -- 2^32-1
  type mem is array (0 to 255) of byte_type; -- test 8bits address first

  signal sram : mem := ( -- pesudo rom
  -- test data
  -- start:
  -- addiu r1, r0, 0x1234
    0 => x"34",
    1 => x"12",
    2 => "00000001",
    3 => "00100100",

  -- addiu r2, r0, 0x4321
    4 => x"21",
    5 => x"43",
    6 => "00000010",
    7 => "00100100",

  -- addu r3, r1, r2
    8 => "00100001",
    9 => "00011000",
    10 => "00100010",
    11 => "00000000",

  -- lui r4, 0x6789
    -- 12 => x"89",
    -- 13 => x"67",
    -- 14 => "00000100",
    -- 15 => "00111100",
  -- addiu r4, 0x0004
    12 => x"04",
    13 => x"00",
    14 => "00000100",
    15 => "00100100",

  -- -- JALR r5, r4
  --   16 => "00001001",
  --   17 => "00101000",
  --   18 => "10000000",
  --   19 => "00000000",

    -- SW
    16 => x"ff",
    17 => x"00",
    18 => "00000001",
    19 => "10101100",

    20 => x"ff",
    21 => x"00",
    22 => "00000110",
    23 => "10001100",

  -- bne r1, r2, start
    24 => x"FC",
    25 => x"FF",
    26 => "00100010",
    27 => "00010100",
    others => x"00"
  );

begin

  rw_proc : process( CLK, MEMRD, MEMWR, MEMLEN )
    variable adr0, adr1, adr2 : integer;
  begin
    adr0 := to_integer(unsigned(ADDR));
    adr1 := to_integer(unsigned(ADDR(31 downto 1) & '0'));
    adr2 := to_integer(unsigned(ADDR(31 downto 2) & '0' & '0'));
    if (MEMRD = '1' and MEMWR = '0') then
      if (MEMLEN = BYTE) then
        DOUT <= x"000000" & sram(adr0);
      elsif (MEMLEN = HWORD) then
        DOUT <= x"0000" & sram(adr1+1) & sram(adr1);
      else
        DOUT <= sram(adr2+3) & sram(adr2+2) & sram(adr2+1) & sram(adr2);
      end if;
    elsif (rising_edge(CLK) and MEMRD = '0' and MEMWR = '1') then
      if (MEMLEN = BYTE) then
        sram(adr0) <= DIN(7 downto 0);
      elsif (MEMLEN = HWORD) then
        sram(adr1) <= DIN(7 downto 0);
        sram(adr1+1) <= DIN(15 downto 8);
      else
        sram(adr2) <= din(7 downto 0);
        sram(adr2+1) <= din(15 downto 8);
        sram(adr2+2) <= din(23 downto 16);
        sram(adr2+3) <= din(31 downto 24);
      end if;
    end if;
  end process rw_proc;

end architecture behav;
