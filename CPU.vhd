library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Top Entity. Conecta el Datapath+Memoria con la UC. 
--Además, proporciona la señal de reloj y recibe el output de R0 para los LEDS

entity CPU is
Port ( 
        CLK100MHZ: in std_logic;
        LED: out std_logic_vector(15 downto 0)
);
end CPU;

architecture structural of CPU is
--componentes internos
component datapath_mas_memoria_principal is
PORT(
clk: in std_logic;
wea:in std_logic_vector(1 downto 0); 
rst,count,PC_or_load_store,en_MAR,en_MdoutR,en_IR,rst_IR,ALU_or_MEM,en_load: in std_logic;
MDoutR_Q_00,operandoA_00: out std_logic_vector(15 downto 0);
R0_Q_00: out std_logic_vector(15 downto 0)
);
end component;

component unidad_de_control is
PORT(
      clk: in std_logic;
      MDoutR_Q_00,operandoA_00: in std_logic_vector(15 downto 0);
      wea: out std_logic_vector(1 downto 0);
      rst, count, PC_or_load_store, en_MAR, en_MDoutR, en_IR, rst_IR, ALU_or_MEM,en_load: out std_logic
);
end component;

--señales internas
signal wea_0 : std_logic_vector(1 downto 0);
signal rst_0,count_0,PC_or_load_store_0,en_MAR_0,en_MdoutR_0,en_IR_0,rst_IR_0,ALU_or_MEM_0,en_load_0: std_logic;
signal MDoutR_Q_0,operandoA_0: std_logic_vector(15 downto 0);

begin
Datapath0: datapath_mas_memoria_principal port map(clk=>CLK100MHZ ,wea=>wea_0 ,rst=>rst_0 ,count=>count_0 ,PC_or_load_store=>PC_or_load_store_0 ,
           en_MAR=>en_MAR_0 ,en_MdoutR=>en_MdoutR_0 ,en_IR=>en_IR_0 ,rst_IR=>rst_IR_0 ,ALU_or_MEM=>ALU_or_MEM_0 ,en_load=>en_load_0 ,
           MDoutR_Q_00=>MDoutR_Q_0 ,operandoA_00=>operandoA_0 ,R0_Q_00=> LED(15 downto 0));

UC0: unidad_de_control port map(clk=>CLK100MHZ ,MDoutR_Q_00=>MDoutR_Q_0 ,operandoA_00=>operandoA_0 ,wea=>wea_0,rst=>rst_0 ,count=>count_0 ,
           PC_or_load_store=>PC_or_load_store_0 ,en_MAR=>en_MAR_0 ,en_MdoutR=>en_MdoutR_0 ,en_IR=>en_IR_0 ,rst_IR=>rst_IR_0 ,
           ALU_or_MEM=>ALU_or_MEM_0 ,en_load=>en_load_0 );
end structural;
