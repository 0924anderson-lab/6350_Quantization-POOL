// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_PE_to_PING;

    // DUT I/O
    reg         clk, rst_n;
    reg         load_bias1, load_bias2, load_bias3, load_bias4;
    reg         load_M1, load_M2, load_M3, load_M4;
    reg         load_sh;
    reg         start1, start2, start3, start4;
    reg  signed [22:0] rs [0:63];
    reg  signed [91:0] c_out_col_stream_flat;
    reg  signed [31:0] bias_in;
    reg  signed [31:0] M_in;
    reg  [31:0]        sh_in;
  
    // POOL needed ports
    reg         shift_en;                                     // from FSM
    reg         en1, en2, en3, en4;                           // from FSM
    wire        POOL_REG_full;
    wire        POOL_REG_empty;
    wire signed [31:0] data_to_sram; 
  
  	wire signed [7:0] cut1, cut2, cut3, cut4;

    // DUT
    Quantization_POOL_Top dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .start1 (start1),
        .start2 (start2),
        .start3 (start3),
        .start4 (start4),
        .load_bias1(load_bias1),
        .load_bias2(load_bias2),
        .load_bias3(load_bias3),
        .load_bias4(load_bias4),
        .load_M1(load_M1),
        .load_M2(load_M2),
        .load_M3(load_M3),
        .load_M4(load_M4),
        .load_sh(load_sh),
        .bias_in(bias_in),
        .M_in   (M_in),
        .sh_in  (sh_in),
        .c_out_col_stream_flat (c_out_col_stream_flat),
        .shift_en(shift_en),
        .en1(en1), 
        .en2(en2),
        .en3(en3), 
        .en4(en4),
     	.cut1(cut1),
     	.cut2(cut2),
     	.cut3(cut3),
     	.cut4(cut4),
        .POOL_REG_full(POOL_REG_full),
        .POOL_REG_empty(POOL_REG_empty),
        .data_to_sram(data_to_sram) 	
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk;

    // main stimulus
    initial begin
        $dumpfile("quant_top_tb.vcd");
        $dumpvars(0, tb_PE_to_PING);
      
        // rs[] init
        rs[0]  = -23'sd1948;
        rs[1]  =  23'sd1906;
        rs[2]  =  23'sd2062;
        rs[3]  =  23'sd2344;
        rs[4]  =  23'sd2419;
        rs[5]  =  23'sd3136;
        rs[6]  =  23'sd3987;
        rs[7]  =  23'sd5107;
        rs[8]  =  23'sd5480;
        rs[9]  =  23'sd5205;
        rs[10] =  23'sd5201;
        rs[11] =  23'sd5061;
        rs[12] =  23'sd3018;
        rs[13] =  23'sd4770;
        rs[14] =  23'sd3649;
        rs[15] =  23'sd1530;

        rs[16] =  23'sd7104;
        rs[17] =  23'sd7102;
        rs[18] =  23'sd7221;
        rs[19] =  23'sd7221;
        rs[20] =  23'sd7221;
        rs[21] =  23'sd7221;
        rs[22] =  23'sd7174;
        rs[23] =  23'sd7128;
        rs[24] =  23'sd7330;
        rs[25] =  23'sd7517;
        rs[26] =  23'sd7456;
        rs[27] =  23'sd7454;
        rs[28] =  23'sd7573;
        rs[29] =  23'sd7573;
        rs[30] =  23'sd7573;
        rs[31] =  23'sd7700;

        rs[32] =  23'sd42991;
        rs[33] =  23'sd43198;
        rs[34] =  23'sd43298;
        rs[35] =  23'sd43298;
        rs[36] =  23'sd43298;
        rs[37] =  23'sd43298;
        rs[38] =  23'sd43414;
        rs[39] =  23'sd43643;
        rs[40] =  23'sd43843;
        rs[41] =  23'sd43926;
        rs[42] =  23'sd44057;
        rs[43] =  23'sd44264;
        rs[44] =  23'sd44364;
        rs[45] =  23'sd44364;
        rs[46] =  23'sd44364;
        rs[47] =  23'sd44375;

        rs[48] =  23'sd3315;
        rs[49] =  23'sd3462;
        rs[50] =  23'sd3406;
        rs[51] =  23'sd3406;
        rs[52] =  23'sd3406;
        rs[53] =  23'sd3406;
        rs[54] =  23'sd3249;
        rs[55] =  23'sd3226;
        rs[56] =  23'sd3307;
        rs[57] =  23'sd3317;
        rs[58] =  23'sd3321;
        rs[59] =  23'sd3468;
        rs[60] =  23'sd3412;
        rs[61] =  23'sd3412;
        rs[62] =  23'sd3412;
        rs[63] =  23'sd3399;

        // init
        rst_n      = 0;
        load_bias1 = 0; load_bias2 = 0; load_bias3 = 0; load_bias4 = 0;
        load_M1    = 0; load_M2    = 0; load_M3    = 0; load_M4    = 0;
        load_sh    = 0;
        start1     = 0; start2     = 0; start3     = 0; start4     = 0;
        shift_en   = 0;
        en1 = 0; en2 = 0; en3 = 0; en4 = 0;
        bias_in = 32'sd0;
        M_in    = 32'sd0;
        sh_in   = 32'd0;
        c_out_col_stream_flat = 92'sd0;

        // release reset
        #12; rst_n = 1;

        // preload bias
        @(posedge clk); #0.1;
        bias_in    <= 32'sd0; load_bias1 <= 1;
        @(posedge clk); #0.1;
        load_bias1 <= 0;      load_bias2 <= 1;
        @(posedge clk); #0.1;
        load_bias2 <= 0;      load_bias3 <= 1;
        @(posedge clk); #0.1;
        load_bias3 <= 0;      load_bias4 <= 1;
        @(posedge clk); #0.1;
        load_bias4 <= 0;

        // preload M
        @(posedge clk); #0.1;
        M_in   <= 32'sd1230262076; load_M1 <= 1;
        @(posedge clk); #0.1;
        M_in   <= 32'sd1645224366; load_M1 <= 0; load_M2 <= 1;
        @(posedge clk); #0.1;
        M_in   <= 32'sd1406818753; load_M2 <= 0; load_M3 <= 1;
        @(posedge clk); #0.1;
        M_in   <= 32'sd1609331065; load_M3 <= 0; load_M4 <= 1;
        @(posedge clk); #0.1;
        load_M4 <= 0;

        // preload sh
        @(posedge clk); #0.1;
        sh_in[31:24] <= 8'd39;
        sh_in[23:16] <= 8'd40;
        sh_in[15:8]  <= 8'd39;
        sh_in[7:0]   <= 8'd40;
        load_sh      <= 1;
        @(posedge clk); #0.1;
        load_sh      <= 0;

        // ===== systolic pattern =====

        @(posedge clk);  // t0
      	#0.1
        c_out_col_stream_flat <= { rs[0], 23'sd0, 23'sd0, 23'sd0 };

        @(posedge clk);  // t1
      	#0.1
        c_out_col_stream_flat <= { rs[1], rs[16], 23'sd0, 23'sd0 };
        start1 <= 1;

        @(posedge clk);  // t2
      	#0.1
        c_out_col_stream_flat <= { rs[2], rs[17], rs[32], 23'sd0 };
        start2 <= 1;

        @(posedge clk);  // t3
      	#0.1
        c_out_col_stream_flat <= { rs[3], rs[18], rs[33], rs[48] };
        start3 <= 1;

        @(posedge clk);  // t4
      	#0.1
        c_out_col_stream_flat <= { rs[4], rs[19], rs[34], rs[49] };
        start4 <= 1;

        @(posedge clk);  // t5
      	#0.1
        c_out_col_stream_flat <= { rs[5], rs[20], rs[35], rs[50] };
        en1 <= 1;

        @(posedge clk);  // t6
      	#0.1
        c_out_col_stream_flat <= { rs[6], rs[21], rs[36], rs[51] };
        en2 <= 1;

        @(posedge clk);  // t7
      	#0.1
        c_out_col_stream_flat <= { rs[7], rs[22], rs[37], rs[52] };
      	en3 <= 1;

        @(posedge clk);  // t8
      	#0.1
        c_out_col_stream_flat <= { rs[8], rs[23], rs[38], rs[53] };
      	en4 <= 1;

        @(posedge clk);  // t9
      	#0.1
        c_out_col_stream_flat <= { rs[9], rs[24], rs[39], rs[54] };

        @(posedge clk);  // t10
      	#0.1
        c_out_col_stream_flat <= { rs[10], rs[25], rs[40], rs[55] };

        @(posedge clk);  // t11
      	#0.1
        c_out_col_stream_flat <= { rs[11], rs[26], rs[41], rs[56] };

        @(posedge clk);  // t12
      	#0.1
        c_out_col_stream_flat <= { rs[12], rs[27], rs[42], rs[57] };

        @(posedge clk);  // t13
      	#0.1
        c_out_col_stream_flat <= { rs[13], rs[28], rs[43], rs[58] };

        @(posedge clk);  // t14
      	#0.1
        c_out_col_stream_flat <= { rs[14], rs[29], rs[44], rs[59] };

        @(posedge clk);  // t15
      	#0.1
        c_out_col_stream_flat <= { rs[15], rs[30], rs[45], rs[60] };

        @(posedge clk);  // t16
      	#0.1
        c_out_col_stream_flat <= { 23'sd0, rs[31], rs[46], rs[61] };

        @(posedge clk);  // t17
      	#0.1
        c_out_col_stream_flat <= { 23'sd0, 23'sd0, rs[47], rs[62] };
        start1 <= 0;

        @(posedge clk);  // t18
      	#0.1
        c_out_col_stream_flat <= { 23'sd0, 23'sd0, 23'sd0, rs[63] };
        start2 <= 0;

        @(posedge clk);  // t19
      	#0.1
        c_out_col_stream_flat <= { 23'sd0, 23'sd0, 23'sd0, 23'sd0 };
        start3 <= 0;

        @(posedge clk);
      	#0.1
        start4 <= 0;
      
        @(posedge clk);
      	#0.1
      	en1 <= 0;
      
      	@(posedge clk);
      	#0.1
      	en2 <= 0;
      
      	@(posedge clk);
      	#0.1
      	en3 <= 0;
      
      	@(posedge clk);
      	#0.1
        en4 <= 0;
      
        repeat(2) @(posedge clk);
      
        @(posedge clk);
      	#0.1
        shift_en <= 1;
      
      repeat(13) @(posedge clk);
      
        $finish;
    end

    // monitor
    always @(posedge clk) begin
        $display("%t : cut1=%0d, cut2=%0d, cut3=%0d, cut4=%0d",
                 $time, cut1, cut2, cut3, cut4);
    end

endmodule
