library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

library work;
use work.blur_pkg.all;

entity blur is
   port
   (
	blur_clk : in std_logic;
	blur_xnor_value : in std_logic_vector (12 downto 0);
	blur_matrix_int : in blur_matrix_int_type;
	blur_res_matrix : out blur_res_matrix_type
   );
end entity blur;

architecture blur_arch of blur is

component blur_mult
port
   (
	blur_mult_regxnor_value : in std_logic_vector (12 downto 0);
	blur_mult_regop1 : in std_logic_vector (11 downto 0);
      	blur_mult_regop2 : in std_logic_vector (11 downto 0);
	blur_mult_regres : out std_logic_vector (23 downto 0)
   );
end component;

constant key_width: integer:=13;
constant matrix_size: integer:=8;
constant operand_width: integer:=12;
constant result_width: integer:=operand_width*2;

type blur_matrix_row_type is array (0 to matrix_size-1) of integer;
type blur_matrix_type is array (0 to matrix_size-1) of blur_matrix_row_type;

type blur_sum_matrix_row_type is array (0 to matrix_size-1) of std_logic_vector(operand_width-1 downto 0);
type blur_sum_matrix_type is array (0 to matrix_size-1) of blur_sum_matrix_row_type;

--type blur_res_matrix_row_type is array (0 to matrix_size-1) of std_logic_vector(result_width-1 downto 0);
--type blur_res_matrix_type is array (0 to matrix_size-1) of blur_res_matrix_row_type;

--type blur_matrix_int_type is array (0 to (matrix_size*matrix_size)-1) of integer;

signal blur_matrix : blur_matrix_type;
signal blur_sum_matrix : blur_sum_matrix_type;
--signal blur_res_matrix : blur_res_matrix_type;
--signal blur_matrix_int : blur_matrix_int_type;

