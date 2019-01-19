library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity testbench is
end testbench;

architecture behaviour of testbench is

  component whole
    port (
      clk : in std_logic;
      clk_count : out std_logic_vector(31 downto 0) := (others => '0');
      top4 : out sets4_t;
      alldone : out std_logic
    );
  end component;

  signal clk : std_logic := '0';
  signal clk_count : std_logic_vector(31 downto 0) := (others => '0');
  signal top4 : sets4_t := (others => ((others => '0'), (others => '0'), (others => '0')));
  signal alldone : std_logic := '0';
  signal finished : std_logic := '0';
  signal printed : std_logic := '0';

begin
  main : whole port map(
    clk => clk,
    clk_count => clk_count,
    top4 => top4,
    alldone => alldone
  );

  clock : process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  repo : process(clk, alldone)
  begin
    if rising_edge(clk) and alldone = '1' and finished = '0' then
      finished <= '1';
    end if;

    if finished = '1' and printed = '0' then
      printed <= '1';
      report "results";
      report "clocks:" & integer'image(to_integer(unsigned(clk_count)));
      for i in 0 to 3 loop
        report "start:" & integer'image(to_integer(unsigned(top4(i).START)));
        report "peak:" & integer'image(to_integer(unsigned(top4(i).PEAK)));
        report "len::" & integer'image(to_integer(unsigned(top4(i).LEN)));
      end loop;
    end if;
  end process;


end behaviour;
