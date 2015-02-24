----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY iobuf IS
END iobuf;

ARCHITECTURE behavior OF iobuf IS

COMPONENT iobuf
  PORT(
    CLK : IN  std_logic;
    DATA : INOUT  std_logic;
    CTRL : IN  std_logic;
    DATA_FROM_BUS : OUT  std_logic;
    DATA_TO_BUS : IN  std_logic
  );
END COMPONENT;

   --Inputs
  signal CLK : std_logic := '0';
  signal CTRL : std_logic := '0';
  signal DATA_TO_BUS : std_logic := '0';

	--BiDirs
  signal DATA : std_logic;

 	--Outputs
  signal DATA_FROM_BUS : std_logic;

  -- Clock period definitions
  constant CLK_period : time := 10 ns;

  BEGIN

	-- Instantiate the Unit Under Test (UUT)
  uut1: iobuf PORT MAP (
    CLK => CLK,
    DATA => DATA,
    CTRL => CTRL,
    DATA_FROM_BUS => DATA_FROM_BUS,
    DATA_TO_BUS => DATA_TO_BUS
  );

 -- Clock process definitions
  CLK_process: process
  begin
    CLK <= '0';
    wait for CLK_period/2;
    CLK <= '1';
    wait for CLK_period/2;
  end process;


   -- Stimulus process
  stim_proc: process
  begin
    -- hold reset state for 100 ns.
    wait for 100 ns;

    wait for CLK_period*10;

    -- insert stimulus here

    wait;
  end process;

END;
