# day09 part 1 Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?

#$file='sample_input.txt';
# sum risk levels: 15

$file='actual_input.txt';
# sum risk levels: 496

my @vent_array;
my @max_row = 0;
my @max_col = 0;
my $sum_risk_levels = 0;

readInput($file);
#displayArray();
processArray();
displayOutput();
exit;

sub readInput()
{
	my $file = $_[0];
	
	my $row = 0;

	open(INFO, $file) or die("Could not open file.");

	# read input into vent array
	foreach my $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;

		my $col = 0;
		foreach $value (split('', $line))
		{
			$vent_array[$row][$col] = $value;
			$col++;
		}
		$row++;
		$max_col = $col;
	}
	$max_row = $row;
	close(INFO);

print "Read rows: $max_row, cols: $max_col\n";
}

sub displayArray()
{
	my $line = @_[0];

 	for ($row = 0; $row < $max_row; $row++)
 	{
 		for ($col = 0; $col < $max_col; $col++)
 		{
 			print $vent_array[$row][$col];
 		}
 		# end row
 		print "\n";
 	}
 	print "\n";
}

sub displayOutput()
{
	print "sum risk levels: $sum_risk_levels\n";
}

sub processArray()
{
	my $line = @_[0];

 	for ($row = 0; $row < $max_row; $row++)
 	{
 		for ($col = 0; $col < $max_col; $col++)
 		{
 			if (checkNeighbors($row,$col))
 			{
# 				print "row: $row, col: $col, val: $vent_array[$row][$col]\n";
 				# add to sum of risk levels
 				$sum_risk_levels += (1 + $vent_array[$row][$col]);
 			};
 		}
 		# end row
 	}
}


sub checkNeighbors()
{
	# return 1 if current is lower than neighbors
	
	my $row = @_[0];
	my $col = @_[1];

	my $current_is_lowest = 1;
	
	# current value
	$my_value = $vent_array[$row][$col];
	
	# check left neighbor
	if (($col -1 ) >= 0)
	{
		if ($my_value >= $vent_array[$row][$col -1])
		{
			# my value not lowest
			$current_is_lowest = 0;
		}
	}	
	
	# check right neighbor
	if (($col + 1) < $max_col)
	{
		if ($my_value >= $vent_array[$row][$col +1])
		{
			# my value not lowest
			$current_is_lowest = 0;
		}

	}
	
	# check up neighbor
	if (($row -1 ) >= 0)
	{
		if ($my_value >= $vent_array[$row - 1][$col])
		{
			# my value not lowest
			$current_is_lowest = 0;
		}
	}	

	# check down neighbor
	if (($row + 1) < $max_row)
	{
		if ($my_value >= $vent_array[$row + 1][$col])
		{
			# my value not lowest
			$current_is_lowest = 0;
		}
	}


	return $current_is_lowest;

}