use strict;
# day01 part 2 count the number of times the sum of measurements in this sliding window increases from the previous sum.

#my $file='sample_input.txt';
# Number of increases: 5

my $file='actual_input.txt';
# Number of increases: 1743

my $max_row = 0;
my @array;
my $increases = 0;

readInput($file);
processTriples();
displayOutput();
 
exit;
 
 sub readInput()
 {
	my $file = $_[0]; 
 
 	# read input into an array
	open(INFO, $file) or die("Could not open file.");
	@array = map { /([0-9]+)/ } (<INFO>);
	close(INFO);
		
	$max_row = scalar @array;

	print "Read rows: $max_row\n";
}

sub processTriples()
{

	# iterate over triples
	for (my $i = 0; $i < ($max_row - 3) ; $i++)
	{
		my $sum1 = $array[$i] + $array[$i+1] + $array[$i+2];
		my $sum2 = $array[$i+1] + $array[$i+2] + $array[$i+3];
	
		if ($sum1 < $sum2)
		{
			$increases++;
		}
	}

}



sub displayOutput()
{
	print "Number of increases: $increases\n";
}