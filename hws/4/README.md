# Homework 4
The written portion is available [here](https://docs.google.com/document/d/1XybXmTD5-NTJ1gfLq3tYb-wUUDJGZS8xgO912DLf50Q/edit?usp=sharing)

Add a pdf of your written answers to this folder, then use `make clean` then `make submission` to submit!

To implement the 32 to 1 mux I used a series of casacading 2 to 1 muxs that took in 32 inputs. For example, 2 2 to 1 mux's outputs feed into another 2 to 1 mux; this makes one piece of the "cascade". I started with 16 2 to 1 muxs, which fed into 8 2 to 1 muxs until my circuit came down to 1 2 to 1 mux with the final output.

I tested the 32 to 1 mux by assigning the inputs to random bits and looping through each select bit (00000 to 11111) which printed a string of the input bits.

Use the command make test_adder_n and make test_mux32 to run the tests.