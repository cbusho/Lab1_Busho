----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:17:21 01/29/2014 
-- Design Name: 
-- Module Name:    gens - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity h_sync_gen is
    port ( clk       : in  std_logic;
           reset     : in  std_logic;
           h_sync    : out std_logic;
           blank     : out std_logic;
           completed : out std_logic;
           column    : out unsigned(10 downto 0)
     );
end h_sync_gen;

architecture Behavioral of h_sync_gen is

	type state_type is
					(activeVideo, frontPorch, sync, backPorch, completedState);
	signal state_reg, state_next: state_type;
	signal hsync_next, hsync_buf_reg, blank_next, blank_buf_reg, 
			 completed_next, completed_buf_reg: std_logic;
	signal count_reg, count_next, column_next, column_buf_reg: unsigned(10 downto 0);				

begin

-- state register
	process(clk, reset)
	begin
		if (reset = '1') then
			state_reg <= activeVideo;
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;
	
--look ahead output buffer	
	process(clk, reset)
	begin
		if (reset = '1') then
			hsync_buf_reg <= '0';
			blank_buf_reg <= '0';
			completed_buf_reg <= '0';
			column_buf_reg <= "00000000000";
			count_reg <= "00000000000";
		elsif (clk'event and clk = '1') then
			hsync_buf_reg <= hsync_next;
			blank_buf_reg <= blank_next;
			completed_buf_reg <= completed_next;
			column_buf_reg <= column_next;
			count_reg <= count_next;
		end if;
	end process;	
	
-- next state logic
	process(state_reg, count_reg)
	begin
		case state_reg is
			when activeVideo =>
				if count_reg = 640 then
					state_next <= frontPorch;
					count_reg <= "00000000000";
				else
					count_next <= count_reg + "00000000001";
					state_next <= activeVideo;
				end if;	
			when frontPorch =>
				if count_reg = "00000010001" then
					state_next <= sync;
					count_reg <= "00000000000";
				else
					count_next <= count_reg + "00000000001";
					state_next <= frontPorch;
				end if;
			when sync =>
				if count_reg = "00001100000" then
					state_next <= backPorch;
					count_reg <= "00000000000";
				else
					count_next <= count_reg + "00000000001";
					state_next <= sync;
				end if;
			when backPorch =>
				if count_reg = "00000110000" then
					state_next <= completedState;
					count_reg <= "00000000000";
				else
					count_next <= count_reg + "00000000001";
					state_next <= backPorch;
				end if;
			when completedState =>
				state_next <= activeVideo;			
		end case;
	end process;

--look ahead output logic
	process(state_next)
	begin
		hsync_next <= '1';
		blank_next <= '0';
		completed_next <= '0';
		column_next <= "00000000000"; --default value
		case state_next is
			when activeVideo =>
				hsync_next <= '1';
				blank_next <= '0';
				completed_next <= '0';
				column_next <= count_reg;
			when frontPorch =>
				hsync_next <= '1';
				blank_next <= '1';
				completed_next <= '0';
				column_next <= "00000000000";
			when sync =>
				hsync_next <= '0';
				blank_next <= '1';	
				completed_next <= '0';
				column_next <= "00000000000";
			when backPorch =>
				hsync_next <= '1';
				blank_next <= '1';
				completed_next <= '0';
				column_next <= "00000000000";
			when completedState =>
				hsync_next <= '1';
				blank_next <= '1';
				completed_next <= '1';
				column_next <= "00000000000";
		end case;
	end process;

--output 
	completed <= completed_buf_reg;
	h_sync <= hsync_buf_reg;
	blank <= blank_buf_reg;
	column <= column_buf_reg;

end Behavioral;

