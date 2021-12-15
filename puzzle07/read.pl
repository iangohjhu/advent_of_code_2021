# day07 part 1 Determine the horizontal position that the crabs can align to using the least fuel possible. How much fuel must they spend to align to that position?

# sample crab horizontal positions
# $file='sample_input.txt';
# Total fuel: 37


# actual input
$file='actual_input.txt';
# Total fuel: 352254

$num_crabs = 0;
@crab_array;
$max_horizontal=0;
@position_array;
@sorted_crab_position;
$total_fuel = 0;

readInput($file);
findMaxHorizontalPosition();
sortCrabsByPosition();
findMedianPosition();
calculateFuelToPosition();
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
		@crab_array = split(',', $line);

	}

	# should only be one line
	close(INFO);
	
	$num_crabs = $#crab_array + 1;

	print "There are $num_crabs crabs\n";

}


sub findMaxHorizontalPosition()
{

	# find max horizontal position
	foreach my $crab (@crab_array)
	{
		if ($crab > $max_horizontal)
		{
			$max_horizontal = $crab;
		}
	}
	
#	print "max horizontal: $max_horizontal\n";
}

sub sortCrabsByPosition()
{
	# how many crabs in each position?

	# initialize
	foreach my $i (0 .. $max_horizontal)
	{
		$position_array[$i] = 0;
	}

	foreach my $crab (@crab_array)
	{
		# increment crab count at that position
		$position_array[$crab] += 1;
	}

	# sort positions
	foreach my $i (0 .. $max_horizontal)
	{
		if ($position_array[$i] > 0)
		{
#			print "$i : $position_array[$i]\n";
			for (my $j = 0; $j < $position_array[$i]; $j++)
			{
				push(@sorted_crab_position, $i);
			}
		}
	}

#	print "sorted by position: " . join(',', @sorted_crab_position) . "\n";
}

sub findMedianPosition()
{
	my $middle = int($num_crabs / 2);
	my $median =  @sorted_crab_position[$middle];
#	print "middle: $middle\n";
#	print "median: $median\n";

	# How much fuel must they spend to align to that position?

	# initialize
	foreach my $i (0 .. $max_horizontal)
	{
		#distance to median
		my $dist = abs($median - $i);
	
		#fuel cost = dist * number crabs at this position
		$total_fuel += calculateFuelToPosition($dist, $i);
	}
}

sub calculateFuelToPosition()
{
	my $dist = $_[0];
	my $pos = $_[1];

	#fuel cost = dist * number crabs at this position
	return ($dist * $position_array[$pos]);
}

sub displayOutput()
{
	print "Total fuel: $total_fuel\n";
}