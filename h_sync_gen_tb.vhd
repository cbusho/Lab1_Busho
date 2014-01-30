--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:25:40 01/29/2014
-- Design Name:   
-- Module Name:   C:/Users/C15Colin.Busho/Documents/ECE383/Lab1_Busho/h_sync_gen_tb.vhd
-- Project Name:  Lab1_Busho
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: h_sync_gen
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY h_sync_gen_tb IS
END h_sync_gen_tb;
 
ARCHITECTURE behavior OF h_sync_gen_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT h_sync_gen
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         h_sync : OUT  std_logic;
         blank : OUT  std_logic;
         completed : OUT  std_logic;
         column : OUT  unsigned(10 downto 0)
			
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal h_sync : std_logic;
   signal blank : std_logic;
   signal completed : std_logic;
   signal column : unsigned(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	--type state_type is
	--				(frontPorch, sync, backPorch, completedState, activeVideo);
	--signal state_reg, state_next: state_type;
	--signal hsync_next, hsync_buf_reg, blank_next, blank_buf_reg, 
	--		 completed_next, completed_buf_reg: std_logic;
	--signal count_reg, count_next, column_next, column_buf_reg: unsigned(10 downto 0);	
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: h_sync_gen PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync,
          blank => blank,
          completed => completed,
          column => column
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for 100 ns;
		
      reset <= '1';
		wait for 100 ns;	

      --wait for clk_period*10;

		reset <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;