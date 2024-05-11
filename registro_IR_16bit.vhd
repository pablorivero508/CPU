LIBRARY ieee;
USE ieee.std_logic_1164.all;  
--Registro de 16 bits con reset síncrono y señal de enable. Además, añadimos la señal rst_IR para poder resetear 
--el registro al terminar la op arit-log (justo el ck cycle consecutivo). Sino la operación se ejecuta 
--en cada clock cycle hasta que llegue la nueva instrucción.

Entity registro_IR_16bit is
    PORT( D: in std_logic_vector(15 downto 0);
          clk,en,rst,rst_IR: in std_logic;
          Q: out std_logic_vector(15 downto 0) );
end registro_IR_16bit;

Architecture behavioral of registro_IR_16bit is
--componentes internos
--señales internas
begin
process(clk)
begin
    if(clk'event and clk='1') then
        if(rst='1' or rst_IR='1') then
            Q<=(others=>'0');   --Puedo asignar por indices del vector. Y others hace referencia al resto de indices
        else                    
            if(en='1') then
                Q<=D;
            end if;
        end if;                
    end if;

end process;
end behavioral;
