----------------------------------------------------------------------------------
-- Author: Ply_py
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Common.all;

entity cpu is
  port (
    CLK : in std_logic;
    RST : in std_logic;
    DATA : inout std_logic;
    ADR : out std_logic;
    MEMLEN : out LEN_TYPE
  );
end entity cpu;

architecture behav of cpu is

  constant n : integer := 32;

  -- components
  component reg is
    generic ( n : INTEGER);
    port (
      WR : in std_logic;
      OE : in std_logic;
      RST : in std_logic;
      DIN : in std_logic_vector(n-1 downto 0);
      DOUT : out std_logic_vector(n-1 downto 0)
    );
  end component reg;

  component reg0 is
    port (
      WR : in std_logic;
      OE : in std_logic;
      RST : in std_logic;
      DIN : in std_logic;
      DOUT : out std_logic
    );
  end component reg0;

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

  component aluc is
    port (
      INST : in VEC32;
      SHAMT : out VEC5;
      ALUOP : out ALU_TYPE
    );
  end component aluc;

  component alu is
    port (
      OP : in ALU_TYPE;
      A : in VEC32;
      B : in VEC32;
      S : in VEC5;
      C : out VEC33; --result
      -- flags
      Z : out std_logic
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
      din : in VEC26;
      sel : in EXT_TYPE;
      dout : out VEC32
    );
  end component sigext;

  component adder is
    port (
      A : in vec32;
      B : in vec32;
      C : out vec32
    );
  end component adder;

  component gate is
    port (
      oe : in std_logic;
      dir : in std_logic;
      north : inout vec32;
      south : inout vec32
    );
  end component gate;

  component memory is
    port (
      CLK : in std_logic;
      MEMRD : in std_logic;
      MEMWR : in std_logic;
      MEMLEN : in LEN_TYPE;
      ADDR : in VEC32;
      DIN : in VEC32;
      DOUT : out VEC32
    );
  end component memory;

  -- all kinds of signals and aliases
  -- two important buses
  signal bus1 : VEC32;
  signal bus2 : VEC32;

  constant ONE : std_logic := '1';
  constant ZERO : std_logic := '0';
  constant LINK_NUM : VEC5 := "11111";
  constant FOUR : VEC32 := x"00000004";

  -- control signal
  -- pc related stuff
  signal pc_in : VEC32;
  signal pc_out : VEC32;
  signal pc_nxt : VEC32;
  signal pc_four : VEC32;
  signal pc_branch : VEC32;
  signal pc_wr : std_logic;
  signal pc_oe : std_logic;
  signal pc_upper_sel : std_logic;
  signal pc_sel : std_logic;
  signal pc_nxt_oe : std_logic;

  signal ir_wr : std_logic;
  signal ir_data : VEC32;

  --R type things
  alias op_field : VEC6 is ir_data(31 downto 26);
  alias rs_field : VEC5 is ir_data(25 downto 21);
  alias rt_field : VEC5 is ir_data(20 downto 16);
  alias rd_field : VEC5 is ir_data(15 downto 11);
  alias sh_field : VEC5 is ir_data(10 downto 6);
  alias func_field : VEC6 is ir_data(5 downto 0);
  --I type thing
  alias imme_field : VEC16 is ir_data(15 downto 0);
  --J type thing
  alias jump_field : VEC26 is ir_data(25 downto 0);

  signal wreg_sel : std_logic;
  signal link_sel : std_logic;
  signal wreg : VEC5;
  signal wreg_tmp : VEC5;

  signal rf_rw : std_logic;
  signal rf_oe1 : std_logic;
  signal rf_oe2 : std_logic;
  signal rf_data1 : VEC32;
  signal rf_data2 : VEC32;

  signal ext_sel : EXT_TYPE;
  signal ext_res : VEC32;
  signal imme_oe : std_logic;

  signal alu_op : ALU_TYPE;
  signal alu_sh : VEC5;
  signal alu_res : VEC33;
  signal alu_z : std_logic;
  signal alu_z_tmp : std_logic;
  signal alu_wr : std_logic;
  signal alu_oe : std_logic;
  alias alu_sign : std_logic is alu_res(31);
  alias alu_exsign : std_logic is alu_res(32);

  signal goe : std_logic;
  signal gdir : std_logic;

  signal mar_wr : std_logic;
  signal mem_oe : std_logic;
  signal mdr_src : std_logic;
  signal mdr_oe : std_logic;
  signal mdr_wr : std_logic;
  signal mar_data_out : VEC32;
  signal mdr_data_in : VEC32;
  signal mdr_data_out : VEC32;
  signal mem_rd_data : VEC32;

  signal mem_rd : std_logic;
  signal mem_wr : std_logic;
  signal mem_len : LEN_TYPE;

  signal pc_wr_true : std_logic;
  signal ir_wr_true : std_logic;
  signal alu_wr_true : std_logic;
  signal mar_wr_true : std_logic;
  signal mdr_wr_true : std_logic;

