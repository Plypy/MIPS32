----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity adder is
  port (
    A : in vec32;
    B : in vec32;
    C : out vec32
  );
end entity adder;

architecture behav of adder is
begin
  C <= std_logic_vector(signed(A)+signed(B));
end architecture behav;