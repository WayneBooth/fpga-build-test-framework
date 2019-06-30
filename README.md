# fpga-build-test-framework
Xilinx** Verilog***, build and test framework

 ** Currently, the build process is written for command line builds of Xilinx parts. could be extended.
 
 *** Currently, the test framework is built around a Verilog testbench. Could be extended.

This framework brings together command line build and test suite into a Makefile.
All the boiler plate code for running and validating your tests are extracted out.
Everything is configured in one easy config file.

This relys upon a number of other reporitories. Once this repo is clones, you shoudl get all sub modules with:

```
git submodule update --remote
```

