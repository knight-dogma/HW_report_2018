library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use work.types.all;

entity SORTER is
  port (
    clk   : in std_logic := '0';
    set   : in set_t := ((others => '0'), (others => '0'), (others => '0'));
    top4  : out sets4_t := (others => ((others => '0'), (others => '0'), (others => '0')))
  );
end SORTER;

architecture SORTER_BODY of SORTER is
  signal top4_tmp : sets4_t := (others => ((others => '0'), (others => '0'), (others => '0')));

begin
  top4 <= top4_tmp;

  process(clk)

    variable sets : sets5_t := (others => ((others => '0'), (others => '0'), (others => '0')));
    variable flag: std_logic := '0';

  begin

    if rising_edge(clk) then
      for i in 0 to 3 loop
        sets(i) := top4_tmp(i);
      end loop;

      sets(4) := set;

      flag := '0';
      for i in 0 to 3 loop
        if sets(i).peak = sets(4).peak then
          if sets(i).LEN < sets(4).LEN then
            sets(i).START := sets(4).START;
            sets(i).LEN := sets(4).LEN;
          end if;

          flag := '1';
        end if;
      end loop;

      for i in 4 downto 1 loop
        if sets(i-1).PEAK < sets(i).peak and flag = '0' then
          sets(i).START := sets(i-1).START xor sets(i).START;
          sets(i-1).START := sets(i-1).START xor sets(i).START;
          sets(i).START := sets(i-1).START xor sets(i).START;

          sets(i).PEAK := sets(i-1).PEAK xor sets(i).PEAK;
          sets(i-1).PEAK := sets(i-1).PEAK xor sets(i).PEAK;
          sets(i).PEAK := sets(i-1).PEAK xor sets(i).PEAK;

          sets(i).LEN := sets(i-1).LEN xor sets(i).LEN;
          sets(i-1).LEN := sets(i-1).LEN xor sets(i).LEN;
          sets(i).LEN := sets(i-1).LEN xor sets(i).LEN;
        end if;
      end loop;

      for i in 0 to 3 loop
        top4_tmp(i) <= sets(i);
      end loop;
    end if;
  end process;
end SORTER_BODY;
