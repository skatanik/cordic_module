module cordic_module(
    input wire          clk         ,
    input wire          rst_n       ,
 
 // Q8.24
    input wire signed [31:0]   angle_deg    ,       //  -pi/2 <= angle_deg <= pi/2
    input wire                 write_angle  ,
    input wire signed [31:0]   x_start      ,
    input wire signed [31:0]   y_start      ,
    output wire signed [31:0]   x_cos       ,
    output wire signed [31:0]   y_sin

    );

parameter iterations_num = 29;

logic signed [31:0] current_angle [0:32];
logic signed [31:0] current_x [0:32];
logic signed [31:0] current_y [0:32];

logic signed [31:0] atan_table [0:31]; // Q8.24

assign atan_table[00] = 32'sd754974720;
assign atan_table[01] = 32'sd445687602;
assign atan_table[02] = 32'sd235489088;
assign atan_table[03] = 32'sd119537938;
assign atan_table[04] = 32'sd60000934;
assign atan_table[05] = 32'sd30029717;
assign atan_table[06] = 32'sd15018523;
assign atan_table[07] = 32'sd7509720;
assign atan_table[08] = 32'sd3754917;
assign atan_table[09] = 32'sd1877466;
assign atan_table[10] = 32'sd938734;
assign atan_table[11] = 32'sd469367;
assign atan_table[12] = 32'sd234684;
assign atan_table[13] = 32'sd117342;
assign atan_table[14] = 32'sd58671;
assign atan_table[15] = 32'sd29335;
assign atan_table[16] = 32'sd14668;
assign atan_table[17] = 32'sd7334;
assign atan_table[18] = 32'sd3667;
assign atan_table[19] = 32'sd1833;
assign atan_table[20] = 32'sd917;
assign atan_table[21] = 32'sd459;
assign atan_table[22] = 32'sd229;
assign atan_table[23] = 32'sd115;
assign atan_table[24] = 32'sd58;
assign atan_table[25] = 32'sd29;
assign atan_table[26] = 32'sd15;
assign atan_table[27] = 32'sd8;
assign atan_table[28] = 32'sd4;
assign atan_table[29] = 32'sd2;
assign atan_table[30] = 32'sd1;
assign atan_table[31] = 32'sd0;


always_ff @(posedge clk or negedge rst_n)
    if(~rst_n)              current_angle[0] <= 0;
    else if(write_angle)    current_angle[0] <= angle_deg;

always_ff @(posedge clk or negedge rst_n)
    if(~rst_n)              current_x[0] <= 0;
    else if(write_angle)    current_x[0] <= x_start;

always_ff @(posedge clk or negedge rst_n)
    if(~rst_n)              current_y[0] <= 0;
    else if(write_angle)    current_y[0] <= y_start;

genvar i;

generate
    for (i = 1; i <= iterations_num; i= i + 1)
    begin
        logic sign;
        assign sign = current_angle[i-1][31];

        logic signed [31:0] x_shifted;
        logic signed [31:0] y_shifted;

        assign x_shifted = current_x[i - 1] >>> (i-1);
        assign y_shifted = current_y[i - 1] >>> (i-1);

        always_ff @(posedge clk or negedge rst_n)
        if(~rst_n)  current_x[i] <= 0;
        else        current_x[i] <= sign ? current_x[i - 1] + y_shifted : current_x[i - 1] - y_shifted;

        always_ff @(posedge clk or negedge rst_n)
        if(~rst_n)  current_y[i] <= 0;
        else        current_y[i] <= sign ? current_y[i - 1] - x_shifted : current_y[i - 1] + x_shifted;

        always_ff @(posedge clk or negedge rst_n)
        if(~rst_n)  current_angle[i] <= 0;
        else        current_angle[i] <= sign ? current_angle[i - 1] + atan_table[i - 1] : current_angle[i - 1] - atan_table[i - 1];

    end
endgenerate

assign x_cos = current_x[iterations_num];
assign y_sin = current_y[iterations_num];

endmodule
