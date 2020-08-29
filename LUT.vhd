library ieee;
use ieee.std_logic_1164.all;
ENTITY popc_atan_vhdl IS
 PORT
 (
 reset : IN STD_LOGIC;
 iniciar : IN STD_LOGIC;
 clk : IN STD_LOGIC;
 x,y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 z : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
 q : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
 );
END popc_atan_vhdl;
ARCHITECTURE a OF popc_atan_vhdl IS
 SIGNAL vetor : STD_LOGIC_VECTOR(6 DOWNTO 0);
COMPONENT pc_atan_vhdl
 PORT
 (
 clk : IN STD_LOGIC;
 resetPC : IN STD_LOGIC;
 inicio : IN STD_LOGIC;
 output_vec : OUT
 STD_LOGIC_VECTOR(6 DOWNTO 0)
 );
END COMPONENT;
COMPONENT po_atan_vhdl
 PORT
 (
 po_clk : IN STD_LOGIC;
 input_vec : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
 entraX,entraY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 saida : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
 lero : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
 );
END COMPONENT;
BEGIN
pc : pc_atan_vhdl
 PORT MAP
 (
 resetPC => reset,
 output_vec => vetor,
 inicio => iniciar,
 clk => clk
 ); 

po : po_atan_vhdl
 PORT MAP
 (
 input_vec => vetor,
 entraX => x,
 entraY => y,
 saida => z,
 po_clk => clk,
 lero => q
 );
END a;
LIBRARY ieee;
 USE ieee.std_logic_1164.all;
LIBRARY lpm;
USE lpm.lpm_components.all;
-----------------------------------------------------------------------
ENTITY po_atan_vhdl IS
 PORT
 (
 input_vec : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
 entraX,entraY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 po_clk : IN STD_LOGIC;
 saida : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
 lero : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
 );
END po_atan_vhdl;
ARCHITECTURE b OF po_atan_vhdl IS
 signal Xr, Yr : STD_LOGIC_VECTOR(3 DOWNTO 0);
 signal Zr : STD_LOGIC_VECTOR(8 DOWNTO 0);
 SIGNAL Ar,Br,Cr : STD_LOGIC;
 SIGNAL MX1,MX2,LD1,LD2,LD3,LD4,LD5 : STD_LOGIC;

 signal COMP_A_OUT,COMP_B_OUT,COMP_C_OUT : STD_LOGIC; -- entradas do
subtrator / somador
 signal enderecoMEM : STD_LOGIC_VECTOR(10 DOWNTO 0);
 signal mem_out : STD_LOGIC_VECTOR(8 DOWNTO 0);
BEGIN
 MX1 <= input_vec(0);
 MX2 <= input_vec(1);
 LD1 <= input_vec(2);
 LD2 <= input_vec(3);
 LD3 <= input_vec(4);
 LD4 <= input_vec(5);
 LD5 <= input_vec(6);

do_XrYr:
PROCESS (LD1)
 BEGIN
 IF LD1'event and LD1='1' THEN
 Xr <= entraX;
 Yr <= entraY;
 END IF;
END PROCESS do_XrYr;
do_Zr: 
[21]
PROCESS (LD5)
 BEGIN
 IF LD5'event and LD5='1' THEN
 Zr <= mem_out;
 END IF;
END PROCESS do_Zr;
COMP_A_OUT <= '1' WHEN entraX > "0000" ELSE '0';
COMP_B_OUT <= '1' WHEN entraY > "0000" ELSE '0';
COMP_C_OUT <= '1' WHEN entraX > entraY ELSE '0';
Ar <= COMP_A_OUT WHEN LD2 = '1';
Br <= COMP_B_OUT WHEN LD3 = '1';
Cr <= COMP_C_OUT WHEN LD4 = '1';
enderecoMEM(0) <= Yr(0);
enderecoMEM(1) <= Yr(1);
enderecoMEM(2) <= Yr(2);
enderecoMEM(3) <= Yr(3);
enderecoMEM(4) <= Xr(0);
enderecoMEM(5) <= Xr(1);
enderecoMEM(6) <= Xr(2);
enderecoMEM(7) <= Xr(3);
enderecoMEM(8) <= Ar;
enderecoMEM(9) <= Br;
enderecoMEM(10) <= Cr;
memoria : lpm_rom
 GENERIC MAP
 ( LPM_WIDTH => 9,
 LPM_WIDTHAD => 11,
 LPM_ADDRESS_CONTROL => "REGISTERED",
 LPM_OUTDATA => "REGISTERED",
 LPM_FILE => "mem.mif",
 LPM_TYPE => "LPM_ROM",
 LPM_HINT => "UNUSED"
 )
 PORT MAP
 (
 address =>enderecoMEM,
 inclock =>po_clk,
 outclock =>po_clk,
 q =>mem_out
 );

 lero <= enderecoMEM;
 saida <= Zr;
END b;

LIBRARY ieee;
 USE ieee.std_logic_1164.all;
-----------------------------------------------------------------------
ENTITY pc_atan_vhdl IS
 PORT 
[22]
 (
 clk : IN STD_LOGIC;
 resetPC : IN STD_LOGIC;
 inicio : IN STD_LOGIC;
 output_vec : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
 );
END pc_atan_vhdl;
ARCHITECTURE c OF pc_atan_vhdl IS
 TYPE STATE_TYPE IS (st_0, st_A, st_B, st_C, st_D, st_E, st_F);
 SIGNAL state: STATE_TYPE;
BEGIN
 PROCESS (clk, resetPC,inicio)
 BEGIN
 IF resetPC = '1' THEN
 state <= st_0;
 ELSIF clk'EVENT AND clk = '1' THEN
 CASE state IS
 WHEN st_0 =>
 if inicio ='1' then
 state <= st_A;
 end if;
 WHEN st_A =>
 output_vec(0) <= '0';
 output_vec(1) <= '0';
 output_vec(2) <= '1';
 output_vec(3) <= '0';
 output_vec(4) <= '0';
 output_vec(5) <= '0';
 output_vec(6) <= '0';
 state <= st_B;

 WHEN st_B =>
 output_vec(0) <= '0';
 output_vec(1) <= '0';
 output_vec(2) <= '0';
 output_vec(3) <= '0';
 output_vec(4) <= '0';
 output_vec(5) <= '1';
 output_vec(6) <= '0';

 state <= st_C;
 WHEN st_C =>
 output_vec(0) <= '1';
 output_vec(1) <= '0';
 output_vec(2) <= '0';
 output_vec(3) <= '0';
 output_vec(4) <= '1';
 output_vec(5) <= '0';
 output_vec(6) <= '0';
 state <= st_D;
 WHEN st_D =>
 output_vec(0) <= '0';
 output_vec(1) <= '1';
 output_vec(2) <= '0';
 output_vec(3) <= '1'; 
 output_vec(4) <= '0';
 output_vec(5) <= '0';
 output_vec(6) <= '0';
 state <= st_E;

 WHEN st_E =>
 state <= st_F;
 WHEN st_F =>
 output_vec(0) <= '0';
 output_vec(1) <= '0';
 output_vec(2) <= '0';
 output_vec(3) <= '0';
 output_vec(4) <= '0';
 output_vec(5) <= '0';
 output_vec(6) <= '1';

 state <= st_0;
 END CASE;
 END IF;
 END PROCESS;
END c;
