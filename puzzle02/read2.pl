# day02 part 2 What do you get if you multiply your final horizontal position by your final depth?

# $file='sample_input.txt';
# horizontal: 15, depth: 60, aim: 10
# horizontal * depth = 900

$file='actual_input.txt';
# horizontal: 2063, depth: 892056, aim: 1005
# horizontal * depth = 1840311528

$horizontal = 0;
$depth = 0;
$aim = 0;

readInput($file);
displayOutput();
exit;



sub readInput()
{
	my $file = $_[0];
	
	open(INFO, $file) or die("Could not open file.");

	foreach $line (<INFO>)  
	{   
		# trim white space at end
		$line =~ s/\s+$//;

		processLine($line);

		# print "horizontal: $horizontal, depth: $depth\n";
	}
	close(INFO);
}

sub processLine()
{
	my $line = $_[0];
	
	my @input = split(' ', $line);

	# first part will be the command, e.g., forward, down, up
	$cmd = $input[0];
#	print "cmd: $cmd.\n";

	# second part will be the amount
	$amt = $input[1];
#	print "amt: $amt.\n";

	if ($cmd eq "forward") 
	{
		print "forward $amt\n";
		# It increases your horizontal position by X units.
		$horizontal += $amt;
		# It increases your depth by your aim multiplied by X.
		$depth += ($aim * $amt);
	} 
	elsif ($cmd eq "down") 
	{
		print "down $amt\n";
		# $depth += $amt;
		# down X increases your aim by X units.
		$aim += $amt;
	} 
	elsif ($cmd eq "up") 
	{
		print "up $amt\n";
		# $depth -= $amt;
		# up X decreases your aim by X units.
		$aim -= $amt;
	}

}


sub displayOutput()
{
	my $product = $horizontal * $depth;

	print "horizontal: $horizontal, depth: $depth, aim: $aim\n";
	print "horizontal * depth = $product\n";
}