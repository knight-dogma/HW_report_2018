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
  signal write : std_logic := '0';
  signal set : set_t := ((others => '0'), (others => '0'), (others => '0'));
  signal reset : std_logic := '1';
  signal start : std_logic_vector(9 downto 0) := "0000000001";
  signal data : data_t := ((others => '0'), (others => '0'));
  signal data_to_ram : data_t := ((others => '0'), (others => '0'));
  signal peak : std_logic_vector(17 downto 0) := (others => '0');
  signal len : std_logic_vector(7 downto 0) := (others => '0');
  signal fin : std_logic := '0';
  signal fin_prev : std_logic := '0';
  signal start_addr : std_logic_vector(8 downto 0) := (others => '0');
  signal addr : std_logic_vector(8 downto 0) := (others => '0');
  signal addr_ram : std_logic_vector(8 downto 0) := (others => '0');

begin
  collatz_ports : collatz port map(
    CLK => clk,
    RESET => reset,
    START => start,
    DATA => data,
    PEAK => peak,
    LEN => len,
    FIN => fin,
    ADDR => addr
  );

  sorter_ports : sorter port map(
    clk => clk,
    set => set,
    top4 => top4
  );

  ram_ports : RAM port map(
    addr => addr_ram,
    data_in => data_to_ram,
    write => write,
    clk => clk,
    data_out => data
  );

  process(clk, alldone_reg)
  begin
    if rising_edge(clk) and alldone_reg = '0' then
      clk_count_reg <= clk_count_reg + 1;
    end if;
  end process;

  process(clk)
    variable next_start_addr : std_logic_vector(8 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      if fin = '1' and fin_prev = '0' and alldone_reg = '0' then
        next_start_addr := start_addr + 1;
        start_addr <= next_start_addr;
        start <= next_start_addr & '1';
        write <= '1';
        addr_ram <= start_addr;
        data_to_ram <= (peak, len);
        set <= (start_addr & '1', peak, len);
        reset <= '1';
        if start_addr = 511 then
          alldone_reg <= '1';
        end if;
      else
        write <= '0';
        addr_ram <= addr;
        reset <= '0';
      end if;
      alldone <= alldone_reg;
      fin_prev <= fin;
    end if;
  end process;
  start <= start_addr & '1';
  clk_count <= clk_count_reg;
end whole_body;
