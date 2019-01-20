library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity RAM is
  port(
    addr : in std_logic_vector(8 downto 0) := (others => '0');
    data_in : in data_t := ((others => '0'), (others => '0'));
    write : in std_logic := '0';
    clk : in std_logic := '0';
    data_out : out data_t := ((others => '0'), (others => '0'))
  );
end RAM;

architecture behaviour of RAM is
  type RAM_ARRAY is array(0 to 511) of data_t;
  signal RAM_SIG : RAM_ARRAY := (others => ((others => '0'), (others => '0')));
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if write = '1' then
        --report "write!";
        --report "addr:" & integer'image(to_integer(unsigned(addr)));
        --report "peak:" & integer'image(to_integer(unsigned(data_in.peak)));
        --report "len:" & integer'image(to_integer(unsigned(data_in.len)));
        RAM_SIG(to_integer(unsigned(addr))) <= data_in;
      end if;
    end if;
  end process;
  data_out <= RAM_SIG(to_integer(unsigned(addr)));
end behaviour;
