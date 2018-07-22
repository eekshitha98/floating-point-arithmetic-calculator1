----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2018 17:17:13
-- Design Name: 
-- Module Name: tbaddsub - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tbfpu is
--  Port ( );
end tbfpu;

architecture Behavioral of tbfpu is

component fpu
 Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
          b : in STD_LOGIC_VECTOR (31 downto 0);
          sel : in  STD_LOGIC_VECTOR(1 downto 0);
          clk:in std_logic;
          ov:out std_logic;
          res : out STD_LOGIC_VECTOR (31 downto 0));
           end component;
           signal sel :  std_logic_vector(1 downto 0) := "00";
           signal a :  std_logic_vector(31 downto 0) := (others=>'0');
           signal b :  std_logic_vector(31 downto 0) := (others=>'0');
           --outputs
           signal res:  std_logic_vector(31 downto 0);
           signal ov,clk:std_logic;
begin
uut: fpu port map(a => a,b => b,clk=>clk,sel =>sel,res => res,ov=>ov);

process
begin

-- wait 100 ns for global reset to finish
a<="11000000111100000000000000000000";
b<="01000000001000000000000000000000";
sel<="00";
wait for 100ns;
a<="11000000111100000000000000000000";
b<="01000000001000000000000000000000";
sel<="01";
wait for 100ns;
a<="11000000111100000000000000000000";
b<="01000000001000000000000000000000";
sel<="10";
wait for 100ns;
a<="11000000111100000000000000000000";
b<="01000000001000000000000000000000";
sel<="11";
wait for 100ns;
end process;
process begin
clk<='0';
wait for 50ns;
clk<='1';
wait for 50ns;
end process;
end Behavioral;
