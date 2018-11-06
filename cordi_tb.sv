module cordi_tb ();

bit      clk   ;    // Clock
bit      rst_n ;  // Asynchronous reset active low

logic               write_angle;
logic signed [31:0] x_start;
logic signed [31:0] y_start;
logic signed [31:0] angle;
logic signed [31:0] sin;
logic signed [31:0] cos;

always #10 clk = !clk;

initial
begin
write_angle = 0;
x_start = 0;
y_start = 0;
angle = 0;

repeat(10) @(posedge clk);

rst_n = 1;

repeat(10) @(posedge clk);
#1 write_angle = 1;
x_start = 32'd10183770;
y_start = 0;
angle = 32'shDD00_0000;        // 35

repeat(1) @(posedge clk);
#1 write_angle = 0;
x_start = 0;
y_start = 0;
angle = 0;


end

cordic_func cordic_func_0(
    .clk         (clk            ),
    .rst_n       (rst_n          ),

    .angle_deg    (angle        ),
    .write_angle  (write_angle  ),
    .x_start      (x_start      ),
    .y_start      (y_start      ),
    .x_cos        (cos          ),
    .y_sin        (sin          )
    );



endmodule