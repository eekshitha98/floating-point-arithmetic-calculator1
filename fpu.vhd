----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2018 16:42:35
-- Design Name: 
-- Module Name: floataddsub32 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: vivado 2017.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpu is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in  STD_LOGIC_VECTOR(1 downto 0);
           clk:in std_logic;
           ov:out std_logic;
           res : out STD_LOGIC_VECTOR (31 downto 0));
end fpu;

 --variable data_out1:std_logic_vector(31 downto 0);
--variable ov1:std_logic;
 architecture Behavioral of fpu is
--variable data_out1:std_logic_vector(31 downto 0);
--variable ov1:std_logic;
procedure adder(a,b : in std_logic_vector(31 downto 0);signal data_out:out std_logic_vector(31 downto 0);signal ov:out std_logic)is

variable exponent:std_logic_vector(7 downto 0); 
variable new_frac:std_logic_vector(27 downto 0);
--variable new_frac1:std_logic_vector(28 downto 0):="00000000000000000000000000000";
variable expo1,expo2,expo:std_logic_vector(7 downto 0);
variable frac1,frac2,y:std_logic_vector(27 downto 0);
variable sign,ov1 :std_logic;
variable data_out1:std_logic_vector(31 downto 0);
variable i:integer;
begin
expo1 :=a(30 downto 23);
expo2 :=b(30 downto 23);
exponent:=expo1;
frac1:="01" &a(22 downto 0) & "000";
frac2 := "01" & b(22 downto 0) & "000";
new_frac:=frac1; --comparing
for i in 0 to 10 loop 
if expo2 >expo1 then
frac1 := '0' & frac1(27 downto 1);
expo1:=expo1+'1';
elsif expo1>expo2 then
frac2 := '0' & frac2(27 downto 1);
expo2 :=expo2+'1';
else
exit;
end if;
end loop;
--adding fractions
if(a(31)='1' and b(31)='1') or(a(31)='0' and b(31)='0')then
new_frac:=frac1+frac2;
sign:=a(31);
else
-- aand b have different sign
if (frac1>frac2) then
new_frac:=frac1-frac2;
sign:=a(31);
else
new_frac:=frac2-frac1;
sign:=b(31);
end if;
end if;
exponent:=expo1;
--normalizing
 if new_frac(27)='1' then 
new_frac:='0' &new_frac(27 downto 1);
exponent:=expo1+'1';
end if;
for i in 0 to 10 loop
if new_frac(26)='0' then
new_frac:=new_frac(26 downto 0) & '0';
exponent := expo1-'1'; 
else
exit;
end if;
end loop;
-- rounding off
if conv_integer(new_frac(2 downto 0))>4 then
new_frac:=new_frac(27 downto 4) & "1000";
else
new_frac:=new_frac(27 downto 4)&"0000";
 end if;
--loading data to output
new_frac:=new_frac;
exponent:=exponent;
--if(a(30 downto 23)>b(30 downto 23)) then
--sign:=a(31);
--elsif(b(30 downto 23) >a(30 downto 23)) then
--sign:=b(31);
---elsif(a(30 downto 23)=b(30 downto 23)) then
--if(a(22 downto 0) > b(22 downto 0)) then
--sign:=a(31);
--	else
	--sign:=b(31);
	--end if;
	--end if;
--sign:= a(31) and b(31);
--end if;
data_out<=sign & exponent &new_frac(25 downto 3);
ov<='0';
--return data_out;

end adder; 

procedure subtractor(data1_in,data2_in :in std_logic_vector(31 downto 0);signal data_out:out std_logic_vector(31 downto 0);signal ov:out std_logic)is
--return std_logic_vector is 
variable exponent:std_logic_vector(7 downto 0); 
variable new_frac:std_logic_vector(27 downto 0);
variable expo1,expo2,expo:std_logic_vector(7 downto 0);
variable frac1,frac2:std_logic_vector(27 downto 0);
variable sign,ov1 :std_logic;
variable data_out1:std_logic_vector(31 downto 0);

begin
expo1 :=data1_in(30 downto 23);
expo2 :=data2_in(30 downto 23);
exponent:=expo1;
frac1:="01" &data1_in(22 downto 0) & "000";
frac2 := "01" & data2_in(22 downto 0) & "000";
new_frac:=frac1; --comparing
for i in 0 to 10 loop 
if expo2 >expo1 then
frac1 := '0' & frac1(27 downto 1); expo1:=expo1+'1';
elsif expo1>expo2 then
frac2 := '0' & frac2(27 downto 1);
expo2 :=expo2+'1';
else
exit;
end if;
end loop; --adding fractions
if(data2_in(31)='0' and data1_in(31)='1')then
new_frac:=frac1+frac2;
sign:='1';
elsif(data1_in(31)='0' and data2_in(31)='1') then
new_frac:=frac2+frac1;
sign:='0';
else
if(frac1>frac2)then
new_frac:=frac1-frac2;
sign:=data1_in(31);
else
new_frac:=frac2-frac1;
sign:=not(data2_in(31));
end if;
end if;
exponent:=expo1; --normalizing
if new_frac(27)='1' then 
new_frac:='0' &new_frac(27 downto 1);
exponent:=expo1+'1';
end if; 
for i in 0 to 31 loop
if new_frac(26)='0' then
new_frac:=new_frac(26 downto 0) & '0';
exponent := expo1-'1'; else
exit;
end if;
end loop;
-- rounding off
if conv_integer(new_frac(2 downto 0))>4 then
new_frac:=new_frac(27 downto 4) & "1000";
else
new_frac:=new_frac(27 downto 4)&"0000";
 end if; --loading data to output
