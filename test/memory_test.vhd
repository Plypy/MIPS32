----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity memory_test is
end entity memory_test;

architecture behav of memory_test is

  component memory is
    port (
      clk : in std_logic;
      memrd : in std_logic;
      memwr : in std_logic;
      memlen : in LEN_TYPE;
      addr : in VEC32;
      din : in VEC32;
      dout : out VEC32
    );
  end component memory;

  constant clk_period : time := 10ns;

  signal clk : std_logic := '0';
  signal memrd : std_logic := '0';
  signal memwr : std_logic := '0';
  signal memlen : LEN_TYPE := BYTE;
  signal addr : VEC32 := (others => '0');
  signal din : VEC32 := (others => '0');
  signal dout : VEC32 := (others => '0');

begin

  uut : memory port map(clk, memrd, memwr, memlen, addr, din, dout);

  clk_proc : process
  begin
    clk <= '0';
    wait for 0.5*clk_period;
    clk <= '1';
    wait for 0.5*clk_period;
  end process clk_proc;

  stim_proc : process
  begin
    wait for 9.5*clk_period;
    -- addr <= x"00000000";
    -- memwr <= '1';
    -- memlen <= BYTE;
    -- din <= x"00000000";
    -- wait for clk_period;
    -- addr <= x"00000001";
    -- din <= x"00000001";
    -- wait for clk_period;
    -- addr <= x"00000002";
    -- memlen <= HWORD;
    -- din <= x"00000100";
    -- wait for clk_period;
    -- addr <= x"00000004";
    -- memlen <= WORD;
    -- din <= x"01000101";

    -- wait for clk_period;
    -- memwr <= '0';
    -- wait for clk_period;

    memrd <= '1';
    memlen <= BYTE;
    addr <= x"00000000";
    wait for clk_period;
    memlen <= HWORD;
    wait for clk_period;
    memlen <= WORD;
    wait for clk_period;
    addr <= x"00000004";

    wait;

  end process stim_proc;

end architecture behav;