library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Collatz_tb is

end Collatz_tb;

architecture Collatz_tb_Body of Collatz_tb is
  component Collatz port(
    CLK : in std_logic;
    RESET : in std_logic;
    START : in std_logic_vector(9 downto 0);
    PEAK : out std_logic_vector(17 downto 0);
    LEN : out std_logic_vector(7 downto 0);
    FIN : out std_logic);
  end component;

  signal CLK : std_logic;
  signal RESET : std_logic;
  signal START : std_logic_vector(9 downto 0);
  signal PEAK : std_logic_vector(17 downto 0);
  signal LEN : std_logic_vector(7 downto 0);
  signal FIN : std_logic;

begin
u0: Collatz port map (
	CLK => CLK,
	RESET => RESET,
	START => START,
	PEAK => PEAK,
	LEN => LEN,
	FIN => FIN);

process
begin
  wait for 1 ns;
  for i in 1 to 1023 loop
    report "loop" & integer'image(i);
    RESET <= '1';
    START <= std_logic_vector(to_unsigned(i, 10));
    CLK <= '0';
    wait for 1 ns;
    RESET <= '0';
    while FIN = '0' loop
      CLK <= not CLK;
      wait for 1 ns;
    end loop;
    report "result for" & integer'image(i);
    report "peak: " & integer'image(to_integer(unsigned(PEAK)));
    report "len: " & integer'image(to_integer(unsigned(LEN)));
  end loop;
  wait;
end process;
end Collatz_tb_Body;
