library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath_mas_memoria_principal is --DATAPATH+MEMORIA_PRINCIPAL
PORT(
--INPUTS:
        --Señales que viene desde arriba del todo
        CLK: in std_logic;
        --Señales de control que vienen de la UC
        wea:in std_logic_vector(1 downto 0); --0:wen 1:-(don't care)
        rst,count,PC_or_load_store,en_MAR,en_MdoutR,en_IR,rst_IR,ALU_or_MEM,en_load: in std_logic;
--OUTPUTS:
        --señales de estado que proporciono a la UC
        MDoutR_Q_00,operandoA_00: out std_logic_vector(15 downto 0);
        --Para los LEDs de la placa de desarrollo
        R0_Q_00: out std_logic_vector(15 downto 0)
    );
end datapath_mas_memoria_principal;

architecture structural of datapath_mas_memoria_principal is
--componentes internos ""
component blk_mem_gen_0 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

component contador_7bit is
port(count,load: in std_logic;
	  rst: in std_logic;
	  clk: in std_logic;
	  loaded_value: in std_logic_vector(6 downto 0);
	  Q: out std_logic_vector(6 downto 0)--salida binaria
);
end component;

component registro_16bit is
    PORT( D: in std_logic_vector(15 downto 0);
          clk,en,rst: in std_logic;
          Q: out std_logic_vector(15 downto 0) );
end component;

component registro_IR_16bit is
    PORT( D: in std_logic_vector(15 downto 0);
          clk,en,rst,rst_IR: in std_logic;
          Q: out std_logic_vector(15 downto 0) );
end component;

component registro_8bit is
    PORT( D: in std_logic_vector(7 downto 0);
          clk,en,rst: in std_logic;
          Q: out std_logic_vector(7 downto 0) );
end component;

component mux_2_1_8bit is
PORT (  a,b :in STD_LOGIC_VECTOR(7 DOWNTO 0);
s : in STD_LOGIC;
z : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component decoder_2_4 is
port(
 a : in STD_LOGIC_VECTOR(1 downto 0);
 b : out STD_LOGIC_VECTOR(3 downto 0)
 );
end component;

component mux_2_1_16bit is
PORT (  a,b :in STD_LOGIC_VECTOR(15 DOWNTO 0);
s : in STD_LOGIC;
z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end component;

component mux_4_1_16bit is
PORT (  a,b,c,d :in STD_LOGIC_VECTOR(15 DOWNTO 0);
s : in STD_LOGIC_vector(1 downto 0);
z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
end component;

component ALU is
Port (
    A,B: in  STD_LOGIC_VECTOR(15 downto 0);  
    codop: in  STD_LOGIC_VECTOR(3 downto 0);  
    opcional: in std_logic_vector(7 downto 0);
    resultado: out  STD_LOGIC_VECTOR(15 downto 0) 
    );
end component;
--SEÑALES INTERNAS
--Parte 1 (memoria y registros principales)
signal PC_Q_0 : std_logic_vector(6 downto 0);
signal MUX0_0,a_0,MAR_Q_0 : std_logic_vector(7 downto 0);
signal MDinR_Q_0,MDoutR_D_0,MDoutR_Q_0,IR_Q_0 : std_logic_vector(15 downto 0);
--Parte 2 (Banco de Registros y ALU)
signal all_reg_input,R0_Q_0,R1_Q_0,R2_Q_0,R3_Q_0,operandoA,operandoB,ALU_resultado : std_logic_vector(15 downto 0);
signal all_reg_enables: std_logic_vector(3 downto 0);


begin
--Parte 1 (memoria y registros principales)
ProgramCounter: contador_7bit port map(count=>count ,load=>en_load ,rst=>rst ,clk=>clk ,loaded_value=>IR_Q_0(6 downto 0) ,Q=>PC_Q_0 );
a_0<= '0' & PC_Q_0;--concatenación no puedo hacerla en el port map. Sino que esta señal debe existir de por sí y luego la uno
MUX0: mux_2_1_8bit port map(a=>a_0 ,b=>operandoB(7 downto 0) ,s=>PC_or_load_store ,z=>MUX0_0 ); 
MAR: registro_8bit port map(D=>MUX0_0 ,clk=>clk ,en=>en_MAR ,rst=>rst ,Q=>MAR_Q_0 );
BRAM: blk_mem_gen_0 port map(clka=> clk, ena=>'1' ,wea=>wea ,addra=>MAR_Q_0 ,dina=>MDinR_Q_0 ,douta=>MDoutR_D_0);

MDinR:  registro_16bit port map(D=>operandoA ,clk=>clk ,en=>'1' ,rst=>rst ,Q=>MDinR_Q_0 ); --siempre actualizandose, y solo escribe cuando wen(0)=1
MDoutR: registro_16bit port map(D=>MDoutR_D_0 ,clk=>clk ,en=>en_MDoutR ,rst=>rst ,Q=>MDoutR_Q_0 );
MDoutR_Q_00 <= MDoutR_Q_0;--conecto la señal interna a mi output
IR: registro_IR_16bit port map(D=>MDoutR_Q_0 ,clk=>clk ,en=>en_IR ,rst=>rst ,rst_IR=>rst_IR ,Q=>IR_Q_0);

--Parte 2 (Banco de Registros y ALU)

--Funciona segun marca la señar IR_Q_0, donde los campos de bits son: 
--optional es (7 downto 0), s2 es (9 downto 8), s1 es (11 downto to 10), codop es (15 downto 12)
MUX1: mux_2_1_16bit port map(a=>ALU_resultado ,b=>MDoutR_Q_0 ,s=>ALU_or_MEM ,z=>all_reg_input ); 
Decoder: decoder_2_4 port map (a=>IR_Q_0(11 downto 10), b=>all_reg_enables);

R0: registro_16bit port map(D=>all_reg_input,clk=>clk ,en=>all_reg_enables(0) ,rst=>rst ,Q=>R0_Q_0);
R0_Q_00<=R0_Q_0;--conecto la señal interna a mi output
R1: registro_16bit port map(D=>all_reg_input,clk=>clk ,en=>all_reg_enables(1) ,rst=>rst ,Q=>R1_Q_0);
R2: registro_16bit port map(D=>all_reg_input,clk=>clk ,en=>all_reg_enables(2) ,rst=>rst ,Q=>R2_Q_0);
R3: registro_16bit port map(D=>all_reg_input,clk=>clk ,en=>all_reg_enables(3) ,rst=>rst ,Q=>R3_Q_0);

MUXS1: mux_4_1_16bit port map(a=>R0_Q_0 ,b=>R1_Q_0 ,c=>R2_Q_0 ,d=>R3_Q_0 ,s=>IR_Q_0(11 downto 10) ,z=>operandoA );
operandoA_00<=operandoA;--conecto la señal interna a mi output
MUXS2: mux_4_1_16bit port map(a=>R0_Q_0 ,b=>R1_Q_0 ,c=>R2_Q_0 ,d=>R3_Q_0 ,s=>IR_Q_0(9 downto 8) ,z=>operandoB );
ALU0: ALU port map(A=>operandoA ,B=>operandoB ,codop=>IR_Q_0(15 downto 12) ,opcional=>IR_Q_0(7 downto 0) ,resultado=>ALU_resultado);


end structural;
