library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

package types is

  type set_t is record
    START : std_logic_vector(9 downto 0);
    PEAK  : std_logic_vector(17 downto 0);
    LEN   : std_logic_vector(7 downto 0);
  end record;

  type sets4_t is array(0 to 3) of set_t;
  type sets5_t is array(0 to 4) of set_t;
end package types;
