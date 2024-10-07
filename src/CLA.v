module Add(
    input       [31:0]          a,
    input       [31:0]          b,
    output reg  [31:0]          sum
);

reg [31:0] pc = 32'b0;
reg [31:0] G = 32'b0;
reg [31:0] P = 32'b0;
reg [8:0] rc = 9'b0;
reg [8:0] rg = 9'b0;
reg [8:0] rp = 9'b0;

always @(a or b) begin
    for (integer i = 0; i < 32; i = i + 1) begin
        G[i] = a[i] & b[i];
        P[i] = a[i] + b[i];
    end
    for (integer i = 0; i < 8; i = i + 1) begin
        pc[i * 4] = (a[i * 4] & b[i * 4]) | (a[i * 4] & rc[i]) | (b[i * 4] & rc[i]);
        sum[i * 4] = a[i * 4] ^ b[i * 4] ^ rc[i];
        for (integer j = 1; j < 4; j = j + 1) begin
            pc[i * 4 + j] = (a[i * 4 + j] & b[i * 4 + j]) | (a[i * 4 + j] & pc[i * 4 + j - 1]) | (b[i * 4 + j] & pc[i * 4 + j - 1]);
            sum[i * 4 + j] = a[i * 4 + j] ^ b[i * 4 + j] ^ pc[i * 4 + j - 1];
        end
        rg[i] = G[i * 4 + 3] | (P[i * 4 + 3] & (G[i * 4 + 2] | (P[i * 4 + 2] & (G[i * 4 + 1] | (P[i * 4 + 1] & G[i * 4])))));
        rp[i] = P[i * 4 + 3] & P[i * 4 + 2] & P[i * 4 + 1] & P[i * 4];
        rc[i + 1] = rg[i] | (rp[i] & rc[i]);
    end
end
    
endmodule