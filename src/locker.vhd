----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity locker is
  generic (n : integer);
  port (
    oe : in std_logic;
    din : in std_logic_vector(n-1 downto 0);
    dout : out std_logic_vector(n-1 downto 0)
  );
end entity locker;

architecture behav of locker is
begin
  dout <= din when (oe = '1') else (others => 'Z');
end architecture behav;
