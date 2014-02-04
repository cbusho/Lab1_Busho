----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:37:22 02/04/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pixel_gen is
    Port ( row : in  unsigned (10 downto 0);
           column : in  unsigned (10 downto 0);
           blank : in  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end pixel_gen;

architecture Behavioral of pixel_gen is

	type color_type is
					(black, blue, green, red, yellow);
	signal color: color_type;				

begin
	
	process(blank, column, row)
	begin
		if (blank = '1') then
			color <= black;
		elsif (row >= 426) then
			color <= yellow;
		elsif (column <= 213) then
			color <= red;
		elsif (column <= 426) then
			color <= green;
		else 
			color <= blue;
		end if;	
	end process;	
	
	process(color)
	begin
		r <= "00000000";
		g <= "00000000";
		b <= "00000000";
		case color is
			when black =>
				r <= "00000000";
				g <= "00000000";
				b <= "00000000";
			when blue =>
				r <= "00000000";
				g <= "00000000";
				b <= "11111111";
			when green =>
				r <= "00000000";
				g <= "11111111";
				b <= "00000000";
			when red=>
				r <= "11111111";
				g <= "00000000";
				b <= "00000000";
			when yellow =>
				r <= "00000000";
				g <= "11111111";
				b <= "11111111";	
			end case;	
		end process;
		
end Behavioral;

--architecture red of pixel_gen is
--begin
--	r <= (others => '1') when blank = '0' else
--			(others => '0');
--	g <= (others => '0');
--	b <= (others => '0');
--end red;