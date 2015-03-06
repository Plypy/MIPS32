----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity rf is
  port (
    CLK : in std_logic;
    RST : in std_logic;
    RW : in std_logic;
    RD_REG1 : in VEC5;
    RD_REG2 : in VEC5;
    WR_REG : in VEC5;
    WR_DATA : in VEC32;
    RD_DATA1 : out VEC32;
    RD_DATA2 : out VEC32
  );
end entity rf;

architecture behav of rf is

  constant REG_NUM : integer := 32;
  type REG_TYPE is array(1 to REG_NUM-1) of VEC32;
  signal regs: REG_TYPE;

begin

  process( CLK, RST )
    variable rd1 : integer;
    variable rd2 : integer;
  begin
    if RST = '1' then
      for i in 1 to REG_NUM-1 loop
        regs(i) <= (others => '0');
      end loop;
    elsif rising_edge(CLK) and RW = '1' then -- write later
      if WR_REG /= "00000" then -- REG0 is hardwired to zero
        regs(to_integer(unsigned(WR_REG))) <= WR_DATA;
      end if;
    elsif falling_edge(CLK) and RW = '0' then -- output earlier
      rd1 := to_integer(unsigned(RD_REG1));
      rd2 := to_integer(unsigned(RD_REG2));
      if rd1 = 0 then
        RD_DATA1 <= (others => '0');
      else
        RD_DATA1 <= regs(rd1);
      end if;
      if rd2 = 0 then
        RD_DATA2 <= (others => '0');
      else
        RD_DATA2 <= regs(rd2);
      end if;
    end if;
  end process;

end architecture behav;