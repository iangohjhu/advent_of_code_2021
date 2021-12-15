# day01 part 2 count the number of times the sum of measurements in this sliding window increases from the previous sum.

#$file='sample_input.txt';
# Number of increases: 5

$file='actual_input.txt';
# Number of increases: 1743

$max_row = 0;
@array;
$increases = 0;

readInput($file);
processTriples();
displayOutput();
 
exit;
 
 sub readInput()
 {
	my $file = $_[0]; 
 
	open(INFO, $file) or die("Could not open  file.");

	my $row = 0;
 
	foreach $line (<INFO>)  {   
		#    print "$line\n";
    	@array[$row] = $line; 
		
		$row++;
	}
	
	$max_row = $row;

	close(INFO);
	print "Read rows: $max_row\n";
}

sub processTriples()
{

	# iterate over triples
	for (my $i = 0; $i < ($max_row - 3) ; $i++)
	{
		my $sum1 = $array[$i] + $array[$i+1] + $array[$i+2];
		my $sum2 = $array[$i+1] + $array[$i+2] + $array[$i+3];
	
		print "$sum1 $sum2 :\n";
	
		if ($sum1 < $sum2)
		{
			$increases++;
			print " increased\n";
		}
	}

}



sub displayOutput()
{
	print "Number of increases: $increases\n";
}