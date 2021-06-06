`timescale 1ns/1ns

module dds_test();

reg 			clk;
reg 			rst_n;
reg 	[27:0]fword;
reg 	[11:0]pword;
reg	[15:0]period;
reg	[15:0]h_time;
reg			pwm_en;

wire 	[11:0]dds_out;
wire 			pwm;
  DAC_0832 DAC_0832_inst(       

	.clk(clk),
	.rst_n(rst_n),
	
	.fword(fword),
	.pword(pword),
	.period(period),
	.h_time(h_time),
	.pwm_en(pwm_en),
	
	.dds_out(dds_out),
	.pwm(pwm)
	
);

//*****产生50MHZ时钟信号******
initial 		clk = 1'b0;
always 		#10 clk = ~ clk;


//*****输入频率控制字与相位控制字***
initial 	begin 

rst_n = 1'b0;  

#210 rst_n = 1'b1;

fword = 28'd1000; pword = 12'd0;   
pwm_en = 1'b1;
period = 16'd50000; h_time = 16'd12500;

#100_000_000;

$stop;

end



endmodule 