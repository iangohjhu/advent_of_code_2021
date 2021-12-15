# day03 part 1 Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together. What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)

# $file='sample_input.txt';
# gamma rate: 22
# epsilon rate: 9
# gamma rate x episolon rate : 198


$file='actual_input.txt';
# gamma rate: 3069
# epsilon rate: 1026
# gamma rate x episolon rate : 3148794

$line_count = 0; 
$length_input = 0;
@bit_array;
$gamma_rate = 0;
$epsilon_rate = 0;

readInput($file);
findMostCommonBit();
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
   
    	if ($line_count == 0)
		{
			# get length of input string
			$length_input = length($line);
		}

		for (my $i = 0; $i < $length_input; $i++) 
		{
			# store counts of bits into bit_array
			$bit_array[$i] += substr($line,$i,1);
		}
	
		$line_count += 1;
	}
	
	close(INFO);
	print "\nRead $line_count lines, length: $length_input\n"; 
}


sub findMostCommonBit()
{
	print "Determining most common bit - median\n";
	for ($i = 0; $i < $length_input; $i++) 
	{
		if ($bit_array[$i] > $line_count / 2)
		{
			# more ones than zeroes
			# print "1\n";
			
			# convert to decimal
			$gamma_rate += 2 ** ($length_input - $i -1);
			 
		}
		else
		{	
			# more zeroes than ones
			# print "0\n";
			
			# convert to decimal
			$episilon_rate += 2 ** ($length_input - $i -1);
		}
	}
}
	
	
sub displayOutput()
{
	print "gamma rate: $gamma_rate\n";
	print "epsilon rate: $episilon_rate\n";
	print "gamma rate x episolon rate : " . $gamma_rate * $episilon_rate . "\n";
}