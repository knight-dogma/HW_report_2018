library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.types.all;

entity whole is
  port (
    clk : in std_logic := '0';
    clk_count : out std_logic_vector(31 downto 0) := (others => '0');
    top4 : out sets4_t := (others => ((others => '0'), (others => '0'), (others => '0')));
    alldone : out std_logic := '0'
  );
end whole;

architecture whole_body of whole is
  component sorter is
    port(
      clk   : in std_logic;
      set   : in set_t;
      top4  : out sets4_t
    );
  end component;

  component collatz is
    port(
      CLK : in std_logic;
      RESET : in std_logic;
      START : in std_logic_vector(9 downto 0);
      DATA : in data_t;
      PEAK : out std_logic_vector(17 downto 0);
      LEN : out std_logic_vector(7 downto 0);
      FIN : out std_logic;
      ADDR : out std_logic_vector(8 downto 0));
  end component;

  component RAM is
  port(
    addr : in std_logic_vector(8 downto 0);
    data_in : in data_t;
    write : in std_logic;
    clk : in std_logic;
    data_out : out data_t
  );
  end component;

  signal clk_count_reg : std_logic_vector(31 downto 0) := (others => '0');

  signal alldone_reg : std_logic := '0';

  signal go : std_logic := '1';
  signal start : std_logic_vector(8 downto 0) := (others => '0');
  signal peak : std_logic_vector(17 downto 0) := (others => '0');
  signal len : std_logic_vector(7 downto 0) := (others => '0');
  signal done : std_logic_vector(1 downto 0) := (others => '0');

  signal start_set : std_logic_vector(9 downto 0) := (others => '0');
  signal set_reg : set_t := ((others => '0'), (others => '0'), (others => '0'));

  signal write : std_logic := '0';
  signal addr : std_logic_vector(8 downto 0) := (others => '0');
  signal addr_ram : std_logic_vector(8 downto 0) := (others => '0');
  signal data_in : data_t := ((others => '0'), (others => '0'));
  signal data_out : data_t := ((others => '0'), (others => '0'));


begin
  sorter_p : sorter port map(
    clk => clk,
    set => set_reg,
    top4 => top4
  );

  collatz_p : collatz port map(
    CLK => clk,
    RESET => go,
    START => start_set,
    DATA => data_out,
    PEAK => peak,
    LEN => len,
    FIN => done(0),
    ADDR => addr
  );

  ram_p : RAM port map (
    clk => clk,
    write => write,
    addr => addr_ram,
    data_in => data_in,
    data_out => data_out
  );

  clk_count <= clk_count_reg;
  start_set <= start & '1';
  data_in <= (peak, len);
  --addr_ram <= start - 1 when write = '1' else addr;

  process(clk, alldone_reg)
  begin
    if rising_edge(clk) and alldone_reg = '0' then
      clk_count_reg <= clk_count_reg + 1;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if done = "01" and alldone_reg = '0' then
        set_reg <= (start & '1', peak, len);
        write <= '1';
        addr_ram <= start;
        start <= start + 1;

        if start >= 511 then
          alldone <= '1';
        else
          go <= '1';
        end if;
      else
        write <= '0';
        go <= '0';
        addr_ram <= addr;
      end if;
      done(1) <= done(0);
    end if;
  end process;
end whole_body;