begin

  -- pc related stuff
  pc : reg generic map(n => n)
    port map(pc_wr_true, ONE, RST, pc_in, pc_out);
  pc_locker : locker generic map(n => n)
    port map(pc_oe, pc_out, bus1);
  pc_mux_upper : mux2 generic map(n => 4)
    port map(bus2(31 downto 28), pc_out(31 downto 28), pc_upper_sel, pc_in(31 downto 28));
  pc_in(27 downto 0) <= bus2(27 downto 0);
  add4 : adder port map(pc_out, FOUR, pc_four);
  add_imme : adder port map(pc_four, ext_res, pc_branch);
  pc_mux : mux2 generic map(n => n)
    port map(pc_four, pc_branch, pc_sel, pc_nxt);
  pc_nxt_locker : locker generic map(n => n)
    port map(pc_nxt_oe, pc_nxt, bus2);

  -- alu, aluc and its register
  aluc0 : aluc port map(ir_data, alu_sh, alu_op);
  alu0 : alu port map(alu_op, bus1, bus2, alu_sh, alu_res, alu_z_tmp);
  alu_reg : reg generic map(n => n)
    port map(alu_wr_true, alu_oe, RST, alu_res(n-1 downto 0), bus2);
  aluz_reg : reg0 port map(alu_wr_true, ONE, RST, alu_z_tmp, alu_z);

  ir : reg generic map(n => n)
    port map(ir_wr_true, ONE, RST, bus1, ir_data);

  -- rf and its tristate locks
  wr_mux0 : mux2 generic map(n => 5)
    port map(rt_field, rd_field, wreg_sel, wreg_tmp);
  wr_mux1 : mux2 generic map(n => 5)--special mux for link
    port map(wreg_tmp, LINK_NUM, link_sel, wreg);
  regfiles : rf port map(CLK, RST, rf_rw,
    rs_field, rt_field, wreg, bus2, rf_data1, rf_data2);
  rf_lock1 : locker generic map(n => n)
    port map(rf_oe1, rf_data1, bus1);
  rf_lock2 : locker generic map(n => n)
    port map(rf_oe2, rf_data2, bus2);

  -- sign extend
  sigext0 : sigext port map(jump_field, ext_sel, ext_res);
  ext_lock : locker generic map(n => n)
    port map(imme_oe, ext_res, bus2);

  -- memory stuff
  mem: memory port map(CLK, mem_rd, mem_wr, mem_len,
                      mar_data_out, mdr_data_out, mem_rd_data);
  mdr_mux : mux2 generic map(n => n)
    port map(bus1, mem_rd_data, mdr_src, mdr_data_in);
  mdr : reg generic map(n => n)
    port map(mdr_wr_true, ONE, RST, mdr_data_in, mdr_data_out);
  mar : reg generic map(n => n)
    port map(mar_wr_true, ONE, RST, bus2, mar_data_out);
  mem_rd_locker : locker generic map(n => n)
    port map(mem_oe, mem_rd_data, bus1);
  mem_wr_locker : locker generic map(n=> n)
    port map(mdr_oe, mdr_data_out, bus1);

  g0 : gate port map(goe, gdir, bus1, bus2);

  -- pulse control signal
  pc_wr_true <= CLK and pc_wr;
  ir_wr_true <= CLK and ir_wr;
  alu_wr_true <= CLK and alu_wr;
  mar_wr_true <= CLK and mar_wr;
  mdr_wr_true <=  CLK and mdr_wr;

  control_proc : process( rst, clk )
    variable state : STATE_TYPE := FI0;
    variable ir_type : INST_TYPE := R_TYPE;
  begin
    if rst = '1' then
      state := FI0;
      pc_oe <= '0';
      pc_nxt_oe <= '0';
      alu_oe <= '0';
      rf_oe1 <= '0';
      rf_oe2 <= '0';
      imme_oe <= '0';
      goe <= '0';
      mem_oe <= '0';
      mdr_oe <= '0';

    elsif (falling_edge(clk)) then
      if state = FI0 then
        pc_oe <= '1';
        pc_wr <= '0';
        pc_upper_sel <= '0';
        pc_sel <= '0';
        pc_nxt_oe <= '0';

        alu_oe <= '0';
        alu_wr <= '0';

        ir_wr <= '0';
        wreg_sel <= '0';
        link_sel <= '0';
        ext_sel <= ZERO_EXTEND;
        imme_oe <= '0';

        rf_rw <= '0';
        rf_oe1 <= '0';
        rf_oe2 <= '0';

        goe <= '1';
        gdir <= '1';

        mem_oe <= '0';
        mdr_src <= '0';
        mdr_oe <= '0';
        mdr_wr <= '0';
        mar_wr <= '1';
        mem_rd <= '0';
        mem_wr <= '0';
        mem_len <= WORD;
        state := FI1;
      elsif state = FI1 then
        pc_oe <= '0';
        pc_wr <= '0';
        pc_upper_sel <= '0';
        pc_sel <= '0';
        pc_nxt_oe <= '0';

        alu_oe <= '0';
        alu_wr <= '0';

        ir_wr <= '1';
        wreg_sel <= '0';
        link_sel <= '0';
        ext_sel <= ZERO_EXTEND;
        imme_oe <= '0';

        rf_rw <= '0';
        rf_oe1 <= '0';
        rf_oe2 <= '0';

        goe <= '0';
        gdir <= '0';

        mem_oe <= '1';
        mdr_src <= '0';
        mdr_oe <= '0';
        mdr_wr <= '0';
        mar_wr <= '0';
        mem_rd <= '1';
        mem_wr <= '0';
        mem_len <= WORD;

        state := DE0;
      elsif state = DE0 then
        if op_field = OP_SPECIAL then
          ir_type := R_TYPE;
        elsif op_field = OP_J or op_field = OP_JAL then
          ir_type := J_TYPE;
        elsif (op_field(5 downto 2) = "0001") then-- branches
          ir_type := I_BTYPE;
        else
          ir_type := I_TYPE;
        end if;
        pc_oe <= '0';
        pc_wr <= '0';
        pc_upper_sel <= '0';
        pc_nxt_oe <= '0';
        pc_sel <= '0';

        alu_oe <= '0';
        alu_wr <= '1';

        ir_wr <= '0';
        wreg_sel <= '0';
        link_sel <= '0';
        if (ir_type = J_TYPE) then
          ext_sel <= JUMP_EXTEND;
        elsif (ir_type = I_BTYPE) then
          ext_sel <= ADDR_EXTEND;
        elsif (ir_type = I_TYPE) then
          if (op_field(2) = '0') then -- add, slt
            ext_sel <= SIGN_EXTEND;
          elsif (op_field(2 downto 0) = "111") then -- lui
            ext_sel <= UP_EXTEND;
          else
            ext_sel <= ZERO_EXTEND;
          end if;
        end if;
        if (ir_type = R_TYPE or ir_type = I_BTYPE) then
          imme_oe <= '0';
        else
          imme_oe <= '1';
        end if;

        rf_rw <= '0';
        if (ir_type = R_TYPE or ir_type = I_BTYPE) then
          rf_oe1 <= '1';
          rf_oe2 <= '1';
        elsif (ir_type = I_TYPE) then
          rf_oe1 <= '1';
          rf_oe2 <= '0';
        else
          rf_oe1 <= '0';
          rf_oe2 <= '0';
        end if;

        goe <= '0';
        gdir <= '0';

        mem_oe <= '0';
        mdr_src <= '0';
        mdr_oe <= '0';
        mdr_wr <= '0';
        mar_wr <= '0';
        mem_rd <= '0';
        mem_wr <= '0';
        mem_len <= WORD;
        state := EX0;
      elsif state = EX0 then -- nxt pc
        pc_oe <= '0';
        pc_wr <= '1';
        pc_upper_sel <= '0';
        pc_nxt_oe <= '1';
        if (ir_type = I_BTYPE) then
          if (op_field = OP_BNE) then
            pc_sel <= not alu_z;
          elsif (op_field = OP_BEQ) then
            pc_sel <= alu_z;
          elsif (op_field = OP_BLEZ) then
            pc_sel <= alu_z or alu_sign;
          elsif (op_field = OP_BGTZ) then
            pc_sel <= not (alu_z or alu_sign);
          else
            pc_sel <= '0';
          end if;
        else
          pc_sel <= '0';
        end if;

        alu_oe <= '0';
        alu_wr <= '0';

        ir_wr <= '0';
        wreg_sel <= '0';
        link_sel <= '0';
        ext_sel <= ADDR_EXTEND;
        imme_oe <= '0';

        rf_rw <= '0';
        rf_oe1 <= '0';
        rf_oe2 <= '0';

        goe <= '0';
        gdir <= '0';

        mem_oe <= '0';
        mdr_src <= '0';
        mdr_oe <= '0';
        mdr_wr <= '0';
        mar_wr <= '0';
        mem_rd <= '0';
        mem_wr <= '0';
        mem_len <= WORD;
        if (ir_type = I_BTYPE) then
          state := FI0;
        else
          state := WB0;
        end if;
      elsif (state = WB0) then
        pc_oe <= '0';
        pc_wr <= '0';
        pc_upper_sel <= '0';
        pc_nxt_oe <= '0';
        pc_sel <= '0';

        alu_oe <= '1';
        alu_wr <= '0';

        ir_wr <= '0';
        if (ir_type = R_TYPE) then
          wreg_sel <= '1';
        else
          wreg_sel <= '0';
        end if;
        link_sel <= '0';
        ext_sel <= ZERO_EXTEND;
        imme_oe <= '0';

        rf_rw <= '1';
        rf_oe1 <= '0';
        rf_oe2 <= '0';

        goe <= '0';
        gdir <= '0';

        mem_oe <= '0';
        mdr_src <= '0';
        mdr_oe <= '0';
        mdr_wr <= '0';
        mar_wr <= '0';
        mem_rd <= '0';
        mem_wr <= '0';
        mem_len <= WORD;
        state := FI0;
      end if;
    end if;

  end process control_proc;

end architecture behav;