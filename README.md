Lab1_Busho
==========

## Introduction
Created a VGA driver for a computer monitor using an FPGA and VHDL code

## Implementation
Used D Flip Flops for next state, current state, count, output buffers, and next output buffers
in the H sync and V sync modules
Connected the h and v sync modules in the VGA sync module
Connected the VGA and pixel gen modules in the top (atlys) shell

State Transition Diagram in prelab

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
  - (used area optimization)
  
## Conclusion
I learned that creating good VHDL code is very different than TPL code. Making sure that students
start by creating D flip flops instead of whatever they please and to really stick to the moore
or mealy designs saves a lot of headaches. This is to ensure that the synthesizer can create your
code on the FPGA. I also learned how important it is to use testbenches under controlled circumstances.
I thought my v_sync was working for the longest time because I was testing it with a constant h completed
signal turned on. When I implemented my h sync module it became clear that the vsync was the problem. It is
also helpful to write out a state transition diagram so you can keep track of your thoughts while programming.
