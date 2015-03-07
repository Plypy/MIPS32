----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity cpu_test is
end entity cpu_test;

architecture behav of cpu_test is

  component cpu is
    port (
      CLK : in std_logic;
      RST : in std_logic;
      DATA : inout std_logic;
      ADR : out std_logic;
      MEMLEN : out LEN_TYPE
    );
  end component cpu;

  signal clock : std_logic := '0';
  constant clock_period : time := 10ns;

  signal rst : std_logic := '0';

begin

  uut : cpu port map(clock, rst);

  clock_proc : process
  begin
    clock <= '0';
    wait for 0.5*clock_period;
    clock <= '1';
    wait for 0.5*clock_period;
  end process clock_proc;

  stim_proc : process
  begin
    rst <= '1';
    wait for 9.5*clock_period;
    rst <= '0';
    wait;
  end process stim_proc;

end architecture behav;