library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.types.all;

entity sorter is
  port(
    clk : in std_logic := '0';
    set : in set_t := ((others => '0'), (others => '0'), (others => '0'));
    top4 : out sets4_t := (others => ((others => '0'), (others => '0'), (others => '0')))
  );
end sorter;

architecture sorter_body of sorter is
  signal top4_reg : sets4_t := (others => ((others => '0'), (others => '0'), (others => '0')));
begin

  process(clk)
    variable top4_tmp : sets4_t := (others => ((others => '0'), (others => '0'), (others => '0')));
    variable set_tmp : set_t := ((others => '0'), (others => '0'), (others => '0'));
    variable for_swp : set_t := ((others => '0'), (others => '0'), (others => '0'));
    variable eql_flag : std_logic := '0';
  begin
    if rising_edge(clk) then
      top4_tmp := top4_reg;
      set_tmp := set;
      eql_flag := '0';
      for i in 0 to 3 loop
        if top4_tmp(i).peak = set_tmp.peak then
          if top4_tmp(i).len < set_tmp.len then
            for_swp.start := top4_tmp(i).start;
            top4_tmp(i).start := set_tmp.start;
            set_tmp.start := for_swp.start;

            for_swp.len := top4_tmp(i).len;
            top4_tmp(i).len := set_tmp.len;
            set_tmp.len := for_swp.len;
         end if;
         eql_flag := '1';
       end if;
      end loop;
      if eql_flag = '0' then
        for i in 0 to 3 loop
          if top4_tmp(i).peak < set_tmp.peak then
            for_swp.start := top4_tmp(i).start;
            top4_tmp(i).start := set_tmp.start;
            set_tmp.start := for_swp.start;

            for_swp.len := top4_tmp(i).len;
            top4_tmp(i).len := set_tmp.len;
            set_tmp.len := for_swp.len;

            for_swp.peak := top4_tmp(i).peak;
            top4_tmp(i).peak := set_tmp.peak;
            set_tmp.peak := for_swp.peak;
          end if;
        end loop;
      end if;
      top4_reg <= top4_tmp;
    end if;
  end process;
  top4 <= top4_reg;
end sorter_body;

