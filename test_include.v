`define MACRO(x) `"x`" 

reg clk = 0;
reg [11:0] vectornum, errors;
reg testvectors [0:10000];
integer file;
integer runTillEnd = 0;

initial begin
	$display ("\n######################################\n#######\\/#########\\/########\\/########\n");
	$display("Running %s", `MACRO(`test));

	file = $fopen({`MACRO(`test),".error"}, "w"); // Blat anything already there
	$fclose(file);

	$dumpfile(`MACRO(`vcd));
	$dumpvars(1, DUT);

	file = $fopen({"../tv/",`MACRO(`test),".tv"}, "r");
	if (file == 0) begin
		$fclose(file);
		$display("No vector file found.");
	end
	else begin
		$fclose(file);
	        $readmemb({"../tv/",`MACRO(`test),".tv"}, testvectors);
		$display("Using vectorfile: %s", {"../tv/",`MACRO(`test),".tv"});
	end
        vectornum = 0;
	errors = 0;
        if (testvectors[vectornum] === 1'bx) begin
		$display("Will run for #10000");
		vectornum = 1'bx;
		runTillEnd = 1;
	end
end

always begin
        clk = 0; 
	#5; 
	clk = 1; 
	#5;
end

always @(posedge clk) begin
	#3;
	if (vectornum !== 1'bx ) begin
        	vectornum = vectornum + 1;
		if (testvectors[vectornum] === 1'bx) begin
			testReport();
			$finish(0);
        	end
	end
end

task testReport; begin
	$display ("\n@@@@@@@@@@\n%d tests for '%s', completed with %d errors\n@@@@@@@@@@\n", vectornum, `MACRO(`test), errors);
	if( errors > 0 ) begin
		file = $fopen({`MACRO(`test),".error"}, "a");
		$fdisplay (file, "%d tests completed with %d errors", vectornum, errors);
		$fclose(file);
	end
	$display ("#######/\\##########/\\#########/\\######\n######################################\n\n");
end
endtask

task recordError; begin
	file = $fopen({`MACRO(`test),".error"}, "a");
	$fdisplay(file, "ERROR: seen at %t", $time);
	$fclose(file);
	errors = errors + 1;
end
endtask

initial begin
	#100000;
	if( runTillEnd == 0 ) begin
		file = $fopen({`MACRO(`test),".error"}, "a");
		$fdisplay(file, "ERROR: Forcing the test to finish, since it's been running for more than 10,000.");
		$fclose(file);
	end
	else begin
		$display("Check '%s' for details of signals.", `MACRO(`vcd) );
	end
	testReport();
	$finish(0);
end
