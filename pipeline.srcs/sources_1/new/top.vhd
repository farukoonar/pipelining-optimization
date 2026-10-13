--------------------------------------------------------------------------------
-- LIBRARY and PACKAGE DECLARATIONS
--------------------------------------------------------------------------------
-- standard package
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity top is
generic(
c_clkfreq 	: integer := 100_000_000;
c_pipelined : boolean := true
);
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
end top;

--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of top is

--------------------------------------------------------------------------------
-- COMPONENT DECLARATIONS
--------------------------------------------------------------------------------
component adder is
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
end component;

component adder_pipelined is
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
end component;
--------------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------------
signal reg_a	: std_logic_vector(7 downto 0);
signal reg_b	: std_logic_vector(7 downto 0);
signal reg_c	: std_logic_vector(7 downto 0);
signal reg_d	: std_logic_vector(7 downto 0);
signal reg_e	: std_logic_vector(7 downto 0);
signal reg_f	: std_logic_vector(7 downto 0);
signal reg_g 	: std_logic_vector(7 downto 0);
signal reg_h	: std_logic_vector(7 downto 0);
signal reg_sum	: std_logic_vector(10 downto 0);

--------------------------------------------------------------------------------
-- BEGIN
--------------------------------------------------------------------------------	
begin

--------------------------------------------------------------------------------
-- COMPONENT INSTANTIATIONS
--------------------------------------------------------------------------------
g_default : if c_pipelined = false generate
i_adder : adder 
port map(
a_i 	=>    reg_a       ,
b_i 	=>    reg_b       ,
c_i 	=>    reg_c       ,
d_i 	=>    reg_d       ,
e_i 	=>    reg_e       ,
f_i 	=>    reg_f       ,
g_i 	=>    reg_g       ,
h_i 	=>    reg_h       ,
sum_o 	=>    reg_sum
);
end generate;

g_pipelined : if c_pipelined = true generate
i_adder : adder_pipelined 
port map(
clk 	=> 	  clk 		  ,
a_i 	=>    reg_a       ,
b_i 	=>    reg_b       ,
c_i 	=>    reg_c       ,
d_i 	=>    reg_d       ,
e_i 	=>    reg_e       ,
f_i 	=>    reg_f       ,
g_i 	=>    reg_g       ,
h_i 	=>    reg_h       ,
sum_o 	=>    reg_sum
);
end generate;

--------------------------------------------------------------------------------
-- PROCESS STATEMENTS 
-- NOTE: Process blocks work concurrently with each other
--------------------------------------------------------------------------------
-- SEQUENTIAL PROCESS
-- main process
P_MAIN : process(clk) begin
if(rising_edge(clk)) then
	
	reg_a <= a_i;
	reg_b <= b_i;
	reg_c <= c_i;
	reg_d <= d_i;
	reg_e <= e_i;
	reg_f <= f_i;
	reg_g <= g_i;
	reg_h <= h_i;
	
	sum_o <= reg_sum;
	
end if;
end process;
end Behavioral;
