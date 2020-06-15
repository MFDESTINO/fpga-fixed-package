LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

package fixed_package is
	constant	MAX_IND	: integer := 15;
	constant MIN_IND : integer := -15;
		
	subtype	fixed_range	is	integer range MAX_IND downto MIN_IND;
	type fixed is array (integer range <>) of bit;
	
	function to_fixed (arg: integer; 
	          max_range: fixed_range := MAX_IND; 
				 min_range: fixed_range := 0) return fixed; 
	
	function to_fixed (arg: real; 
	          max_range: fixed_range; 
				 min_range: fixed_range) return fixed; 
				 
	function to_integer (arg: fixed) return integer;
	function to_real (arg: fixed) return real;
	
end fixed_package;

package body fixed_package is
	
	--integer to fixed
	function to_fixed (arg: integer; 
	          max_range: fixed_range := MAX_IND; 
				 min_range: fixed_range := 0) return fixed is
	
	variable i   : integer := min_range;
	variable fix : fixed (max_range downto min_range);
	variable int : integer := arg * 2 ** (-(min_range));
	variable len : integer := max_range + (-(min_range));
	variable sig : std_logic_vector (len downto 0) := std_logic_vector(to_signed(int, len+1));
	
	begin
			assert(len < MAX_IND + 1) report "out of range" severity error;
			
			escreve_bit_a_bit: while (i <= max_range) loop
			fix(i) := to_bit(sig(i+(-min_range)));
			i := i+1;
			end loop;
			
			return fix;
	end to_fixed;
	
	
	--real to fixed
	function to_fixed (arg: real; 
	          max_range: fixed_range; 
				 min_range: fixed_range) return fixed is
	
	variable i   : integer := min_range;
	variable fix : fixed (max_range downto min_range);
	variable int : integer := integer(arg * real(2 ** (-(min_range))));
	variable len : integer := max_range + (-(min_range));
	variable sig : std_logic_vector (len downto 0) := std_logic_vector(to_signed(int, len+1));
	
	begin
			assert(len < MAX_IND + 1) report "out of range" severity error;
			
			escreve_bit_a_bit: while (i <= max_range) loop
			fix(i) := to_bit(sig(i+(-min_range)));
			i := i+1;
			end loop;
			
			return fix;
	end to_fixed;
	
	
	--fixed to integer
	function to_integer (arg: fixed) return integer is
	
	variable max_range : integer := arg'high;
	variable min_range : integer := arg'low;
	variable i         : integer := min_range;
	variable int       : integer := 0;
	variable len       : integer := max_range + (-(min_range));
	variable sig       : std_logic_vector (len downto 0);
	
	begin
			escreve_bit_a_bit: while (i <= max_range) loop
			sig(i+(-min_range)) := to_stdulogic(arg(i));
			i := i+1;
			end loop;
			int := to_integer(signed(sig)) / 2 ** (-(min_range));
			return int;
	end to_integer;
	
	
	--fixed to real
	function to_real (arg: fixed) return real is
	
	variable max_range : integer := arg'high;
	variable min_range : integer := arg'low;
	variable i         : integer := min_range;
	variable r         : real;
	variable len       : integer := max_range + (-(min_range));
	variable sig       : std_logic_vector (len downto 0);
	
	begin
			escreve_bit_a_bit: while (i <= max_range) loop
			sig(i+(-min_range)) := to_stdulogic(arg(i));
			i := i+1;
			end loop;
			r := real(to_integer(signed(sig))) / real(2 ** (-(min_range)));
			
			return r;
	end to_real;
	
end fixed_package;