module Quantization_POOL_Top(
    input clk, rst_n,

    // Quantization needed ports
    input start1, start2, start3, start4,                       // from FSM
    input load_bias1, load_bias2, load_bias3, load_bias4,       // from FSM
    input load_M1, load_M2, load_M3, load_M4,                   // from FSM
    input load_sh,                                              // from FSM
    input signed [31:0] bias_in,                                // from SRAM
    input signed [31:0] M_in,                                   // from SRAM
    input [31:0] sh_in,                                         // from SRAM
    input signed [91:0] c_out_col_stream_flat,                  // from SA

    // POOL needed ports
    input         shift_en,                                     // from FSM
    input         en1, en2, en3, en4,                           // from FSM
    output        POOL_REG_full,                                // to FSM
    output        POOL_REG_empty,
    output signed [7:0] cut1, cut2, cut3, cut4,                 // to monitor the output of Quantization   
    output signed [31:0] data_to_sram                           // to SRAM
);

Quantization_Top uQNT(
    .clk(clk), .rst_n(rst_n),
    .start1(start1), .start2(start2), .start3(start3), .start4(start4),
    .load_bias1(load_bias1), .load_bias2(load_bias2), .load_bias3(load_bias3), .load_bias4(load_bias4),
    .load_M1(load_M1), .load_M2(load_M2), .load_M3(load_M3), .load_M4(load_M4),
    .load_sh(load_sh), .bias_in(bias_in), .M_in(M_in), .sh_in(sh_in),
    .c_out_col_stream_flat(c_out_col_stream_flat),
    .cut1(cut1), .cut2(cut2), .cut3(cut3), .cut4(cut4)
);

POOL_pipeline_Top uPOOL(
    .clk(clk), .rst_n(rst_n),
    .shift_en(shift_en),
    .cut1(cut1), .cut2(cut2), .cut3(cut3), .cut4(cut4),
    .en1(en1), .en2(en2), .en3(en3), .en4(en4),
    .POOL_REG_full(POOL_REG_full), .POOL_REG_empty(POOL_REG_empty), .data_to_sram(data_to_sram)
);

endmodule
