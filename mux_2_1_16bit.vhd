LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

ENTITY mux_2_1_16bit is
PORT (  a,b :in STD_LOGIC_VECTOR(15 DOWNTO 0);
s : in STD_LOGIC;
z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END mux_2_1_16bit;

ARCHITECTURE Behavioral OF mux_2_1_16bit IS

BEGIN

process(s,a,b) is
begin
    if(s='0')then
        z<=a;
    else --s='1'
        z<=b;
    end if;
end process;

END Behavioral;