# day07 part 2 fuel usage not constant;  How much fuel must they spend to align to that position?

# sample crab horizontal positions
# $file='sample_input.txt';
# Least Fuel Position: 5
# Total fuel: 168


# actual input
$file='actual_input.txt';
# Least Fuel Position: 504
# Total fuel: 99053143

$num_crabs = 0;
@crab_array;
$max_horizontal=0;
@position_array;
@total_fuel_for_this_position;

readInput($file);
findMaxHorizontalPosition();
sortCrabsByPosition();
findTotalFuelForEachPosition();
findPositionLeastFuel();
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
}

sub findTotalFuelForEachPosition()
{
	foreach my $i (0 .. $max_horizontal)
	{
		$total_fuel_for_this_position[$i] = 0;
	
		foreach my $j (0 .. $max_horizontal)
		{
			my $num_crabs_at_this_position = $position_array[$j];
			if ( $num_crabs_at_this_position > 0)
			{
				#distance to $i
				my $dist = abs($j - $i);
	
				#fuel cost 
				$total_fuel_for_this_position[$i] += (fuel_cost($dist) * $num_crabs_at_this_position) ;
			}
		}	
	}
}

sub findPositionLeastFuel()
{
	#find position with least fuel
	my $least_fuel_position = 0;
	my $least_fuel_total = $total_fuel_for_this_position[0];

	foreach my $i (1 .. $max_horizontal)
	{
		if ($total_fuel_for_this_position[$i] < $least_fuel_total)
		{
			# better position, store value
			$least_fuel_position = $i;
			$least_fuel_total = $total_fuel_for_this_position[$i];
		}
	}

	print "Least Fuel Position: $least_fuel_position\n";
	print "Total fuel: $least_fuel_total\n";
}



sub fuel_cost ()
{
	my $dist = $_[0];
	
	my $fuel_cost = 0;

 	# sum of the terms of an arithmetic series
 	# https://www.varsitytutors.com/hotmath/hotmath_help/topics/sum-of-the-first-n-terms-of-a-series
 	
 	my $n = $dist;
 	my $a1 = 1;
 	my $a2 = $dist;
 	
 	$fuel_cost = ($n * ($a1 + $a2)) / 2;
#	print "For distance: $distance, fuel: $fuel_cost\n";
	
	return $fuel_cost;
}