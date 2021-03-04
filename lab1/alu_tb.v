/*
 [CSED311-2021] ALU testbench
  Modified by Sungjun Cho
*/

`include "alu.v"
`include "alu_func.v"

`timescale 100ps / 100ps

`define data_width 16

module ALU_tb;

reg [15:0] Passed;
reg [15:0] Failed;

reg [`data_width-1:0] A;
reg [`data_width-1:0] B;
reg [3:0] FuncCode;
wire [`data_width-1:0] C;
wire OverflowFlag;

// Unit Under Test Port Mapping
ALU alu(
	.A(A),
	.B(B),	
	.FuncCode(FuncCode),
	.C(C),
	.OverflowFlag(OverflowFlag)
);

initial begin
	Passed = 0;
	Failed = 0;

	ALUTest;

	$display("Passed = %0d, Failed = %0d", Passed, Failed);
	$finish;
end

task ALUTest;
begin
	AddTest;
	SubTest;
	IdTest;
	NotTest;
	AndTest;
	OrTest;
	NandTest;
	NorTest;
	XorTest;
	XnorTest;
	LlsTest;
	LrsTest;
	AlsTest;
	ArsTest;
	TcpTest;
	ZeroTest;
end
endtask

task AddTest;
begin
	FuncCode = `FUNC_ADD;

	Test("ADD-1", 16'h0001, 16'h0001, 16'h0002, 0);
	Test("ADD-2", 16'hffff, 16'h0001, 0, 0);
	Test("ADD-3", 16'h7fff, 16'h0005, 16'h8004, 1);	
	Test("ADD-4", 16'h8000, 16'h8001, 16'h0001, 1);	
	Test("ADD-5", 16'h0fff, 16'h0001, 16'h1000, 0);
	Test("ADD-6", 16'h7fff, 16'h0001, 16'h8000, 1);	
end
endtask

task SubTest;
begin
	FuncCode = `FUNC_SUB;

	Test("SUB-1", 0, 0, 0, 0);
	Test("SUB-2", 16'h0003, 16'h0001, 16'h0002, 0);
	Test("SUB-3", 16'hffff, 16'h8001, 16'h7ffe, 0);
	Test("SUB-4", 16'h7fff, 16'hffff, 16'h8000, 1);
	Test("SUB-5", 16'h0002, 16'h0003, 16'hffff, 0);
end
endtask

task IdTest;
begin
	FuncCode = `FUNC_ID;

	Test("ID-1", 0, 0, 0, 0);
	Test("ID-2", 16'habcd, 0, 16'habcd, 0);
end
endtask

task NotTest;
begin
	FuncCode = `FUNC_NOT;

	Test("NOT-1", 16'hffff, 0, 16'h0000, 0);
	Test("NOT-2", 16'h0800, 0, 16'hf7ff, 0);
end
endtask

task AndTest;
begin
	FuncCode = `FUNC_AND;

	Test("And-1", {4{4'b0011}}, {4{4'b0101}}, {4{4'b0001}}, 0);
	Test("And-2", {4{4'b1100}}, {4{4'b0101}}, {4{4'b0100}}, 0);
end
endtask

task OrTest;
begin
	FuncCode = `FUNC_OR;

	Test("Or-1", {4{4'b0011}}, {4{4'b0101}}, {4{4'b0111}}, 0);
	Test("Or-2", {4{4'b1100}}, {4{4'b0101}}, {4{4'b1101}}, 0);
end
endtask

task NandTest;
begin
	FuncCode = `FUNC_NAND;

	Test("Nand-1", {4{4'b0011}}, {4{4'b0101}}, {4{4'b1110}}, 0);
	Test("Nand-2", {4{4'b1100}}, {4{4'b0101}}, {4{4'b1011}}, 0);
end
endtask

task NorTest;
begin
	FuncCode = `FUNC_NOR;

	Test("NOR-1", {4{4'b0011}}, {4{4'b0101}}, {4{4'b1000}}, 0);
	Test("NOR-2", {4{4'b1100}}, {4{4'b0101}}, {4{4'b0010}}, 0);
end
endtask

task XorTest;
begin
	FuncCode = `FUNC_XOR;

	Test("XOR-1", {4{4'b0011}}, {4{4'b0101}}, {4{4'b0110}}, 0);
	Test("XOR-2", {4{4'b1100}}, {4{4'b0101}}, {4{4'b1001}}, 0);
end
endtask

task XnorTest;
begin
	FuncCode = `FUNC_XNOR;

	Test("XNOR-1", {4{4'b0011}}, {4{4'b0101}}, {4{4'b1001}}, 0);
	Test("XNOR-2", {4{4'b1100}}, {4{4'b0101}}, {4{4'b0110}}, 0);
end
endtask

task LlsTest;
begin
	FuncCode = `FUNC_LLS;

	Test("LLS-1", 16'h0800, 0, 16'h1000, 0);
	Test("LLS-2", 16'h8000, 0, 16'h0000, 0);
end
endtask

task LrsTest;
begin
	FuncCode = `FUNC_LRS;

	Test("LRS-1", 16'h0800, 0, 16'h0400, 0);
	Test("LRS-2", 16'h8000, 0, 16'h4000, 0);
	Test("LRS-3", 16'hf001, 0, 16'h7800, 0);
end
endtask

task AlsTest;
begin
	FuncCode = `FUNC_ALS;

	Test("ALS-1", 16'h0800, 0, 16'h1000, 0); 
	Test("ALS-2", 16'h8000, 0, 16'h0000, 0);
end
endtask

task ArsTest;
begin
	FuncCode = `FUNC_ARS;

	Test("ARS-1", 16'h0800, 0, 16'h0400, 0);
	Test("ARS-2", 16'h8000, 0, 16'hc000, 0);
	Test("ARS-3", 16'hf001, 0, 16'hf800, 0);
end
endtask

task TcpTest;
begin
	FuncCode = `FUNC_TCP;

	Test("TCP-1", 16'hffff, 0, 16'h0001, 0);
	Test("TCP-2", 16'h0800, 0, 16'hf800, 0);
	Test("TCP-3", 16'hf0f1, 0, 16'h0f0f, 0);
end
endtask

task ZeroTest;
begin
	FuncCode = `FUNC_ZERO;

	Test("ZERO-1", 0, 0, 0, 0);
	Test("ZERO-2", 16'habcd, 0, 0, 0);
end
endtask

task Test;
	input [16 * 8 : 0] Testname;
	input [`data_width-1:0] A_;
	input [`data_width-1:0] B_;
	input [`data_width-1:0] C_expected;
	input OF_expected;  

begin
	$display("TEST %s :", Testname);
	A = A_;
	B = B_;
	#1;

	if (C == C_expected && OverflowFlag == OF_expected)
		begin
			$display("PASSED");
			Passed = Passed + 1;
		end
	else
		begin
			$display("FAILED");
			$display("A = %0h, B = %0h, C = %0h (Ans : %0h), OF = %0b (Ans : %0b)", A_, B_, C, C_expected, OverflowFlag, OF_expected);
			Failed = Failed + 1;
		end
end
endtask

endmodule
