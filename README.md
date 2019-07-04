# fpga-build-test-framework
Xilinx* Verilog**, build and test framework

 &#8291;* Currently, the build process is written for command line builds of Xilinx parts. could be extended.
 
 ** Currently, the test framework is built around a Verilog testbench. Could be extended.

## General

This framework brings together command line build and test suite into a Makefile.
All the boiler plate code for running and validating your tests are extracted out.
Everything is configured in one easy config file.

## Setup

This relys upon a number of other reporitories. Once this repo is cloned, you should download all sub modules with:

```
git submodule init
git submodule update --remote
```


### VCD
The VCD tool will display a VCD waveform file at the command line. The framework will produce a vcd file for each verilog testbench, and display it automatically if a test fails.

Enter the "vcd" directory and build/install the binary.

```
cd vcd
gcc vcd.c -o vcd
sudo cp vcd /usr/local/bin/vcd
```


### Makefile
The 'Xilinx-ISE-Makefile' repo provides a convenient way to build Xilinx verilog/VHDL designs and testbenches from source at the command line. This repo is currently branched since it contains hooks for testing not provided by (and not appropriate to) the original repo.

Copy the 'Makefile' from the 'Xilinx-ISE-Makefile' directory into the root of your design.

You should then create a configuration file (`project.cnf`) as discussed in the repo README, depending on your project name, part specs, etc... A example `project.cnf` file is provided in the `example` directory.


### Testbenches
The boilerplate for running, managing and checking tests is provided and packaged in the 'test_include.v' file. This file should be included in your testbenches.

```
`include "test_include.v"
```

'tv' directory .......

The instance of the module being testing should be called 'DUT'. eg 
```
clk_divider #(.DIVIDE_BY(6)) DUT ( .clk_in(clk), .clk_out(clk_out) );
```
See an example testbench and testvectors in the 'example' directory.


## Using the tools

Once you are setup, you should be able to perform the following actions:

```
# Cleanup
make clean

# Build and run any testbenches
make test

# Synthises, Place and Route, Generate a bit file.
make 

# Upload the bitfile to your device
make prog
```
