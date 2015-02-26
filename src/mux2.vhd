----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity mux2 is
  generic (n : integer);
  port (
    X0 : in std_logic_vector(n-1 downto 0);
    X1 : in std_logic_vector(n-1 downto 0);
    SEL : in std_logic;
    Y : out std_logic_vector(n-1 downto 0)
  );
end entity mux2;

architecture behav of mux2 is
begin
  Y <= X0 when (SEL = '0') else X1;
end architecture behav;