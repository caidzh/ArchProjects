module Add(
    input       [31:0]          a,
    input       [31:0]          b,
    output reg  [31:0]          sum
);

reg [31:0] pc = 32'b0;

always @(a or b) begin
    pc[0] = a[0] & b[0];
    sum[0] = a[0] ^ b[0];
    for (integer i = 1; i < 32; i = i + 1) begin
        pc[i] = (a[i] & b[i]) | (a[i] & pc[i-1]) | (b[i] & pc[i-1]);
        sum[i] = a[i] ^ b[i] ^ pc[i-1];
    end
end
    
endmodule