new_frac:=new_frac;
exponent:=exponent;

	if new_frac ="0000000000000000000000000000" then
	data_out1:="00000000000000000000000000000000";
	else
data_out<=sign & exponent &new_frac(25 downto 3);
        end if;
        --return data_out;
        ov<='0';
        end subtractor;
        
        procedure mult(a,b :in std_logic_vector(31 downto 0);signal pro:out std_logic_vector(31 downto 0);signal ov:out std_logic)is
        --signal sa,sb:std_LOGIC_VECTOR (31 downto 0);--for a and b;
          --      signal ssa,ssb:std_LOGIC_VECTOR (23 downto 0);-- a and b with hidden bit;
       -- return std_logic_vector is 
        variable sa,sb:std_LOGIC_VECTOR (31 downto 0);--for a and b;
        variable ssa,ssb:std_LOGIC_VECTOR (23 downto 0);-- a and b with hidden bit;
        variable i:integer;
        variable d : std_logic_vector(47 downto 0);-- for result 48 bits;
        variable bp,pv:std_logic_vector (47 downto 0);--for add and shift multiplying;
        variable spro :STD_LOGIC_VECTOR (31 downto 0);
        begin
        sa:=a;
        sb:=b;
        spro:=(others=>'0');
        --pro<=(others=>'0');
        
        spro(31):=sa(31)xor sb(31); -- for sign bit
        spro(30 downto 23):=sa(30 downto 23) + sb(30 downto 23) - "01111111"; --for exponent
       if((spro(30 downto 23)<sa(30 downto 23)) and (spro(30 downto 23)<sb(30 downto 23))) then 
        ov<='1';
        else ov<='0';
       end if;
        ssa(23 downto 0):= '1' & a(22 downto 0); --adding(concatening);
        ssb(23 downto 0):= '1' & b(22 downto 0); --hidden bit
        pv:=(others=>'0');
        bp:="000000000000000000000000"&ssb;
        for i in 0 to 23 loop --shift and add multiplier
        if (ssa(i)='1') then --multiplication without normalisation
        pv:=pv+bp;
        end if;
        bp:= bp(46 downto 0)&'0';
        end loop ;
        d:=pv;
        spro(22 downto 0) := d(45 downto 23);
        if(d(47)='1') then --Normalisation
        spro(22 downto 0):= d(46) &spro(22 downto 1);
        spro(30 downto 23):=spro(30 downto 23)+'1';
        if((spro(30 downto 23)<sa(30 downto 23)) and (spro(30 downto 23)<sb(30 downto 23))) then 
        ov<='1';
        else ov<='0';
        end if;
        end if;
        pro<=spro;
        --return pro;
        end mult;
        procedure div(a,b :in std_logic_vector(31 downto 0);signal div: out std_logic_vector(31 downto 0);signal ov:out std_logic)is
        --return std_logic_vector  is 
        variable sa,sb:std_logic_vector(31 downto 0);
        variable ssa,ssb:std_logic_vector(23 downto 0);
        variable i:integer;
        variable d:std_logic_vector(23 downto 0);
        variable bp,x,y:std_logic_vector(23 downto 0);
        variable spro:std_logic_vector(31 downto 0);
        begin
        sa:=a;
        sb:=b;
        spro:=(others=>'0');
        --if (clk'event and clk='1') then
        spro(31):=sa(31) xor sb(31);
        spro(30 downto 23):=sa(30 downto 23) - sb(30 downto 23) + "01111111"; --for exponent
        if((spro(30 downto 23)>sa(30 downto 23)) and (spro(30 downto 23)>sb(30 downto 23))) then 
        ov<='1';
        else ov<='0';
        end if;
        ssa(23 downto 0):= '1' & a(22 downto 0); --adding(concatening);
        ssb(23 downto 0):= '1' & b(22 downto 0); --hidden bit
        bp:="000000000000000000000000";
        x:=ssa;y:=ssb;
        for i in 23 downto 0 loop
        if y<x then
        bp(i):='1';
        x:=x-y;
        x:=x(22 downto 0) & '0';
        end if;
        end loop;
        spro(22 downto 0):=bp(23 downto 1);
        div<=spro;
        --end if;
--return div;
        end div;
    begin
    --signal data_out1:std_logic_vector(31 downto 0);
    --signal ov1:std_logic;
    process(sel,a,b,clk)
    begin
    if clk='1' and clk'event then
    case sel is
    when "00" =>
     adder(a,b,res,ov);
     --res<=data_out1;
     --ov<=ov1;
     
    when "01" =>
    subtractor(a,b,res,ov);
    --res<=data_out1;
         --ov<=ov1;
    when "10"  => 
    mult(a,b,res,ov);
    --res<=data_out1;
         --ov<=ov1;
    when "11"=>
    div(a,b,res,ov);
    --res<=data_out1;
        -- ov<=ov1;
    when others=>
    adder(a,b,res,ov);
    --res<=data_out1;
         --ov<=ov1;
    end case;
    end if;
    end process;


end Behavioral;
