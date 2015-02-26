----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity alu is
  port (
    OP : in ALU_TYPE;
    A : in vec32;
    B : in vec32;
    C : out vec32; --result
    D : out vec32; --extended result
    -- flags
    Z : out std_logic;
    O : out std_logic
  );
end entity alu;

architecture behav of alu is

begin
  work_proc : process( OP, A, B )
    variable as : signed(31 downto 0);
    variable bs : signed(31 downto 0);
    variable au : unsigned(31 downto 0);
    variable bu : unsigned(31 downto 0);
  begin
    as := signed(A);
    bs := signed(B);
    au := unsigned(A);
    bu := unsigned(B);
    case OP is
      when ALU_ADD =>
        C <= std_logic_vector(as + bs);
      when ALU_ADDU =>
        C <= std_logic_vector(au + bu);
    end case;
  end process work_proc;
end architecture behav;