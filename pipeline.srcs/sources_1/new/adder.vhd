--------------------------------------------------------------------------------
-- LIBRARY and PACKAGE DECLARATIONS
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity adder is
port(
a_i 	: in std_logic_vector(7 downto 0);
b_i 	: in std_logic_vector(7 downto 0);
c_i 	: in std_logic_vector(7 downto 0);
d_i 	: in std_logic_vector(7 downto 0);
e_i 	: in std_logic_vector(7 downto 0);
f_i 	: in std_logic_vector(7 downto 0);
g_i 	: in std_logic_vector(7 downto 0);
h_i 	: in std_logic_vector(7 downto 0);
sum_o 	: out std_logic_vector(10 downto 0)
);
end adder;

--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of adder is

--------------------------------------------------------------------------------
-- BEGIN
--------------------------------------------------------------------------------	
begin

--------------------------------------------------------------------------------
-- CONCURRENT STATEMENTS
--------------------------------------------------------------------------------
sum_o 	<= ("000" & a_i) + ("000" & b_i) + ("000" & c_i) + ("000" & d_i) 
		+  ("000" & e_i) + ("000" & f_i) + ("000" & g_i) + ("000" & h_i);

end Behavioral;
