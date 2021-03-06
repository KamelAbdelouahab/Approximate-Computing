library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity b08 is
	port (
	      CLOCK: in std_logic;
	      RESET: in std_logic;
	      START: in  std_logic;
		  I: in  std_logic_vector (7 downto 0);
		k: in std_logic;
   		count_out: out std_logic_vector (2 downto 0);
		  O: out std_logic_vector (3 downto 0)
	     );
end b08;


architecture BEHAV_b08 of b08 is

	component logob2
	port
   	(
      		clk_out : in std_logic; 
      		k : in std_logic; 
		st_sel : out std_logic;
		count_out : out std_logic_vector (2 downto 0)
   	);
	end component;
	
	signal st_sel: std_logic;


	type mem is array (0 to 7) of std_logic_vector (19 downto 0);
	constant    ROM: mem :=
	(("01111111100101111010"),
	 ("00111001110101100010"),
	 ("10101000111111111111"),
	 ("11111111011010111010"),
	 ("11111111111101101110"),
	 ("11111111101110101000"),
	 ("11001010011101011011"),
	 ("00101111111111110100"));

	constant start_st :integer:=0;
	constant init :integer:=1;
	constant loop_st :integer:=2;
	constant the_end :integer:=3;

	signal   IN_R: std_logic_vector (7 downto 0);
	signal  OUT_R: std_logic_vector (3 downto 0);

	signal    MAR: integer range 7 downto 0;

	begin

		V3 : logob2 port map (
		clk_out => CLOCK, 
      		k => k,
		st_sel => st_sel,
		count_out => count_out);		
	
		process (CLOCK,RESET,k)
		variable  STATO: integer range 3 downto 0;
		variable  ROM_1: std_logic_vector (7 downto 0);
		variable  ROM_2: std_logic_vector (7 downto 0);
		variable ROM_OR: std_logic_vector (3 downto 0);

		begin
		if RESET = '1' then
			stato := start_st;
			ROM_1 := "00000000";
			ROM_2 := "00000000";
			ROM_OR := "0000";
			MAR <= 0;
			IN_R <= "00000000";
			OUT_R <= "0000";
			O <= "0000";
		elsif CLOCK'event and CLOCK = '1' then
		case STATO is
					
		when start_st =>
			if (START = '1') then
				STATO := init;
			end if;

		when init =>
			IN_R  <= I;
			OUT_R <= "0000";
			MAR   <= 0;
			STATO := loop_st;
											
		when loop_st =>
			ROM_1 := ROM(MAR)(19 downto 12);
			ROM_2 := ROM(MAR)(11 downto 4);
			if st_sel = '0' then
				STATO:=loop_st;
			elsif st_sel = '1' then 
				if ((ROM_2 and not IN_R) or (ROM_1 and IN_R)
				or (ROM_2 and ROM_1)) = "11111111" then
					ROM_OR := ROM(MAR)(3 downto 0);
					OUT_R <= OUT_R or ROM_OR;
				end if;
				STATO := the_end;
			end if;
		    
		when the_end =>
			if (MAR /= 7) then
				MAR <= MAR+1; 
				STATO := loop_st;
			elsif (START = '0') then
				O <= OUT_R;
				STATO := start_st;
			end if;
					
		end case;
		end if;
	end process;
end BEHAV_b08;
			    
