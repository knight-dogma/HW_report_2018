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
      PEAK : out std_logic_vector(17 downto 0);
      LEN : out std_logic_vector(7 downto 0);
      FIN : out std_logic);
  end component;

  signal clk_count_reg : std_logic_vector(31 downto 0) := (others => '0');

  signal alldone_reg : std_logic := '0';

  signal go : std_logic := '1';
  signal start : std_logic_vector(8 downto 0) := (others => '0');
  signal peak : std_logic_vector(17 downto 0) := (others => '0');
  signal len : std_logic_vector(7 downto 0) := (others => '0');
  signal done : std_logic := '0';

  signal start_set : std_logic_vector(9 downto 0) := (others => '0');
  signal set_reg : set_t := ((others => '0'), (others => '0'), (others => '0'));

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
    PEAK => peak,
    LEN => len,
    FIN => done
  );

  clk_count <= clk_count_reg;
  start_set <= start & '1';

  process(clk, alldone_reg)
  begin
    if rising_edge(clk) and alldone_reg = '0' then
      clk_count_reg <= clk_count_reg + 1;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if done = '1' and alldone_reg = '0' then
        set_reg <= (start & '1', peak, len);
        start <= start + 1;

        if start >= 511 then
          alldone <= '1';
        else
          go <= '1';
        end if;
      else
        go <= '0';
      end if;
    end if;
  end process;
end whole_body;
