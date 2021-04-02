module mux4_1 (sel, i1, i2, i3, i4, o);
   input [1:0] sel;
   input [15:0] i1, i2, i3, i4;
   output reg [15:0] o;

   always @ (*) begin
      case (sel)
         0: o = i1;
         1: o = i2;
         2: o = i3;
         3: o = i4;
      endcase
   end

endmodule


module mux2_1 (sel, i1, i2, o);
   input [1:0] sel;
   input [15:0] i1, i2;
   output reg [15:0] o;

   always @ (*) begin
      case (sel)
         0: o = i1;
         1: o = i2;
      endcase
   end

endmodule