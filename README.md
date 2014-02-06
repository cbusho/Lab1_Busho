Lab1_Busho
==========

## Introduction
Created a VGA driver for a computer monitor using an FPGA and VHDL code

## Implementation
- Used D Flip Flops for next state, current state, count, output buffers, and next output buffers
in the H sync and V sync modules

  - This is an example of a D Flip Flop

``` VHDL
-- state register
	process(clk, reset)
	begin
		if (reset = '1') then
			state_reg <= activeVideo;
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;
```

- Connected the h and v sync modules in the VGA sync module

  - This is an example of a module instantiated in another module.
   
``` VHDL
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

begin

Inst_h_sync_gen: h_sync_gen PORT MAP(
		clk => clk,
		reset => reset,
		h_sync => h_sync,
		blank => h_blank,
		completed => h_completed_sig,
		column => column 
	);
```

- Connected the VGA and pixel gen modules in the top (atlys) shell

- Block Diagram 

![alt text](Block%20Diagram.png "Block Diagram")

- H_sync state diagram

![alt text](Hsync%20State%20Diagram.png "H_Sync")

- V_sync state diagram

![alt text](Vsync%20State%20Diagram.png "V_Sync")

## Test/Debug

- `h and v sync functionality`
  - Created a test bench for each.
  - Measured state lengths and signals upon state transitions
  - In V sync test bench included an h sync module for h_completed signal
  - Compared output signals to working code to ensure functionality
  
- `pixel gen functionality`
  - Made the pixel gen only display red to ensure functionality at first
  
- `synthesizer` 
  - For reasons unknown optimization preferences can make your entire project not work
  - (used area optimization not speed optimization)
  
## Conclusion
I learned that creating good VHDL code is very different than TPL code. Making sure that students
start by creating D flip flops instead of whatever they please and to really stick to the moore
or mealy designs saves a lot of headaches. This is to ensure that the synthesizer can create your
code on the FPGA. I also learned how important it is to use testbenches under controlled circumstances.
I thought my v_sync was working for the longest time because I was testing it with a constant h completed
signal turned on. When I implemented my h sync module it became clear that the vsync was the problem. It is
also helpful to write out a state transition diagram so you can keep track of your thoughts while programming.
