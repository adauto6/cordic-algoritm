----------------------------------------------------------
library ieee;
 use ieee.std_logic_1164.all;
 use ieee.std_logic_unsigned.all;
library lpm;
 use lpm.lpm_components.all;
----------------------------------------------------------
ENTITY po IS
PORT
(
 x, y : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
 controle : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
 clk : IN STD_LOGIC;
 status : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
 z : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
);
END po;
ARCHITECTURE arch OF po IS
 CONSTANT zr_in : std_logic_vector := "0100000000000000";

--------------------- Sinais de Controle -------------------
 SIGNAL ld1, ld2, ld3, ld4, ld5,ld6 : std_logic;
 SIGNAL mx1, mx2, mx3, mx4 : std_logic;
 SIGNAL add_SUB1, add_SUB2, add : std_logic;
 SIGNAL comp1, comp2,comp3, aux_r : std_logic;
--------------------------------------------------------------------
 SIGNAL xr_data, xrn_data, yr_data : STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL zr_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
 SIGNAL ir_data : STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL aux_data : std_logic;
--------------------------------------------------------------------
 SIGNAL as1_1in, as1_2in : STD_LOGIC_VECTOR(12 DOWNTO 0);
 SIGNAL as1_out : STD_LOGIC_VECTOR(12 DOWNTO 0);
 SIGNAL as2_1in, as2_2in : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL as2_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
 SIGNAL add_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
--------------------------------------------------------------------
 SIGNAL lut_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
 SIGNAL inv_z_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
 SIGNAL bs_in, bs_out : STD_LOGIC_VECTOR(12 DOWNTO 0);
 SIGNAL bs_y_out, bs_x_out : STD_LOGIC_VECTOR(12 DOWNTO 0);
 SIGNAL inv_y_out, inv_x_out : STD_LOGIC_VECTOR(12 DOWNTO 0);
--------------------------------------------------------------------
BEGIN 
[31]
z <= zr_data;
ld1 <= controle(0);
ld2 <= controle(1);
ld3 <= controle(2);
ld4 <= controle(3);
ld5 <= controle(4);
ld6 <= controle(5);
mx1 <= controle(6);
mx2 <= controle(7);
mx3 <= controle(8);
mx4 <= controle(9);
add_SUB1 <= controle(10);
add_SUB2 <= controle(11);
add <= controle(12);
status(0) <= comp1;
status(1) <= comp2;
status(2) <= comp3;
status(3) <= aux_r;
 --registrador Xr
