library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Multiplexor de 4 a 1, con señales de 16 bits.

entity mux_4_1_16bit is
PORT (  a,b,c,d :in STD_LOGIC_VECTOR(15 DOWNTO 0);
s : in STD_LOGIC_vector(1 downto 0);
z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);

end mux_4_1_16bit;

architecture Behavioral of mux_4_1_16bit is
--componentes internos
--señales internas
begin
process(a,b,c,d,s)
begin
    if(s="00") then
        z<=a;   --selecciono R0
    elsif(s="01") then
        z<=b;   --selecciono R1
    elsif(s="10") then
        z<=c;   --selecciono R2
    else --s="11"
        z<=d;   --selecciono R3
    end if;

end process;
end Behavioral;
