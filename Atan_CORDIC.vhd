library ieee;
 use ieee.std_logic_1164.all;
---------------------------------------------------------
ENTITY atan_CORDIC IS
PORT
(
 clk, start : IN STD_LOGIC;
 reset : IN STD_LOGIC;
 controle : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
 status : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END atan_CORDIC;
ARCHITECTURE fsm OF atan_CORDIC IS
 TYPE STATE_TYPE IS (st_0, st_A, st_B, st_C, st_D,st_9, st_E, st_F, st_G, st_H, st_I, st_J,
st_L); 
[26]
 SIGNAL state : STATE_TYPE;
 SIGNAL ld1, ld2, ld3, ld4, ld5, ld6 : std_logic;
 SIGNAL mx1, mx2, mx3, mx4 : std_logic;
 SIGNAL add_SUB1, add_SUB2, add : std_logic;
 SIGNAL comp1, comp2, comp3, comp4 : std_logic;
 SIGNAL aux_r : std_logic;
BEGIN
 comp1 <= status(0);
 comp2 <= status(1);
 comp3 <= status(2);
 aux_r <= status(3);

 PROCESS (clk, reset)
 BEGIN
 IF reset = '1' THEN
 state <= st_0;
 ELSIF clk'EVENT AND clk = '1' THEN
 CASE state IS
 WHEN st_0 =>
 ld1 <= '0';
 ld2 <= '0';
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 IF start = '1' THEN
 state <= st_A;
 END IF;

 WHEN st_A =>
 ld1 <= '0';
 ld2 <= '0';
 ld3 <= '1';
 ld4 <= '1';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '1';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 state <= st_B;
 WHEN st_B =>
 if (comp3='1') then
 mx4 <= '1';
 else
 mx4 <= '0';
 end if;
 ld1 <= '1';
 ld2 <= '1'; 
[27]
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '1';
 mx1 <= '1';
 mx2 <= '0';
 mx3 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 state <= st_C;

 WHEN st_C =>
 IF comp1 = '1' THEN
 state <= st_G;
 ELSE
 state <= st_D;
 END IF;
 ld1 <= '0';
 ld2 <= '0';
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '1';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 WHEN st_D =>
 ld1 <= '0';
 ld2 <= '0';
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '1';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '1';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 state <= st_E;
 WHEN st_E =>
 IF comp1 = '1' THEN
 state <= st_H;
 ELSE
 state <= st_F;
 END IF;
 ld1 <= '0';
 ld2 <= '0';
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '0'; 
[28]
 mx1 <= '0';
 mx2 <= '1';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';

 WHEN st_F =>
 ld1 <= '0';
 ld2 <= '1';
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '1';
 add_SUB2 <= '1';
 add <= '0';
 state <= st_I;
 WHEN st_G =>
 ld1 <= '0';
 ld2 <= '0';
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '1';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '1';
 add_SUB2 <= '0';
 add <= '0';
 state <= st_E;

 WHEN st_H =>
 ld1 <= '0';
 ld2 <= '1';
 ld3 <= '0';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 state <= st_I;

 WHEN st_I =>
 ld1 <= '1';
 ld2 <= '0'; 
[29]
 ld3 <= '1';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '1';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '1';
 state <= st_J;

 WHEN st_J =>
 IF comp2 = '1' THEN
 state <= st_C;
 ELSE
 state <= st_L;
 END IF;
 ld1 <= '0';
 ld2 <= '0';
 ld3 <= '0';
 ld4 <= '1';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 WHEN st_L =>
 if aux_r = '0' then
 ld3 <= '1';
 else ld3 <= '0';
 end if;
 ld1 <= '0';
 ld2 <= '0';
 ld4 <= '0';
 ld5 <= '0';
 ld6 <= '0';
 mx1 <= '0';
 mx2 <= '0';
 mx3 <= '0';
 mx4 <= '0';
 add_SUB1 <= '0';
 add_SUB2 <= '0';
 add <= '0';
 state <= st_0;
 END CASE;
 END IF;
 END PROCESS;
 controle(0) <= ld1;
 controle(1) <= ld2;
 controle(2) <= ld3;
 controle(3) <= ld4;
 controle(4) <= ld5;
 controle(5) <= ld6; 
[30]
 controle(6) <= mx1;
 controle(7) <= mx2;
 controle(8) <= mx3;
 controle(9) <= mx4;
 controle(10) <= add_SUB1;
 controle(11) <= add_SUB2;
 controle(12) <= add;
END fsm;
