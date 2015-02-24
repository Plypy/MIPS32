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
    RW : in RW_TYPE;
    RD_REG1 : in INT5;
    RD_REG2 : in INT5;
    WR_REG : in INT5;
    WR_DATA : in INT32;
    RD_DATA1 : out INT32;
    RD_DATA2 : out INT32
  );
end entity rf;

architecture behav of rf is

  constant REG_NUM : integer := 32;
  type REG_TYPE is array(0 to REG_NUM-1) of INT32;
  signal regs: REG_TYPE;

begin

  process( CLK, RST )
  begin
    if rst = '1' then
      for i in 0 to REG_NUM-1 loop
        regs(i) <= (others => '0');
      end loop;
    elsif rising_edge(clk) then
      if RW = R then
        RD_DATA1 <= regs(to_integer(unsigned(RD_REG1)));
        RD_DATA2 <= regs(to_integer(unsigned(RD_REG2)));
      else
        if WR_REG /= "00000" then
          regs(to_integer(unsigned(WR_REG))) <= WR_DATA;
        end if;
      end if;
    end if;
  end process;

end architecture behav;