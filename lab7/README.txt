You can test the functionality of implemented DMA by adding waveforms of outputs of memory below.

	- dma_test_0; // Memory[17]
	- dma_test_1; // Memory[18]
	- dma_test_2; // Memory[19]
	- dma_test_3; // Memory[1a]
	- dma_test_4; // Memory[1b]
	- dma_test_5; // Memory[1c]
	- dma_test_6; // Memory[1d]
	- dma_test_7; // Memory[1e]
	- dma_test_8; // Memory[1f]
	- dma_test_9; // Memory[20]
	- dma_test_10; // Memory[21]
	- dma_test_11; // Memory[22]

Note that each wire corresponds to word size memory location starting from Memory[16'h17] to Memory[16'h22].


Additionally, you can add waveforms of wires below to check the signals between modules.

    + interrupts to CPU
        - dma_interrupt // interrupt from DMA controller to CPU
        - ed_interrupt // interrupt from external device to CPU
    
    + signals & data transfer between CPU and DMA controller
        - bus_request // bus ownership request from DMA controller
        - bus_granted // signal from CPU that tells DMA controller that the requested ownership is granted
        - dma_start // signal from CPU which initiates DMA operation
        - length // length of the data to write while DMA operation

    + signal & data transfer between DMA controller and external device
        - use_bus // signal that tells external device to use data bus
        - idx // data about index of data to write at memory
    
Please refer to the report for further information. 