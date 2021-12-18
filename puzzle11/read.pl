# day11 part 1
# Given the starting energy levels of the dumbo octopuses in your cavern, simulate 100 steps. How many total flashes are there after 100 steps?

#$file='sample_input.txt';
# Total Flashes: 1656

$file='actual_input.txt';
# Total Flashes: 1642



my @array;
my @has_flashed;
my $max_row;
my $max_col;
my $total_flashes;

readInput($file);

foreach $step (1..100)
{
	doStep();
}

displayOutput();

exit;

sub readInput()
{
	my $file = $_[0];
	open(INFO, $file) or die("Could not open file.");

	my $row = 0;
	# read input
	foreach my $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;
		$max_col = length($line);
	
		processLine($row, $line);
		$row++;
	}
	$max_row = $row;
	close(INFO);


	print "Read rows: $max_row, cols: $max_col\n";


}

sub displayOutput()
{
	# output
	print "Total Flashes: $total_flashes\n";
}

sub processLine()
{
	my $row  = $_[0];
	my $line = $_[1];
	
	my $col = 0;
	foreach $energy_level (split('', $line))
	{
		$array[$row][$col] = $energy_level;
		$col++;	
	}
}

 
sub displayArray()
{
	for ($row = 0; $row < $max_row; $row++)
	{
		for ($col = 0; $col < $max_col; $col++)
		{
			print $array[$row][$col];
		}
		# end row
		print "\n";

	}
}

sub doStep()
{
	print "Step: $step\n";
	initializeHasFlashed();
	
	
	for ($row = 0; $row < $max_row; $row++)
	{
		for ($col = 0; $col < $max_col; $col++)
		{
			# increment energy levels
			giveEnergyToPosition($row, $col);
			checkFlashThresholdAtPosition($row, $col);
		}
		# end row
	}

	# count flashes	
	$total_flashes += countFlashes();
	resetLevelsAboveThreshold();
	
	print "After Step: $step\n";
	displayArray();

}

sub initializeHasFlashed()
{
	# at the start of each step, we zero out any flashes

	for ($row = 0; $row < $max_row; $row++)
	{
		for ($col = 0; $col < $max_col; $col++)
		{
			$has_flashed[$row][$col] = 0;
		}
		# end row
	}	
	
}



sub giveEnergyToNeighbors
{
	my $row = $_[0];
	my $col = $_[1];
	
	giveEnergyToPosition($row -1, $col -1);
	giveEnergyToPosition($row -1, $col);
	giveEnergyToPosition($row -1, $col + 1);
	
	giveEnergyToPosition($row, $col -1);
	giveEnergyToPosition($row, $col + 1);

	giveEnergyToPosition($row +1, $col -1);
	giveEnergyToPosition($row +1, $col);
	giveEnergyToPosition($row +1, $col + 1);
}

sub	giveEnergyToPosition()
{
	my $row = $_[0];
	my $col = $_[1];
	
	if ($row < 0) { return; }
	if ($row == $max_row) { return; }
	if ($col < 0) {return; }
	if ($col == $max_col) { return;}
	
	$array[$row][$col] += 1;
	checkFlashThresholdAtPosition($row, $col);

	return;	
}

sub checkFlashThresholdAtPosition()
{
	my $row = $_[0];
	my $col = $_[1];
	
	if (($array[$row][$col] > 9) && (! $has_flashed[$row][$col]))
	{ 
		# energy level high enough for flash, and we haven't flashed until now
		$has_flashed[$row][$col] = 1;	
		giveEnergyToNeighbors($row, $col);
	}
}

sub resetLevelsAboveThreshold()
{
	for ($row = 0; $row < $max_row; $row++)
	{
		for ($col = 0; $col < $max_col; $col++)
		{
			if ($array[$row][$col] > 9) 
			{ 
				$array[$row][$col] = 0;	
			}
		}
		# end row
	}	
}

sub countFlashes()
{
	my $count_flashes = 0;
	
	for ($row = 0; $row < $max_row; $row++)
	{
		for ($col = 0; $col < $max_col; $col++)
		{
			if ($has_flashed[$row][$col]) { $count_flashes++; }
		}
		# end row
	}	
	
#	print "$count_flashes\n";
	return $count_flashes;
}


