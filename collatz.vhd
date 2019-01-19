library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned."*";
use IEEE.NUMERIC_STD.ALL;

entity Collatz is
  port(
    CLK : in std_logic := '0';
    RESET : in std_logic := '0';
    START : in std_logic_vector(9 downto 0) := (others => '0');
    PEAK : out std_logic_vector(17 downto 0) := (others => '0');
    LEN : out std_logic_vector(7 downto 0) := (others => '0');
    FIN : out std_logic := '0');
end Collatz;

architecture Collatz_Body of Collatz is
  constant three : std_logic_vector(17 downto 0) := "000000000000000011";
  begin
  Climb : process (CLK, RESET, START)
    variable tmp_place : std_logic_vector(17 downto 0) := (others => '0');
    variable tmp_peak : std_logic_vector(17 downto 0) := (others => '0');
    variable TMP_LEN : std_logic_vector(7 downto 0) := (others => '0');

    variable shift : std_logic_vector(4 downto 0) := (others => '0');
  begin
    if RESET = '1' then
      TMP_PLACE := "00000000" & START;
      TMP_PEAK := "00000000" & START;
      TMP_LEN := "00000000";
      FIN <= '0';
    elsif CLK'event and CLK = '1' then
      if TMP_PLACE = "000000000000000001" then
        FIN <= '1';
      else
        if TMP_PLACE(0) = '1' then
          TMP_PLACE := std_logic_vector(to_unsigned(to_integer(unsigned( TMP_PLACE * three )) + 1, 18));
          if TMP_PLACE > TMP_PEAK then
            TMP_PEAK := TMP_PLACE;
          end if;
          TMP_LEN := TMP_LEN + "00000001";
        end if;
        for i in 17 downto 0 loop
          if TMP_PLACE(i) = '1' then
            shift := std_logic_vector(to_unsigned(i, 5));
          end if;
        end loop;
        if shift(4) = '1' then
          TMP_PLACE := "0000000000000000" & TMP_PLACE(17 downto 16);
          TMP_LEN := TMP_LEN + "00010000";
        end if;
        if shift(3) = '1' then
          TMP_PLACE := "00000000" & TMP_PLACE(17 downto 8);
          TMP_LEN := TMP_LEN + "00001000";
        end if;
        if shift(2) = '1' then
          TMP_PLACE := "0000" & TMP_PLACE(17 downto 4);
          TMP_LEN := TMP_LEN + "00000100";
        end if;
        if shift(1) = '1' then
          TMP_PLACE := "00" & TMP_PLACE(17 downto 2);
          TMP_LEN := TMP_LEN + "00000010";
        end if;
        if shift(0) = '1' then
          TMP_PLACE := "0" & TMP_PLACE(17 downto 1);
          TMP_LEN := TMP_LEN + "00000001";
        end if;
      end if;
    end if;
    PEAK <= TMP_PEAK;
    LEN <= TMP_LEN;
  end process;
end Collatz_Body;

