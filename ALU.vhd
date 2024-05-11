library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;  --Permite operaciones entre std_logic_vector entendiendolos como signed
use ieee.NUMERIC_STD.all;

--Unidad Aritmético Lógica. Trabaja con 2 inputs de 16 bits y entrega la señal resultado de 16 bits.

entity ALU is
    Port (
    A,B: in  STD_LOGIC_VECTOR(15 downto 0);  -- Los 2 inputs de 16 bits
    codop: in  STD_LOGIC_VECTOR(3 downto 0);  --codop de 4 bits
    opcional: in std_logic_vector(7 downto 0); --campo opcional de 8 bits
    resultado: out  STD_LOGIC_VECTOR(15 downto 0) --resultado de 16 bits
    );
end ALU; 

Architecture Behavioral of ALU is
--componentes internos
--señales internas
begin
   process(A,B,codop)
 begin
  case(codop) is
  when "0000" => -- NOP
   resultado<= A ;
  when "0001" => -- Suma
   resultado <= A + B ; 
  when "0010" => -- Resta
   resultado <= A - B ;
  when "0011" => -- AND
   resultado <= A and B ;
  when "0100" => -- OR
   resultado <= A or B ;
  when "0101" => -- XOR
   resultado <= A xor B;
  when "0110" => -- NOT
   resultado <= not(A);
  when "0111" => -- Shift Logical Left x posiciones
   resultado <= std_logic_vector(signed(A) sll 1);
  when "1000" => -- Shift Logical Right x posiciones
   resultado <= std_logic_vector(signed(A) srl 1);
  when "1001" => -- MovReg
   resultado <= B ;
  when "1010" => --MovInst
   resultado <= "00000000"&opcional;
   
  when others => resultado <= A;    --Para codops de otro valor (Load, Store, STOP, jmp y jnz) simplemente ALU hace NOP:
                                    --deja pasar A y se guarda a sí mismo en Ra.
  end case;
 end process;

end Behavioral;
