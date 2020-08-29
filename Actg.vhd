 use ieee.std_logic_1164.all;
 use ieee.std_logic_arith.all;
ENTITY arctg IS
 PORT
 (
 x, y : IN std_logic_vector(4 DOWNTO 0);
 clk : IN STD_LOGIC;
 inicio : IN STD_LOGIC;
 reset : IN STD_LOGIC;
 z : OUT std_logic_vector(15 DOWNTO 0);
 statusSAIDA : OUT std_logic_vector(3 downto 0);
 controleSAIDA : OUT STD_LOGIC_VECTOR(12 DOWNTO 0)
 );
END arctg;
ARCHITECTURE a OF arctg IS
SIGNAL controlePOPC : STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL statusPOPC : STD_LOGIC_VECTOR(3 DOWNTO 0); 
[25]
COMPONENT atan_CORDIC
 PORT
 (
 clk, start : IN STD_LOGIC;
 reset : IN STD_LOGIC;
 controle : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
 status : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
 );
END COMPONENT;
COMPONENT po
 PORT
 (
 x, y : IN std_logic_vector (4 DOWNTO 0);
 controle : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
 clk : IN STD_LOGIC;
 status : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
 z : OUT std_logic_vector(15 DOWNTO 0)
 );
END COMPONENT;
begin
pc : atan_CORDIC
 PORT MAP(
 clk => clk,
 start => inicio,
 reset => reset,
 controle => controlePOPC,
 status => statusPOPC
 );
op : po
 PORT MAP(
 x => x,
 y => y,
 controle => controlePOPC,
 clk => clk,
 status => statusPOPC,
 z =>z
 );
controleSAIDA <= controlePOPC;
statusSAIDA <= statusPOPC;
end a;
