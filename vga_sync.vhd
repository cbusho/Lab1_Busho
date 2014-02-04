----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:28:04 01/31/2014 
-- Design Name: 
-- Module Name:    vga_sync - Structural 
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

entity vga_sync is
	port (  clk         : in  std_logic;
           reset       : in  std_logic;
           h_sync      : out std_logic;
           v_sync      : out std_logic;
           v_completed : out std_logic;
           blank       : out std_logic;
           row         : out unsigned(10 downto 0);
           column      : out unsigned(10 downto 0)
     );

end vga_sync;

architecture Structural of vga_sync is

COMPONENT h_sync_gen
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		h_sync : OUT std_logic;
		blank : OUT std_logic;
		completed : OUT std_logic;
		column : OUT unsigned(10 downto 0)
		);
	END COMPONENT;

COMPONENT v_sync_gen
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		h_completed  : IN std_logic;
		v_sync : OUT std_logic;
		blank : OUT std_logic;
		completed : OUT std_logic;
		row : OUT unsigned(10 downto 0)
		);
	END COMPONENT;

Signal h_completed_sig, h_blank, v_blank: std_logic;

begin

Inst_h_sync_gen: h_sync_gen PORT MAP(
		clk => clk,
		reset => reset,
		h_sync => h_sync,
		blank => h_blank,
		completed => h_completed_sig,
		column => column 
	);

Inst_v_sync_gen: v_sync_gen PORT MAP(
		clk => clk,
		reset => reset,
		h_completed => h_completed_sig,
		v_sync => v_sync,
		blank => v_blank,
		completed => v_completed,
		row => row
	);
	
	blank <= '0' when (v_blank = '0' and h_blank = '0')
					 else '1';
	
end Structural;

	

	