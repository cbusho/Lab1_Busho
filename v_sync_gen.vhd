----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:49:51 01/31/2014 
-- Design Name: 
-- Module Name:    v_sync_gen - Behavioral 
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

entity v_sync_gen is
    port ( clk       : in  std_logic;
           reset     : in  std_logic;
			  h_completed : in std_logic;
           v_sync    : out std_logic;
           blank     : out std_logic;
           completed : out std_logic;
           row    : out unsigned(10 downto 0)
     );
end v_sync_gen;

architecture Behavioral of v_sync_gen is

	type state_type is
					(activeVideo, frontPorch, sync, backPorch, completedState);
	signal state_reg, state_next: state_type;
	signal vsync_next, vsync_buf_reg, blank_next, blank_buf_reg, 
			 completed_next, completed_buf_reg: std_logic;
	signal count_reg, count_next, row_next, row_buf_reg: unsigned(10 downto 0);				

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
			vsync_buf_reg <= '0';
			blank_buf_reg <= '0';
			completed_buf_reg <= '0';
			row_buf_reg <= "00000000000";
		elsif (clk'event and clk = '1') then
			vsync_buf_reg <= vsync_next;
			blank_buf_reg <= blank_next;
			completed_buf_reg <= completed_next;
			row_buf_reg <= row_next;
		end if;
	end process;	
	
-- count logic
	process(clk, reset)
	begin
		if (reset = '1') then
			count_reg <= (others => '0');
		elsif (clk'event and clk = '1') then
			count_reg <= count_next;
		end if;
	end process;	
	
	count_next <= 	(others => '0') when (state_reg /= state_next) else
						count_reg + 1 when h_completed = '1' else
						count_reg;
	
-- next state logic
	process(state_reg, count_reg)
	begin
		state_next <= activeVideo;
		case state_reg is
			when activeVideo =>
				if count_reg = "00111100000" then
					state_next <= frontPorch;
				else
					state_next <= activeVideo;
				end if;
			when frontPorch =>
				if count_reg = "00000001010" then
					state_next <= sync;
				else
					state_next <= frontPorch;
				end if;
			when sync =>
				if count_reg = "00000000010" then
					state_next <= backPorch;
				else
					state_next <= sync;
				end if;
			when backPorch =>
				if count_reg = "00000100001" then
					state_next <= completedState;
				else
					state_next <= backPorch;
				end if;
			when completedState =>
				state_next <= activeVideo;			
		end case;
	end process;

--look ahead output logic
	process(state_next, count_reg)
	begin
		vsync_next <= '1';
		blank_next <= '0';
		completed_next <= '0';
		row_next <= "00000000000"; --default value
		case state_next is
			when activeVideo =>
				vsync_next <= '1';
				blank_next <= '0';
				completed_next <= '0';
				row_next <= count_reg;
			when frontPorch =>
				vsync_next <= '1';
				blank_next <= '1';
				completed_next <= '0';
				row_next <= "00000000000";
			when sync =>
				vsync_next <= '0';
				blank_next <= '1';	
				completed_next <= '0';
				row_next <= "00000000000";
			when backPorch =>
				vsync_next <= '1';
				blank_next <= '1';
				completed_next <= '0';
				row_next <= "00000000000";
			when completedState =>
				vsync_next <= '1';
				blank_next <= '1';
				completed_next <= '1';
				row_next <= "00000000000";
		end case;
	end process;

--output 
	completed <= completed_buf_reg;
	v_sync <= vsync_buf_reg;
	blank <= blank_buf_reg;
	row <= row_buf_reg;

end Behavioral;



