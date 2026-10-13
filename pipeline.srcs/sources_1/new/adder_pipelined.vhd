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
entity adder_pipelined is
port(
clk 	: in std_logic;
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
end adder_pipelined;

--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of adder_pipelined is

--------------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------------

--level1 signals
signal sum_ab		: std_logic_vector(8 downto 0);
signal sum_cd		: std_logic_vector(8 downto 0);
signal sum_ef		: std_logic_vector(8 downto 0);
signal sum_gh		: std_logic_vector(8 downto 0);

-- level2 signals
signal sum_abcd		: std_logic_vector(9 downto 0);
signal sum_fegh		: std_logic_vector(9 downto 0);


--------------------------------------------------------------------------------
-- BEGIN
--------------------------------------------------------------------------------	
begin

--------------------------------------------------------------------------------
-- CONCURRENT STATEMENTS
--------------------------------------------------------------------------------
sum_o <= ('0' & sum_abcd) + ('0' & sum_fegh);

--------------------------------------------------------------------------------
-- PROCESS STATEMENTS 
-- NOTE: Process blocks work concurrently with each other
--------------------------------------------------------------------------------
-- SEQUENTIAL PROCESS
-- main process
P_MAIN : process(clk) begin
if(rising_edge(clk)) then
	
	-- level 1
	sum_ab 		<= ('0' & a_i) + ('0' & b_i);
	sum_cd 		<= ('0' & c_i) + ('0' & d_i);
	sum_ef 		<= ('0' & e_i) + ('0' & f_i);
	sum_gh 		<= ('0' & g_i) + ('0' & h_i);
	
	--level 2
	sum_abcd 	<= ('0' & sum_ab) + ('0' & sum_cd);
	sum_fegh 	<= ('0' & sum_ef) + ('0' & sum_gh);
	
end if;
end process;
end Behavioral;
