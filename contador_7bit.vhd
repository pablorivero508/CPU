library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;--Permite operaciones entre std_logic_vector entendiendolos como unsigned

--Contador de 7 bits con enable para incrementar la cuenta en 1(señal count) y reset síncrono. Cuenta numeros de 0 a 127. 
--Si sobrepasa debe seguir contando por 0. También podemos cargarle un valor directamente usando la señal load.

entity contador_7bit is
port(count,load: in std_logic;
	  rst: in std_logic;
	  clk: in std_logic;
	  loaded_value: in std_logic_vector(6 downto 0);
	  Q: out std_logic_vector(6 downto 0)--salida binaria
);
end contador_7bit;

architecture behavioral of contador_7bit is
--internal components
--internal signals
signal Q_0: std_logic_vector(6 downto 0);--cuenta interna 

begin

process(clk)
begin
		if(clk'event and clk='1')then
		    if(rst='1')then
			     Q_0<= "0000000";
			elsif(load='1') then	
				 Q_0<= loaded_value;
			elsif(count='1') then
					Q_0<=Q_0+1;    --si sobrepasamos.127+1=0 de nuevo
			end if;
		end if;
end process;
--concurrentemente...
Q<= Q_0;

end behavioral;
