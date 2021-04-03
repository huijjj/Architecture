module mux4_1 (sel, i1, i2, i3, i4, o);
   input [1:0] sel;
   input [15:0] i0, i1, i2, i3;
   output reg [15:0] o;

   always @ (*) begin
      case (sel)
         0: o = i0;
         1: o = i1;
         2: o = i2;
         3: o = i3;
      endcase
   end

endmodule


module mux2_1 (sel, i1, i2, o);
   input sel;
   input [15:0] i0, i1;
   output reg [15:0] o;

   always @ (*) begin
      case (sel)
         0: o = i0;
         1: o = i1;
      endcase
   end

endmodule

module sign_extender(in, out);
	input [7:0]in;
	output [15:0] out;

	assign out[7:0] = in[7:0];
	assign out[8] = in[7];
	assign out[9] = in[7];
	assign out[10] = in[7];
	assign out[11] = in[7];
	assign out[12] = in[7];
	assign out[13] = in[7];
	assign out[14] = in[7];
	assign out[15] = in[7];
endmodule

module make_address(pc, instruction, addr);
	input [15:0] pc;
	input [15:0] instruction;
	output [15:0] addr;
	assign addr[15:12] = pc[15:12];
	assign addr[11:0] = instruction[11:0];
endmodule