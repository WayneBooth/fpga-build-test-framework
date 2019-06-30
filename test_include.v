`define MACRO(x) `"x`" 

reg [11:0] vectornum, errors;
reg testvectors [0:10000];
integer file;

initial begin
	$display("Running %s", `MACRO(`test));
	file = $fopen({`MACRO(`test),".error"}, "w"); // Blat anything already there
	$fclose(file);
	$dumpfile(`MACRO(`vcd));
	$dumpvars(1, DUT);
        $readmemb({"../tv/",`MACRO(`test),".tv"}, testvectors);
        vectornum = 0;
	errors = 0;
		$display("vectorfile. %s", testvectors[vectornum]);
        if (testvectors[vectornum] === 1'bx) begin
		$display("No vectorfile. Will run for #10000");
		vectornum = 1'bx;
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
			$display ("%d tests for '%s', completed with %d errors", vectornum, `MACRO(`test), errors);
			if( errors > 0 ) begin
				file = $fopen({`MACRO(`test),".error"}, "a");
				$fdisplay (file, "%d tests completed with %d errors", vectornum, errors);
				$fclose(file);
			end
			$finish(0);
        	end
	end
end

task recordError; begin
	$display("################################################");
	file = $fopen({`MACRO(`test),".error"}, "a");
	$fdisplay(file, "ERROR: seen at %t", $time);
	$fclose(file);
	errors = errors + 1;
end
endtask

initial begin
	#10000;
	file = $fopen({`MACRO(`test),".error"}, "a");
	$fdisplay(file, "ERROR: Forcing the test to finish, since it's been running for more than 10,000.");
	$fclose(file);
	$finish(2);
end

