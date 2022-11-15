`include "ft6206_defines.sv"
`include "i2c_types.sv"

`timescale 1ns/1ps
`default_nettype none

module ft6206_controller(clk, rst, ena, scl, sda, touch0, touch1);

parameter CLK_HZ = 12_000_000;
parameter CLK_PERIOD_NS = (1_000_000_000/CLK_HZ);
parameter I2C_CLK_HZ = 100_000; // Must be <= 400kHz
parameter DIVIDER_COUNT = CLK_HZ/I2C_CLK_HZ/2;  // Divide by two necessary since we toggle the signal

parameter DEFAULT_THRESHOLD = 128;
parameter N_RD_BYTES = 16;


parameter DISPLAY_WIDTH = 240;
parameter DISPLAY_HEIGHT = 320;

// Module I/O and parameters
input wire clk, rst, ena;
output wire scl;
inout wire sda;
//Touch 0 and 1 are of type touch_t defined in the defines module
output touch_t touch0, touch1;

i2c_transaction_t i2c_mode;
wire i_ready;
logic i_valid;
logic [7:0] i_data;
FT6206_register_t active_register; //TODO(avinash) implement smartly
logic o_ready;
wire o_valid;
wire [7:0] o_data;

//Inputs into i2c controller the data and gets outputs from it
i2c_controller #(.CLK_HZ(CLK_HZ), .I2C_CLK_HZ(I2C_CLK_HZ)) I2C0 (
  .clk(clk), .rst(rst), 
  .scl(scl), .sda(sda),
  .mode(i2c_mode), .i_ready(i_ready), .i_valid(i_valid), .i_addr(`FT6206_ADDRESS), .i_data(i_data),
  .o_ready(o_ready), .o_valid(o_valid), .o_data(o_data)
);

// Main fsm
enum logic [4:0] {
  S_IDLE = 0,
  S_INIT = 1,
  S_WAIT_FOR_I2C_WR = 2,
  S_WAIT_FOR_I2C_RD = 3,
  S_SET_THRESHOLD_REG = 4,
  S_SET_THRESHOLD_DATA = 5,
  S_TOUCH_START = 6,
  S_GET_REG_REG = 7,
  S_GET_REG_DATA = 8,
  S_GET_REG_DONE = 9,
  S_TOUCH_DONE,
  S_ERROR
} state, state_after_wait;

logic [1:0] num_touches;
//Creates a buffer that is of type touch_t defined in the defines module
touch_t touch0_buffer, touch1_buffer;
logic [$clog2(N_RD_BYTES):0] bytes_counter;

always_ff @(posedge clk) begin
  //Resets the touch sensor
  if(rst) begin
    //Sets the state to the initial state and after the wait the state is idle
    state <= S_INIT;
    state_after_wait <= S_IDLE;
    //Resets the counter that counts the bytes
    bytes_counter <= 0;
    // TODO(avinash) - merge touch0 and touch1 buffers, can get away with less state that way.
    //Resets the touch variables
    touch0_buffer <= 0;
    touch1_buffer <= 0;
    touch0 <= 0;
    touch1 <= 0;
  end else begin
    case(state)
      S_IDLE : begin
        //Waits for enable and the input to be ready otherwise does nothing
        if(i_ready & ena)
          active_register <= TD_STATUS;
          state <= S_GET_REG_REG;
      end
      S_INIT : begin

        state <= S_SET_THRESHOLD_REG;
      end
      S_SET_THRESHOLD_REG: begin
        //In the Threshold REG state it waits for the I2C to write and then
        //goes to the Set threshold data state
        state <= S_WAIT_FOR_I2C_WR;
        state_after_wait <= S_SET_THRESHOLD_DATA;
      end
      S_SET_THRESHOLD_DATA: begin
        //In this state waits for I2C to write and the sets the state back to idle
        state <= S_WAIT_FOR_I2C_WR;
        state_after_wait <= S_IDLE;
      end
      S_GET_REG_REG: begin
        //Waits to write the new data to I2C and then gets data from that register
        state <= S_WAIT_FOR_I2C_WR;
        state_after_wait <= S_GET_REG_DATA;
      end
      S_GET_REG_DATA: begin
        //Waits for the I2C to send read the data and then sets the state to getting the registe as done
        state <= S_WAIT_FOR_I2C_RD;
        state_after_wait <= S_GET_REG_DONE;
      end
      S_GET_REG_DONE: begin
        //If  a new transaction starts set the state back to idle
        if(~o_valid) begin
          state <= S_IDLE;
        end
        //If a new transaction has not started
        else begin
          //Go to the next register
          active_register <= active_register.next;
          case(active_register)
            TD_STATUS: begin
              //either the 4th or 3rd bit is a 1 set th number of touches to 0 or set it to the first and second bit
              num_touches <= |o_data[3:2] ? 0 : o_data[1:0];
              //If the data is equal to set make the buffers valid
              if(o_data[3:0] == 4'd2) begin
                touch0_buffer.valid <= 1;
                touch1_buffer.valid <= 1;
                //if the data is equal to 1 set touch 0 valid to high and touch 1 to low
              end else if (o_data[3:0] == 4'd1) begin
                touch0_buffer.valid <= 1;
                touch1_buffer.valid <= 0;
                //In every other make every touch invalid
              end else begin
                touch0.valid <= 0;
                touch1.valid <= 0;
                touch0_buffer.valid <= 0;
                touch1_buffer.valid <= 0;
              end
            end
            // Set the first touch position last bits of the xposition to the first parts of the data
            P1_XH: begin
              touch0_buffer.x[11:8] <= o_data[3:0];
              touch0_buffer.contact <= o_data[7:6];
            end
            //Sets the xposition to the data
            P1_XL : begin
              touch0_buffer.x[7:0] <= o_data;
            end
            //Sets the last bits of the y position to first part of the data
            P1_YH : begin
              touch0_buffer.y[11:8] <= o_data[3:0];
              touch0_buffer.id <= o_data[7:4];
            end
            //Sets the y position to the data
            P1_YL : begin
              touch0_buffer.y[7:0] <= o_data;
            end
          endcase
          //If the active register is at the y position then the touch is done
          //If it isn't it tries to get the register that it is supposed to be at.
          if(active_register == P1_YL) // TODO(avinash) replace constant
            state <= S_TOUCH_DONE;
          else
            state <= S_GET_REG_REG;
        end
      end
      //If the touch is done
      S_TOUCH_DONE: begin
        //if the number of touches is greater than or equal to 1
        //Set all the variables to their correct values and set the positions of the x and y for that point 
        //to the right ones using the buffers and display dimensions
        if(num_touches >= 2'd1) begin
          touch0.valid <= touch0_buffer.valid;
          touch0.x <= DISPLAY_WIDTH - touch0_buffer.x; // fix orientation
          touch0.y <= DISPLAY_HEIGHT - touch0_buffer.y; // fix orientation
          touch0.contact <= touch0_buffer.contact;
          touch0.id <= touch0_buffer.id;
        end
        // See if you can modify the above to do multitouch!
        state <= S_IDLE;
      end      
      S_WAIT_FOR_I2C_WR : begin
        //If the input is ready go to the state it is waiting for
        if(i_ready) state <= state_after_wait;
      end
      S_WAIT_FOR_I2C_RD : begin
        //If the input is ready and there is no ongoing trasnactionF on a read go to the next state
        if(i_ready & o_valid) state <= state_after_wait;
      end
    endcase
  end
end
//Determines whether the i2c conroller recieves a valid input based on the state
always_comb case(state)
  S_IDLE: i_valid = 0;
  S_INIT: i_valid = 0;
  S_RD_DATA: i_valid = 1;
  S_WAIT_FOR_I2C_WR: i_valid = 0;
  S_WAIT_FOR_I2C_RD: i_valid = 0;
  S_SET_THRESHOLD_REG: i_valid = 1;
  S_SET_THRESHOLD_DATA: i_valid = 1;
  S_GET_REG_REG: i_valid = 1;
  S_GET_REG_DATA: i_valid = 1;
  default: i_valid = 0;
endcase 
//If the state is to get the register data it changes the i2c mode to read, otherwise it is read to write
always_comb case(state)
  S_GET_REG_DATA:  i2c_mode = READ_8BIT;
  default: i2c_mode = WRITE_8BIT_REGISTER;
endcase

//Sets the threshold for what determines a touch based on a new threshold or something defined in the defines module.
always_comb case(state)
  S_SET_THRESHOLD_REG: i_data = THRESHOLD;
  S_SET_THRESHOLD_DATA: i_data = `FT6206_DEFAULT_THRESHOLD;
  S_GET_REG_REG: i_data = active_register;
  default: i_data = 0;
endcase
endmodule