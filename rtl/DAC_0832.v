//*********可以产生任意频率正弦波信号************

//******频率计算方式: 在50MHZ时钟下   1KHZ的频率控制字（Fword） =  1000/(50M/2^28) = 5369  此时相位控制字为fword四分之一的话 初相位为90度 以此类推
//												2KHZ的频率控制字（Fword） =  2000/(50M/2^28) = 10737 以此类推
//
/*pwm_en：使能信号，高电平使能输出，低电平输出为0,
period：PWM的周期，如主时钟50M，产生1kHz的波形，则period = 50M/1k = 50000
h_time：高电平的时间，如主时钟50M，产生2MHz，占空比25%的波形，则h_time = 50000 * 0.25 = 12500
pwm：PWM波输出
*/
								
module DAC_0832(       

	clk,
	rst_n,
	
	fword,
	pword,
	period,
	h_time,
	pwm_en,
	
	dds_out,
	pwm
);

input 					clk;   			//50MHZ
input 			 		rst_n;
input				[27:0]fword; 			//28位频率控制字1
input				[11:0]pword; 			//12位相位控制字1

input				[15:0]period;
input 			[15:0]h_time;
input						pwm_en;			//方波使能

output 		   [11:0]dds_out;			//12位dac数据
output reg 				pwm;				//方波输出

reg 				[27:0]fre_acc;			//累加频率控制字
reg 				[11:0]adr_acc;			//截取高位做查询rom地址
reg 				[31:0]CNT;

always@(posedge clk or negedge rst_n)
	if(rst_n == 1'b0)
		fre_acc <= 28'd0;
	else
		fre_acc <= fre_acc + fword; 

always@(posedge clk or negedge rst_n)
	if(rst_n == 1'b0)
		adr_acc <= 12'd0;
	else
		adr_acc <= fre_acc[27:16] + pword;	

//********任意占空比的方波*****
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		CNT <= 0;
	else if(CNT >= period - 1 )
		CNT <= 0;
	else
		CNT <= CNT + 1;
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		pwm <= 0;
    else    
    begin
        if(pwm_en == 0)
            pwm <= 0;
        else    
        begin
            if(CNT <= h_time - 1)
                pwm <= 1;
            else
                pwm <= 0;
        end
    end
end
	
sindds	sindds_inst (
	.address ( adr_acc ),
	.clock ( clk ),
	.q ( dds_out )
	);

	
endmodule 