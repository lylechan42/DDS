module pwm_gen(

rst_n,
 clk,
 en,

input [15:0] period,
input [15:0] h_time,

output reg pwm

);

input rst_n,
input clk,
input en,

input [15:0] period,
input [15:0] h_time,

output reg pwm

reg [31:0] CNT;

always @ (posedge clk)
begin
	if(!rst_n)
		CNT <= 0;
	else if(CNT >= period - 1 )
		CNT <= 0;
	else
		CNT <= CNT + 1;
end

always @ (posedge clk)
begin
	if(!rst_n)
		pwm <= 0;
    else    
    begin
        if(en == 0)
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

endmodule 