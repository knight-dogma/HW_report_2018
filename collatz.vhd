library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned."*";
use IEEE.NUMERIC_STD.ALL;

entity Collatz is
  port(
    CLK : in std_logic;
    RESET : in std_logic;
    START : in std_logic_vector(9 downto 0);
    PEAK : out std_logic_vector(17 downto 0);
    LEN : out std_logic_vector(7 downto 0);
    FIN : out std_logic);
end Collatz;

architecture Collatz_Body of Collatz is
  SIGNAL TMP_PLACE : std_logic_vector(17 downto 0);
  SIGNAL TMP_PEAK : std_logic_vector(17 downto 0);
  SIGNAL TMP_LEN : std_logic_vector(7 downto 0);
  constant three : std_logic_vector(17 downto 0) := "000000000000000011";
  begin
  Climb : process (CLK, RESET, START)
  begin
    if RESET = '1' then
      TMP_PLACE <= "00000000" & START;
      TMP_PEAK <= "00000000" & START;
      TMP_LEN <= "00000000";
      FIN <= '0';
    elsif CLK'event and CLK = '1' then
      if TMP_PLACE = "000000000000000001" then
        FIN <= '1';
      else
        if TMP_PLACE(0) = '0' then
          TMP_PLACE <= '0' & TMP_PLACE(17 downto 1);
        else
          TMP_PLACE <= std_logic_vector(to_unsigned(to_integer(unsigned( TMP_PLACE * three )) + 1, 18));
        end if;

        if TMP_PLACE > TMP_PEAK then
          TMP_PEAK <= TMP_PLACE;
        end if;

        TMP_LEN <= TMP_LEN + "00000001";
      end if;
    end if;
    PEAK <= TMP_PEAK;
    LEN <= TMP_LEN;
  end process;
end Collatz_Body;

