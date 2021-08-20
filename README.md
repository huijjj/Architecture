# Architecture
POSTECH CSED311 Computer Architecture lab verilog files

**USE WITH CAUTION, COPYING CODES FROM THIS REPOSITORY MIGHT CAUSE F IN YOUR GRADE** 

# Contents
    Lab1: ALU
    Lab2: FSM(vending machine)
    Lab3: Single-Cycle CPU
    Lab4: Multi-Cycle CPU
    Lab5: Pipelined CPU
    Lab6: Cache
    Lab7: DMA
    
# Detail


**ALWAYS REMEMBER TO 'THINK' BEFORE CODING**


+ **Lab1**

    Implementing ALU in verilog (Difficulty: ★☆☆☆☆, 2h)
    
    Just a warm up lab to get familiar with verilog. Might take few more minutes if you don't know what ALU is.
    
    
+ **Lab2**

    Implementing simple FSM(Finite State Machine) in verilog (Difficulty:  ★☆☆☆☆, 2h)
    
    If you know what FSM is and how to design it, this lab won't be hard too.
    
    
+ **Lab3**

    Implementing Single-Cycle CPU(CPU which processes every instruction within a single cycle) (Difficulty:  ★★★☆☆, 12h)
    
    You'll have to implement fully funtional CPU which can process almost every instruction in TSC instruction set architectire. 
    Reading TSC manual carefully and drawing the blueprint of your CPU before you start to code will save you a lot of time. 
    When drawing blueprint of your CPU, you should focus on the data flow(path of the data), actually this course is all about data path and control.


+ **Lab4**

    Implementing Multi-Cycle CPU(CPU which has variable latency for instruction) in verilog (Difficulty:  ★★★★☆, 24h)
    
    It is easier to build a new CPU rather than modifying codes from the previous lab(Lab3: Single-Cycle CPU).
    Break your instruction processing into stages and check which instruction needs which before you start coding this will save you decent amount of time.
    Designing a FSM for control signal will make your implmentation easy.
    
+ **Lab5**

    Implementing Pipelined CPU(CPU with increased throughput by fully utilizing the processing resources) in verilog (Difficulty:  ★★★★★, 36h)
    
    Highlight of this course. Branching predicting and Halting/Flushing logic might take your time. But remember that this is not something special.
    Halting is just not updating your registers(pipeline registers not register file) and keeping the old value, 
    and Flushing is just turning off all the control signal(register write, memory write) so that this has no effect(making a instruction nop).
    As always drawing blueprint of your CPU will help you a lot. Especially for this lab, I'm pretty sure you won't be able to carry on without it.
    And please, DON'T GIVE UP. You need fully functional pipelined CPU codes for later labs(lab6 and lab7, you have to implement some memory features on top of the pipelined CPU).
    
    
+ **Lab6**

    Implementing simple cache in verilog (Difficulty:  ★★★☆☆, 12h)
    
    Write through with Write no allocate policy is the easiest implementation. 
    Selecting between Unified or Seperate cache(I-cache and D-cache) is up to you (my codes have seperate cache).
    Actually, cache implementation itself will be very easy but attaching cache to your CPU is a different problem. 
    You will need additional logics to control cache
    
    
+ **Lab7**

    Implementing DMA(Direct Memory Access) in verilog (Difficulty:  ★★☆☆☆, 10h)
    
    Just choose the proper cycle to initiate the DMA action. This will ease your debugging.
    
