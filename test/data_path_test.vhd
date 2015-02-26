----------------------------------------------------------------------------------
-- Author: Ply_py
-- Description: Experiment simple datapaths
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity data_path_test is
end entity data_path_test;

architecture behav of data_path_test is

  constant n : integer := 32;

  component reg is
    generic ( n : INTEGER);
    port (
      WR : in std_logic;
      OE : in std_logic;
      DIN : in std_logic_vector(n-1 downto 0);
      DOUT : out std_logic_vector(n-1 downto 0)
    );
  end component reg;

  component aluc is
    port (
      INST : in VEC32;
      ALUOP : out ALU_TYPE
    );
  end component aluc;

  component rf is
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
  end component rf;

  component alu is
    port (
      OP : in ALU_TYPE;
      A : in VEC32;
      B : in VEC32;
      C : out VEC32; --result
      D : out VEC32; --extended result
      -- flags
      Z : out std_logic;
      O : out std_logic
    );
  end component alu;

  component locker is
    generic (n : integer);
    port (
      oe : in std_logic;
      din : in std_logic_vector(n-1 downto 0);
      dout : out std_logic_vector(n-1 downto 0)
    );
  end component locker;

  component mux2 is
    generic (n : integer);
    port (
      X0 : in std_logic_vector(n-1 downto 0);
      X1 : in std_logic_vector(n-1 downto 0);
      SEL : in std_logic;
      Y : out std_logic_vector(n-1 downto 0)
    );
  end component mux2;

  component sigext is
    port (
      din : in VEC16;
      sel : in std_logic;
      dout : out VEC32
    );
  end component sigext;

  signal bus1 : VEC32;
  signal bus2 : VEC32;

  constant ONE : std_logic := '1';
  constant ZERO : std_logic := '0';

  constant clock_period : time := 10ns;
  signal clock : std_logic;

  -- control signal
  signal pc_input : VEC32;
  signal rst_input : std_logic := '0';

  signal pc_wr : std_logic;
  signal pc_oe : std_logic;

  signal ir_wr : std_logic;
  signal ir_data : VEC32;

  --R type
  alias op_field : VEC6 is ir_data(31 downto 26);
  alias rs_field : VEC5 is ir_data(25 downto 21);
  alias rt_field : VEC5 is ir_data(20 downto 16);
  alias rd_field : VEC5 is ir_data(15 downto 11);
  alias sh_field : VEC5 is ir_data(10 downto 6);
  alias func_field : VEC6 is ir_data(5 downto 0);
  --I type
  alias imme_field : VEC16 is ir_data(15 downto 0);
  --J type
  alias address_field : VEC26 is ir_data(25 downto 0);

  signal wreg_sel : std_logic;
  signal wreg : VEC5;

  signal rf_rw : std_logic;
  signal rf_oe1 : std_logic;
  signal rf_oe2 : std_logic;
  signal rf_data1 : VEC32;
  signal rf_data2 : VEC32;

  signal sigsel : std_logic;
  signal ext_res : VEC32;
  signal imme_oe : std_logic;

  signal alu_op : ALU_TYPE;
  signal alu_res : VEC32;
  signal alu_ext : VEC32;
  signal alu_z : std_logic;
  signal alu_o : std_logic;
  signal alu_wr : std_logic;
  signal alu_oe : std_logic;

  signal pc_wr_true : std_logic;
  signal ir_wr_true : std_logic;
  signal alu_wr_true : std_logic;

begin


  -- pulse control signal
  pc_wr_true <= clock and pc_wr;
  ir_wr_true <= clock and ir_wr;
  alu_wr_true <= clock and alu_wr;
  sigsel <= op_field(0);

  clock_proc : process
  begin
    clock <= '0';
    wait for 0.5*clock_period;
    clock <= '1';
    wait for 0.5*clock_period;
  end process clock_proc;

  pc : reg generic map(n => n)
    port map(pc_wr_true, pc_oe, pc_input, bus1);

  ir : reg generic map(n => n)
    port map(ir_wr_true, ONE, bus1, ir_data);

  -- rf and its tristate locks
  wr_selector : mux2 generic map(n => 5)
    port map(rt_field, rd_field, wreg_sel, wreg);
  regfiles : rf port map(clock, rst_input, rf_rw,
    rs_field, rt_field, wreg, bus2, rf_data1, rf_data2);
  rf_lock1 : locker generic map(n => n)
    port map(rf_oe1, rf_data1, bus1);
  rf_lock2 : locker generic map(n => n)
    port map(rf_oe2, rf_data2, bus2);

  -- sign extend
  sigext0 : sigext port map(imme_field, sigsel, ext_res);
  ext_lock : locker generic map(n => n)
    port map(imme_oe, ext_res, bus2);

  -- alu, aluc and its register
  aluc0 : aluc port map(ir_data, alu_op);
  alu0 : alu port map(alu_op, bus1, bus2, alu_res, alu_ext, alu_z, alu_o);
  alu_reg : reg generic map(n => n)
    port map(alu_wr_true, alu_oe, alu_res, bus2);

  stim_proc : process
    procedure FI is
    begin
      pc_wr <= '0';
      pc_oe <= '1';
      ir_wr <= '1';
      wreg_sel <= '0';
      rf_rw <= '0';
      rf_oe1 <= '0';
      rf_oe2 <= '0';
      -- sigsel <= '0';
      imme_oe <= '0';
      alu_wr <= '0';
      alu_oe <= '0';
    end procedure;

    procedure EXI_0 is
    begin
      pc_wr <= '0';
      pc_oe <= '0';
      ir_wr <= '0';
      wreg_sel <= '0';
      rf_rw <= '0';
      rf_oe1 <= '1';
      rf_oe2 <= '0';
      -- sigsel <= '0';
      imme_oe <= '1';
      alu_wr <= '1';
      alu_oe <= '0';
    end procedure;

    procedure EXI_1 is
    begin
      pc_wr <= '0';
      pc_oe <= '0';
      ir_wr <= '0';
      wreg_sel <= '0';
      rf_rw <= '1';
      rf_oe1 <= '0';
      rf_oe2 <= '0';
      -- sigsel <= '0';
      imme_oe <= '0';
      alu_wr <= '0';
      alu_oe <= '1';
    end procedure;
  begin
    wait for 10*clock_period;
    pc_input <= OP_ADDIU & "00000" & "00001" & x"2222";
    pc_wr <= '1';
    wait for clock_period;
    FI;
    wait for clock_period;
    EXI_0;
    wait for clock_period;
    EXI_1;
    wait for clock_period;
    pc_input <= OP_ADDIU & "00000" & "00010" & x"3333";
    pc_wr <= '1';
    wait for clock_period;
    FI;
    wait for clock_period;
    EXI_0;
    wait for clock_period;
    EXI_1;
    wait for clock_period;

    wait;
  end process stim_proc;

end architecture behav;