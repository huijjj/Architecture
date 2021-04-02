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
   input [1:0] sel;
   input [15:0] i0, i1;
   output reg [15:0] o;

   always @ (*) begin
      case (sel)
         0: o = i0;
         1: o = i1;
      endcase
   end

endmodule