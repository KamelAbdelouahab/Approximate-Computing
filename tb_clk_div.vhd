library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_div is
end tb_clk_div;


architecture tb_clk_div_behav of tb_clk_div is

  component clk_div_behav is
   port
   (
	clk : in std_logic; 
	reset : in std_logic;
      	q : out std_logic
   );
  end component;
  
  signal t_clk, t_reset, t_q : std_logic;


  begin

    U1 : clk_div_behav
      port map (t_clk, t_reset, t_q);

    test_process : process
    begin
     	t_reset <= '0';
      	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;

	t_reset <= '1';
	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;
	t_reset <= '0';

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;
	

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;

	t_clk <= '0';
	wait for 5 ns;
	t_clk <= '1'; 
	wait for 5 ns;
	
t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

t_clk <= '0'; 
wait for 5 ns;
t_clk <= '1';
wait for 5 ns;

      wait;

    end process;

end tb_clk_div_behav;

configuration CFG_TB_top of tb_clk_div is
for tb_clk_div_behav
end for;
end CFG_TB_top;
