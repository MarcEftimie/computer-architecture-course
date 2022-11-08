// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;

<<<<<<< HEAD
logic [N-1:0] ticks;
logic [N-1:0] count;
logic compare_out;

typedef enum logic {COUNTING_UP, COUNTING_DOWN} state_t;
state_t state;
=======
typedef enum logic {COUNTING_UP = 1'b1, COUNTING_DOWN = 1'b0} state_t;
state_t state, next_state;

// Behavioural approach to a counter

logic [N-1:0] adder_a, counter_pp;
always_comb begin : cl_for_counter
  // mux to switch between +1 and -1
  // adder_a = state ? +1 : -1;
  case (state)
    COUNTING_DOWN : adder_a = -1;
    COUNTING_UP   : adder_a = 1;
    default:        adder_a = 0; // doesn't get implemented unless state is more than one bit, but best practice for later.
  endcase

  // make an adder
  counter_pp = out + adder_a;
end
// counter register
always_ff @(posedge clk) begin :counter_register
  if(rst) out <= 0;
  else if(ena) out <= counter_pp;
  else out <= out;
end

// Finite state machine
always_ff @(posedge clk) begin : state_ff
  if(rst) state <= COUNTING_UP;
  else state <= next_state;
end

logic count_is_zero, count_is_max;
always_comb begin :next_state_cl
  // advantage of these being named - they'll show up in the waveforms!
  count_is_zero = (counter_pp == 0); // equivalent &(~out);
  count_is_max = (counter_pp == {N{1'b1}});
  
  case(state)
    COUNTING_DOWN: begin
      if(count_is_zero) next_state = COUNTING_UP;
    end
    COUNTING_UP: begin
      if(count_is_max) next_state = COUNTING_DOWN;
    end
    default: next_state = COUNTING_UP; // Just being safe, doesn't do anything for 1 bit state.
  endcase
  
end
>>>>>>> 51b9b3d164215c0fb2ec15a21ad15d2b6bbd9593

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
    end else if(ena & compare_out) begin
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