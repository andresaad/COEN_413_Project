
module top;

  
  bit clock;
  always #(1) 
    clock = ~clock;

  calc2_if       my_calc_if(clock);
  test          t1(my_calc_if);  
  
  calc2_top     m1  (
                    .c_clk(clock),
                    .reset(my_calc_if.Rst),
                    .req1_cmd_in(my_calc_if.req1_cmd_in), 
                    .req2_cmd_in(my_calc_if.req2_cmd_in),
                    .req3_cmd_in(my_calc_if.req3_cmd_in),
                    .req4_cmd_in(my_calc_if.req4_cmd_in),
                    
                    .req1_data_in(my_calc_if.req1_data_in),
                    .req2_data_in(my_calc_if.req2_data_in),
                    .req3_data_in(my_calc_if.req3_data_in),
                    .req4_data_in(my_calc_if.req4_data_in),
                    
                    .req1_tag_in(my_calc_if.req1_tag_in),
                    .req2_tag_in(my_calc_if.req2_tag_in),
                    .req3_tag_in(my_calc_if.req3_tag_in),
                    .req4_tag_in(my_calc_if.req4_tag_in),
                    
                    .out_resp1(my_calc_if.out_resp1), 
                    .out_resp2(my_calc_if.out_resp2),
                    .out_resp3(my_calc_if.out_resp3),
                    .out_resp4(my_calc_if.out_resp4),
                    
                    .out_data1(my_calc_if.out_data1),
                    .out_data2(my_calc_if.out_data2),
                    .out_data3(my_calc_if.out_data3),
                    .out_data4(my_calc_if.out_data4),

                    .out_tag1(my_calc_if.out_tag1),
                    .out_tag2(my_calc_if.out_tag2),
                    .out_tag3(my_calc_if.out_tag3),
                    .out_tag4(my_calc_if.out_tag4)
                    );
  

endmodule  