xr: process(ld1,ld5,mx1)
 begin
 if (ld1'event and ld1='1') then
 if(mx1 = '0') then
 xr_data <= xrn_data;
 elsif mx4='0' then
 xr_data <= inv_y_out;
 else
 xr_data <= bs_y_out;
 end if;
 end if;
 end process xr;

 --registrador Yr
yr: process(ld2,mx1)
 begin
 if (ld2'event and ld2='1') then
 if(mx1 = '1') then -- entrada depende da saída do mux1
 yr_data <= inv_x_out;
 else
 yr_data <= as1_out;
 end if;
 end if;
 end process yr;

 --comparador 1
comparando: lpm_compare
 GENERIC MAP
 ( LPM_WIDTH => 13,
 LPM_REPRESENTATION => "SIGNED",
 LPM_TYPE => "LPM_COMPARE",
 LPM_HINT => "UNUSED"
 )
 PORT MAP
 ( dataa => yr_data, 
[32]
 datab => "0000000000000",
 agb => comp1
 );

 --comparador 3
comparando3: lpm_compare
 GENERIC MAP
 (LPM_WIDTH => 5,
 LPM_REPRESENTATION => "SIGNED",
 LPM_TYPE => "LPM_COMPARE",
 LPM_HINT => "UNUSED"
 )
 PORT MAP
 (dataa => y,
 datab => "00000",
 agb => comp3
 );

doAux_R:
 PROCESS (ld6)
 BEGIN
 IF ld6'event and ld6='1' THEN
 aux_r <= comp3;
 END IF;
 END PROCESS doAux_R;

 --inversor de y
 inv_y_out <= (not bs_y_out) + 1;

 --inversor de x
 inv_x_out <= (not bs_x_out) + 1;

 --bitshift em x
 bs_x_out <= x & "00000000";

 --bitshift em y
 bs_y_out <= y & "00000000";

--------------------- Atualizacao do X-Y ---------------------------
 --entrada do bitshift
 bs_in <= xr_data when mx2='1' else yr_data;

 --Bitshift em Xr ou Yr
shiftingY: lpm_clshift
 GENERIC MAP
 (LPM_WIDTH => 13,
 LPM_WIDTHDIST => 4,
 LPM_SHIFTTYPE => "ARITHMETIC",
 LPM_TYPE => "LPM_CLSHIFT",
 LPM_HINT => "UNUSED"
 )
 PORT MAP (
 data => bs_in,
 distance => ir_data,
 direction => '1',
 result => bs_out
 );
doXrn: 
[33]
 PROCESS (ld5)
 BEGIN
 IF ld5'event and ld5='1' THEN
 xrn_data <= as1_out;
 END IF;
 END PROCESS doXrn;
----------------------SOMADOR 1-------------------------------------
 --somador subtrator 1
 as1_1in <= xr_data WHEN MX3 ='1' ELSE yr_data;
 as1_2in <= bs_out;
somando1: lpm_add_sub
 GENERIC MAP
 (LPM_WIDTH => 13,
 LPM_DIRECTION => "UNUSED",
 LPM_REPRESENTATION => "SIGNED",
 LPM_TYPE => "LPM_ADD_SUB",
 LPM_HINT => "UNUSED"
 )

 PORT MAP
 ( dataa => as1_1in,
 datab => as1_2in,
 add_sub => add_SUB1,
 result => as1_out
 );
--------------------- Atualizacao do Z -----------------------------
 --registrador Zr
zr: process(ld3,mx1,mx4)
 begin
 if (ld3'event and ld3='1') then
 if (mx1 = '1')then -- entrada depende da saída do mux5
 zr_data <= zr_in;
 elsif (mx4='1')then -- entrada depende da saída do mux8
 zr_data <= as2_out;
 else
 zr_data <= inv_z_out; --correção se y<0
 end if;
 end if;
 end process zr;

 --registrador Ir
ir: process(ld4,mx1)
 begin
 if (ld4'event and ld4='1') then
 if(mx1='1') then
 ir_data <= "0000";
 ELSE
 ir_data <= add_out; -- entrada depende da saída do mux7
 end if;
 end if;
 end process ir;
----------------------SOMADOR 2-------------------------------------
 --somador subtrator 2
 as2_1in <= zr_data;
 as2_2in <= lut_out; 
[34]
somando2: lpm_add_sub
 GENERIC MAP
 ( LPM_WIDTH =>16,
 LPM_DIRECTION => "UNUSED",
 LPM_REPRESENTATION =>"SIGNED",
 LPM_TYPE =>"LPM_ADD_SUB",
 LPM_HINT => "UNUSED"
 )
 PORT MAP
 ( dataa => as2_1in,
 datab => as2_2in,
 add_sub => add_SUB2,
 result => as2_out
 );
 --somador de iteração
 add_out <= (ir_data + 1) WHEN add='1' ELSE add_out;

 --comparador 2
comparando2: lpm_compare
 GENERIC MAP
 ( LPM_WIDTH =>4,
 LPM_REPRESENTATION =>"UNSIGNED",
 LPM_TYPE =>"LPM_COMPARE",
 LPM_HINT =>"UNUSED"
 )
 PORT MAP
 ( dataa => ir_data,
 datab => "1100",
 aleb => comp2
 );

 --LUT
mem: lpm_rom
 GENERIC MAP
 ( LPM_WIDTH =>16,
 LPM_WIDTHAD => 4,
 LPM_ADDRESS_CONTROL => "UNREGISTERED",
 LPM_OUTDATA =>"UNREGISTERED",
 LPM_FILE =>"mem.mif",
 LPM_TYPE =>"LPM_ROM",
 LPM_HINT => "UNUSED"
 )
 PORT MAP (
 address => ir_data,
 q => lut_out
 );
 --inversor de Zr
 inv_z_out <= (not zr_data) + 1;

END arch; 
