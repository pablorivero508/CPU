library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Unidad de Control: Finite State Machine tipo MOORE.
--Sus imputs son: clk, MDout_Q_00
--Sus outputs son: rst, count, PC_or_load_store, wea, en_MAR, en_MDoutR, en_IR, rst_IR, ALU_or_MEM

entity unidad_de_control is
PORT(
--INPUTS:
      clk: in std_logic;
      MDoutR_Q_00,operandoA_00: in std_logic_vector(15 downto 0);
--OUTPUTS:     
      wea: out std_logic_vector(1 downto 0);
      rst, count, PC_or_load_store, en_MAR, en_MDoutR, en_IR, rst_IR, ALU_or_MEM,en_load: out std_logic
);
end unidad_de_control;

architecture Behavioral of unidad_de_control is
--componentes internos
--señales internas
type estado is (Reseteo, A, B, C, Desicion, Aritmetico_Logico, StoreA, StoreB, LoadA, LoadB, LoadC, LoadD, Jmp, JnzDesicion, JnzSI, JnzNO, STOP);
signal estado_actual : estado:= Reseteo  ; --El primer estado_actual es Reseteo
signal estado_futuro : estado; 

begin --Tenemos 3 procesos concurrentes entre ellos:

--Actualización de estado actual desde el estado futuro a cada rising edge de clk
PROCESS (clk)
BEGIN
	if(clk'event and clk='1' ) then
			estado_actual <= estado_futuro;
	end if;
END PROCESS;

--Circuito Combinacional 1: Cálculo del estado futuro en base al estado actual y los inputs
process(estado_actual,MDoutR_Q_00, operandoA_00)
begin
    case estado_actual is
    when Reseteo =>
        estado_futuro <= A;
    when A =>
        estado_futuro <= B;
    when B =>
        estado_futuro <= C;
    when C =>
        estado_futuro <= Desicion;    
    when Desicion => --Miramos el codop de la instrucción captada (un clk cycle antes de que llegue al IR).
        if(MDoutR_Q_00(15 downto 12)="1011")    then --Instrucción Load
                estado_futuro <= LoadA;         
        elsif(MDoutR_Q_00(15 downto 12)="1100") then --Instrucción Store
                estado_futuro <= StoreA; 
        elsif(MDoutR_Q_00(15 downto 12)="1101") then --Instrucción Jmp      
                estado_futuro <= Jmp;
        elsif(MDoutR_Q_00(15 downto 12)="1110") then --Instrucción Jnz
                estado_futuro <= JnzDesicion;
        elsif(MDoutR_Q_00(15 downto 12)="1111") then --Instrucción STOP
                estado_futuro <= STOP;
        else                                         --Todos los demás casos de codop (A-L,NOP,movReg o movInst)
                estado_futuro <= Aritmetico_Logico;   
        end if;    
    when Aritmetico_Logico =>
        estado_futuro <= A;    
    when StoreA =>
        estado_futuro <= StoreB;
    when StoreB =>
        estado_futuro <= A;   
    when LoadA =>
        estado_futuro <= LoadB;   
    when LoadB =>
        estado_futuro <= LoadC;   
    when LoadC =>
        estado_futuro <= LoadD;   
    when LoadD =>
        estado_futuro <= A;    
    when Jmp =>
        estado_futuro <= A;
    when JnzDesicion =>     --operandoA_00 ya esta listo para mirar!
        if(operandoA_00="0000000000000000") then
                    estado_futuro <= JnzNO;
        else
                    estado_futuro <= JnzSI;
        end if;
    when JnzSI =>
        estado_futuro <= A;
    when JnzNO =>
        estado_futuro <= A;
    when STOP =>
        estado_futuro <= STOP;
    when others=>           --Por si hubiera duda...no debe pasar!!
        estado_futuro <= A;    
    end case; 
end process;
        
--Circuito Combinacional 2: Actualización de los outputs en función del estado actual.
process(estado_actual)
begin
    case estado_actual is
    when Reseteo =>
        wea<= "00";
        rst<= '1';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when A =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '1'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when B =>
        wea<= "00";
        rst<= '0';
        count<= '1';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when C =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '1';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';   
    when Desicion =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '1';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when Aritmetico_Logico =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '1'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when StoreA =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '1';
        en_MAR<= '1'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when StoreB =>
        wea<= "01";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when LoadA =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '1';
        en_MAR<= '1'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when LoadB =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';
    when LoadC =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '1';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';  
    when LoadD =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '1';
        en_load<= '0'; 
     when Jmp =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '1';
     when JnzDesicion =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';   
     when JnzSI =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '1';
      when JnzNO =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0';   
     when STOP =>
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0'; 
    when others=> --Por si hubiera duda...no debe pasar!!
        wea<= "00";
        rst<= '0';
        count<= '0';
        PC_or_load_store<= '0';
        en_MAR<= '0'; 
        en_MDoutR<= '0';
        en_IR<= '0';
        rst_IR<= '0'; 
        ALU_or_MEM<= '0';
        en_load<= '0'; 
    end case;  
end process;

end Behavioral;
