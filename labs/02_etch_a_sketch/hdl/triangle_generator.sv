// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;

logic [N-1:0] ticks;
logic [N-1:0] count;
logic compare_out;

typedef enum logic {COUNTING_UP, COUNTING_DOWN} state_t;
state_t state;

comparator_eq #(.N(N)) comparator_eq_0(.a(count), .b(ticks), .out(compare_out));

always_ff @(posedge clk) begin
    if(rst) begin
        count <= 0;
        ticks <= (2**N)-2;
    end else if(ena) begin
        case(state)
            COUNTING_UP: count <= count + 1;
            COUNTING_DOWN: count <= count - 1;
        endcase
        out <= count;
    end
end

always_ff @(posedge clk) begin
    if(rst) begin
        state <= COUNTING_UP;
    end 
    else if(ena & compare_out) begin
        case(state)
            COUNTING_UP: begin
                state <= COUNTING_DOWN;
                ticks <= 1;
            end
            COUNTING_DOWN: begin
                state <= COUNTING_UP;
                ticks <= (2**N)-2;
            end
        endcase
    end
end
endmodule