begin
	process(blur_matrix_int, blur_matrix, blur_clk)
	begin
		if blur_clk'event and blur_clk='1' then
			blur_comp14:for i in 0 to matrix_size-1 loop
				blur_comp15:for j in 0 to matrix_size-1 loop
					blur_matrix(i)(j) <= blur_matrix_int((matrix_size*i)+j);
				end loop blur_comp15;
			end loop blur_comp14;

			blur_comp10:for i in 1 to matrix_size-2 loop
				blur_comp11:for j in 1 to matrix_size-2 loop
					blur_sum_matrix(i)(j) <= conv_std_logic_vector((blur_matrix(i-1)(j-1)+blur_matrix(i-1)(j)+blur_matrix(i-1)(j+1)+blur_matrix(i)(j-1)+blur_matrix(i)(j)+blur_matrix(i)(j+1)+blur_matrix(i+1)(j-1)+blur_matrix(i+1)(j)+blur_matrix(i+1)(j+1)),12);
				end loop blur_comp11;
			end loop blur_comp10;
	
			blur_sum_matrix(0)(0) <= conv_std_logic_vector((blur_matrix(0)(0)+blur_matrix(0)(1)+blur_matrix(1)(0)+blur_matrix(1)(1)),12);
			blur_sum_matrix(0)(matrix_size-1) <= conv_std_logic_vector((blur_matrix(0)(matrix_size-2)+blur_matrix(0)(matrix_size-1)+blur_matrix(1)(matrix_size-2)+blur_matrix(1)(matrix_size-1)),12);
			blur_sum_matrix(matrix_size-1)(0) <= conv_std_logic_vector((blur_matrix(matrix_size-2)(0)+blur_matrix(matrix_size-2)(1)+blur_matrix(matrix_size-1)(0)+blur_matrix(matrix_size-1)(1)),12);
			blur_sum_matrix(matrix_size-1)(matrix_size-1) <= conv_std_logic_vector((blur_matrix(matrix_size-2)(matrix_size-2)+blur_matrix(matrix_size-2)(matrix_size-1)+blur_matrix(matrix_size-1)(matrix_size-2)+blur_matrix(matrix_size-1)(matrix_size-1)),12);
		
			blur_comp12:for k in 1 to matrix_size-2 loop
				blur_sum_matrix(0)(k) <= conv_std_logic_vector((blur_matrix(0)(k-1)+blur_matrix(0)(k)+blur_matrix(0)(k+1)+blur_matrix(1)(k-1)+blur_matrix(1)(k)+blur_matrix(1)(k+1)),12);
				blur_sum_matrix(k)(0) <= conv_std_logic_vector((blur_matrix(k-1)(0)+blur_matrix(k-1)(1)+blur_matrix(k)(0)+blur_matrix(k)(1)+blur_matrix(k+1)(0)+blur_matrix(k+1)(1)),12);
				blur_sum_matrix(matrix_size-1)(k) <= conv_std_logic_vector((blur_matrix(matrix_size-2)(k-1)+blur_matrix(matrix_size-2)(k)+blur_matrix(matrix_size-2)(k+1)+blur_matrix(matrix_size-1)(k-1)+blur_matrix(matrix_size-1)(k)+blur_matrix(matrix_size-1)(k+1)),12);
				blur_sum_matrix(k)(matrix_size-1) <= conv_std_logic_vector((blur_matrix(k-1)(matrix_size-2)+blur_matrix(k-1)(matrix_size-1)+blur_matrix(k)(matrix_size-2)+blur_matrix(k)(matrix_size-1)+blur_matrix(k+1)(matrix_size-2)+blur_matrix(k+1)(matrix_size-1)),12);
			end loop blur_comp12;

		end if;
		
	end process;

	blur_comp0: blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(0)(0),
      							blur_mult_regop2 => "001000000000",
							blur_mult_regres => blur_res_matrix(0)(0));

	blur_comp1: blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(0)(matrix_size-1),
      							blur_mult_regop2 => "001000000000",
							blur_mult_regres => blur_res_matrix(0)(matrix_size-1));
	
	blur_comp2: blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(matrix_size-1)(0),
      							blur_mult_regop2 => "001000000000",
							blur_mult_regres => blur_res_matrix(matrix_size-1)(0));

	blur_comp3: blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(matrix_size-1)(matrix_size-1),
      							blur_mult_regop2 => "001000000000",
							blur_mult_regres => blur_res_matrix(matrix_size-1)(matrix_size-1));
 
	blur_comp4: for m in 1 to matrix_size-2 generate
		blur_comp4_m : blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(0)(m),
      							blur_mult_regop2 => "000101000111",
							blur_mult_regres => blur_res_matrix(0)(m));
	end generate blur_comp4;

	blur_comp5: for m in 1 to matrix_size-2 generate
		blur_comp5_m : blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(m)(0),
      							blur_mult_regop2 => "000101000111",
							blur_mult_regres => blur_res_matrix(m)(0));
	end generate blur_comp5;
	
	blur_comp6: for m in 1 to matrix_size-2 generate
		blur_comp6_m : blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(matrix_size-1)(m),
      							blur_mult_regop2 => "000101000111",
							blur_mult_regres => blur_res_matrix(matrix_size-1)(m));
	end generate blur_comp6;

	blur_comp7: for m in 1 to matrix_size-2 generate
		blur_comp7_m : blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(m)(matrix_size-1),
      							blur_mult_regop2 => "000101000111",
							blur_mult_regres => blur_res_matrix(m)(matrix_size-1));
	end generate blur_comp7;

	blur_comp8: for m in 1 to matrix_size-2 generate
		blur_comp9: for n in 1 to matrix_size-2 generate
			blur_com9_m : blur_mult port map (blur_mult_regxnor_value => blur_xnor_value,
							blur_mult_regop1 => blur_sum_matrix(m)(n),
      							blur_mult_regop2 => "000011100001",
							blur_mult_regres => blur_res_matrix(m)(n));
		end generate blur_comp9;
	end generate blur_comp8;
	

	--process
	--variable l: line;
	--file outfile: text open write_mode is "C:\Modeltech_pe_edu_10.4a\examples\output.txt";
	--begin
		--wait for 9999 ns;
		--blur_comp16: for p in 0 to matrix_size-1 loop
			--blur_comp17: for q in 0 to matrix_size-1 loop
				--write(l, blur_res_matrix(p)(q));
				--writeline(outfile, l);
			--end loop blur_comp17;
		--end loop blur_comp16;
	--end process;


end blur_arch;
