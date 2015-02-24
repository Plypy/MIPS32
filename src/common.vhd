----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Common is
  type RW_TYPE is (R, W);

  -- alias
  subtype INT5 is std_logic_vector(4 downto 0);
  subtype INT16 is std_logic_vector(31 downto 0);
  subtype INT32 is std_logic_vector(31 downto 0);
end Common;