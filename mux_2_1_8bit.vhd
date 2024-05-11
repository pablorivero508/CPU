LIBRARY ieee;
USE ieee.std_logic_1164.all;
--Multiplexor de 2 a 1, con señales de 8 bits.

ENTITY mux_2_1_8bit is
PORT (  a,b :in STD_LOGIC_VECTOR(7 DOWNTO 0);
s : in STD_LOGIC;
z : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END mux_2_1_8bit;

ARCHITECTURE Behavioral OF mux_2_1_8bit IS

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