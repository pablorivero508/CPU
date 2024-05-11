library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Testbench para realizar la Simulación Funcional. Simula la señal de reloj a través de clk_tb

entity CPU_tb is
end CPU_tb;

architecture Behavioral of CPU_tb is
--componente interno a testear
component CPU is
Port ( 
        CLK100MHZ: in std_logic
);
end component;
--Señal interna que damos como input al componente
signal clk_tb: std_logic:= '0';

begin
uut: CPU port map(CLK100MHZ=>clk_tb);

tb: PROCESS --proceso que se repite
BEGIN
    wait for 5 ns; -- Despues de 5ns con clk_tb a '0':
    clk_tb <= '1';
    wait for 5 ns; 
    clk_tb <= '0';
END PROCESS tb;

end Behavioral;
