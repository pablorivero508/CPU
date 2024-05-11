library IEEE;
use IEEE.STD_LOGIC_1164.all;
--Decodificador de entrada 2 bits y salida 4 bits. 
 
entity decoder_2_4 is
 port(
 a : in STD_LOGIC_VECTOR(1 downto 0);
 b : out STD_LOGIC_VECTOR(3 downto 0)
 );
end decoder_2_4;
 
architecture behavioral of decoder_2_4 is
begin
 
process(a)
begin
 if (a="00") then
 b <= "0001"; --R0 enabled
 elsif (a="01") then
 b <= "0010"; --R1 enabled
 elsif (a="10") then
 b <= "0100"; --R2 enabled
 else--a=11
 b <= "1000"; --R3 enabled
 end if;
end process;
 
end behavioral;