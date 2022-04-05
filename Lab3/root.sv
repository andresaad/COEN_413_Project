//`timescale 1ns/1ns

//package lab2_package;
   

parameter APB_ADDR_WIDTH = 16;
typedef bit [APB_ADDR_WIDTH-1:0] apb_addr_t;
parameter APB_DATA_WIDTH = 32;
typedef bit [APB_DATA_WIDTH-1:0] apb_data_t;
typedef enum {READ, WRITE, IDLE} trans_e;

//endpackage; // package lab2_package
   