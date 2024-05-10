LIBRARY ieee;
USE ieee.std_logic_1164.all;  
--Un Registro de 16-bit con reset síncrono.Señal de enable
Entity registro_16bit is
    PORT( D: in std_logic_vector(15 downto 0);
          clk,en,rst: in std_logic;
          Q: out std_logic_vector(15 downto 0) );
end registro_16bit;

Architecture behavioral of registro_16bit is
--componentes internos
--señales internas
begin
process(clk)
begin
    if(clk'event and clk='1') then
        if(rst='1') then
            --Q<=(others=>'0');   --Esto lo tengo en pag 44 de VHDL parte 1. Puedo asignar por indices del vector. Y others hace referencia al resto de indices
              Q<="0000000000000000";
        else                    --En este caso... todos!
            if(en='1') then
                Q<=D;
            end if;
        end if;                
    end if;

end process;
end behavioral;
