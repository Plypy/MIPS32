----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity reg_bus_test is
end entity reg_bus_test;

architecture behavior of reg_bus_test is
  constant n : integer := 32;

  component reg is
    generic(n: integer);
    port(
      WR : in  std_logic;
      OE : in  std_logic;
      DIN : in  std_logic_vector(n-1 downto 0);
      DOUT : out  std_logic_vector(n-1 downto 0)
    );
  end component reg;

  signal wr1 : std_logic := '0';
  signal wr2 : std_logic := '0';
  signal oe1 : std_logic := '1';
  signal oe2 : std_logic := '1';

  signal data_bus : std_logic_vector(n-1 downto 0);
  signal data_in : std_logic_vector(n-1 downto 0);
  signal data_out : std_logic_vector(n-1 downto 0);

  signal clock : std_logic;
  constant clock_period : time := 10 ns;

  signal tmp : std_logic := '0';

begin

  uut1: reg generic map (n => n)
    port map(wr1, oe1, data_in, data_bus);

  uut2: reg generic map (n => n)
    port map(wr2, oe2, data_bus, data_out);

  clock_process :process
  begin
    clock <= '0';
    wait for clock_period/2;
    clock <= '1';
    wait for clock_period/2;
  end process;


  -- Stimulus process
wr2 <= clock and tmp;

  stim_proc: process
  begin
    wait for 10*clock_period;
    wr1 <= '0';
    wait for 10*clock_period;
    data_in <= x"3f3f3f3f";
    wr1 <= '1';
    wait for clock_period;
    tmp <= '1';
    -- oe1 <= '1';
    wait for clock_period;
    assert data_out = x"3f3f3f3f"
      report "wrong value";
    -- oe2 <= '1';
    wr1 <= '0';
    data_in <= x"00000000";
    wait for clock_period;
    wr1 <= '1';
    wait for clock_period;
    assert data_out = x"00000000"
      report "wrong value";

    wait;
  end process;

end architecture behavior;
