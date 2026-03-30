module Quantization_Top(
    input clk, rst_n,
    
    // triggered by its owm layer's finish signal by 2 cycles delay.
    input start1, start2, start3, start4,

    // bias 32 bits, only one bias_in is loaded at a cycle; same M.
    input load_bias1, load_bias2, load_bias3, load_bias4,
    input load_M1, load_M2, load_M3, load_M4,

    // sh1, sh2, sh3, sh4 are 8 bits, can loaded all of them at a same cycle as 32 bits.
    input load_sh,

    input signed [31:0] bias_in,
    input signed [31:0] M_in,

    // sh_in 32 bits [31:24] is sh_in1, [23:16] is sh_in2, ...
    input [31:0] sh_in,

    input signed [91:0] c_out_col_stream_flat,
    output signed [7:0] cut1, cut2, cut3, cut4
);

Quantization_PE u_QPE1(
    .clk(clk), .rst_n(rst_n), .start(start1),
    .load_bias(load_bias1), .load_M(load_M1), .load_sh(load_sh),
    .bias_in(bias_in), .M_in(M_in), .sh_in(sh_in[31:24]),
    .rso(c_out_col_stream_flat[91:69]), .cut(cut1)
);

Quantization_PE u_QPE2(
    .clk(clk), .rst_n(rst_n), .start(start2),
    .load_bias(load_bias2), .load_M(load_M2), .load_sh(load_sh),
    .bias_in(bias_in), .M_in(M_in), .sh_in(sh_in[23:16]),
    .rso(c_out_col_stream_flat[68:46]), .cut(cut2)
);

Quantization_PE u_QPE3(
    .clk(clk), .rst_n(rst_n), .start(start3),
    .load_bias(load_bias3), .load_M(load_M3), .load_sh(load_sh),
    .bias_in(bias_in), .M_in(M_in), .sh_in(sh_in[15:8]),
    .rso(c_out_col_stream_flat[45:23]), .cut(cut3)
);

Quantization_PE u_QPE4(
    .clk(clk), .rst_n(rst_n), .start(start4),
    .load_bias(load_bias4), .load_M(load_M4), .load_sh(load_sh),
    .bias_in(bias_in), .M_in(M_in), .sh_in(sh_in[7:0]),
    .rso(c_out_col_stream_flat[22:0]), .cut(cut4)
);

endmodule