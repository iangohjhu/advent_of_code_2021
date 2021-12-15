# day09 part 2 Find the three largest basins and multiply their sizes together

# $file='sample_input.txt';
# 14 x 9 x 9 = 1134

$file='actual_input.txt';
# 99 x 96 x 95 = 902880

my @height_map; # the heightmap 
my @basin_list; # list of basin locations found on the map
my @basin_map;
my @max_row = 0;
my @max_col = 0;
my $number_of_lowest_points_found = 0;

readInput($file);

processArray(); #find the lowest points

# check neighbors of each lowest points, can we add them to our basin
foreach $i (1..$number_of_lowest_points_found)
{
	my @basin = split(',',$basin_list[$i]);
	my $row = $basin[0];
	my $col = $basin[1];
	my $height = $height_map[$row][$col];
#	print "Row: $row, Col: $col, Basin: $i, Height: $height\n";


	my @neighbors = findNeighbors($row,$col);
	foreach $neighbor_ref (@neighbors)
	{
		my $nrow = @{$neighbor_ref}[0];
		my $ncol = @{$neighbor_ref}[1];
		checkNeighborsBasinMap($nrow, $ncol, $i, $height);
	}
}

# displayBasinMap();
countBasinSize();

exit;

sub readInput()
{
	my $file = $_[0];
	my $row = 0;

	open(INFO, $file) or die("Could not open file.");

	# read input into height map
	foreach my $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;

		my $col = 0;
		foreach $height (split('', $line))
		{
			$height_map[$row][$col] = $height;
			#
			# init basin_map = -1
			$basin_map[$row][$col] = -1;
			
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
 			print $height_map[$row][$col];
 		}
 		# end row
 		print "\n";
 	}
 	print "\n";
}


sub countBasinSize()
{
	my @array; # to hold all the basin sizes
	my @basin_counts;
	
	# count the size of each marked basin
 	for ($row = 0; $row < $max_row; $row++)
 	{
 		for ($col = 0; $col < $max_col; $col++)
 		{
 			my $basin = $basin_map[$row][$col];
 			if ($basin >= 0)
 			{
 				$basin_counts[$basin] += 1;
 			}
 		}
 		# end row
 	}
 	
 	foreach $i (1..(@basin_counts -1))
 	{
 		my $size = $basin_counts[$i];
 		print "Basin: $i, Size: $size\n";
 		push(@array, $size);
 	}
 	 
 	# sort  basin sizes from largest to smallest 	
	my @sorted_array = sort { $b <=> $a } @array;
 	
 	# find three largest basins and multiply their sizes together
 	print "$sorted_array[0] x $sorted_array[1] x $sorted_array[2] = " . $sorted_array[0] * $sorted_array[1]* $sorted_array[2] . "\n";
}


sub processArray()
{
	# find all the lowest points on the map
	
 	for ($row = 0; $row < $max_row; $row++)
 	{
 		for ($col = 0; $col < $max_col; $col++)
 		{
 			if (checkNeighbors($row,$col))
 			{
 				# this is a low point compared to its neighbors
				$number_of_lowest_points_found++;
				
 				# store in basin_list the position
 				$basin_list[$number_of_lowest_points_found] = "$row,$col";

				# store in basin_map a number for each basin found
				$basin_map[$row][$col] = $number_of_lowest_points_found;
 			};
 		}
 		# end row
 	}
}


sub checkNeighbors()
{
	# return 1 if my height is lower than neighbors
	
	my $row = @_[0];
	my $col = @_[1];

	my $my_height_is_lower = 1; # start optimistic
	
	# current value
	$my_height = $height_map[$row][$col];
	
	
	# check my neighbors' heights
	my @neighbors = findNeighbors($row,$col);
	foreach $neighbor_ref (@neighbors)
	{
		my ($nrow, $ncol) = @{$neighbor_ref};

		if ($my_height >= $height_map[$nrow][$ncol])
		{
			# my height not lowest
			$my_height_is_lower = 0;
		}
	}	
	
	return $my_height_is_lower;

}

sub checkNeighborsBasinMap()
{
	# check position row, col 
	# if my height is greater than or equal to the height to check, add to the basin passed
	
	my $row    = @_[0];
	my $col    = @_[1];
	my $basin  = @_[2];
	my $height = @_[3];

	
	
	# current value
	$my_height = $height_map[$row][$col];
	$my_basin_value = $basin_map[$row][$col];
	
	# check my value against value passed
		
	if ($my_height == 9)	
	{
		# I can't be part of basin
		$basin_map[$row][$col] = 0;
		return;
	}
	
	if ($my_basin_value >= 0)
	{
		# i'm already part of another basin 
		return;
	}
	
	if ($my_height >= $height)
	{
		# i can flow into basin, so add me to this basin

		$my_basin_value = $basin;
		$basin_map[$row][$col] = $basin;


		# check my neighbors
		my @neighbors = findNeighbors($row,$col);
		foreach $neighbor_ref (@neighbors)
		{
			my ($nrow, $ncol) = @{$neighbor_ref};
			checkNeighborsBasinMap($nrow, $ncol, $basin, $height);
		}
	}


	return;

}


sub findNeighbors()
{
	# check position row, col 
	# if my value is greater than or equal to the value to check, add to the basin passed
	
	my $row   = @_[0];
	my $col   = @_[1];
	my @list_of_neighbors;

	# can we go right?
	if (($col + 1) < $max_col)
	{
		push(@list_of_neighbors,[$row, $col + 1]);
	}
	
	# can we go left?
	if (($col - 1) >= 0)
	{
		push(@list_of_neighbors,[$row, $col - 1]);
	}	

	# can we go down?
	if (($row + 1) < $max_row)
	{
		push(@list_of_neighbors,[$row + 1, $col]);
	}

	# can we go up?
	if (($row - 1) >= 0)
	{
		push(@list_of_neighbors,[$row - 1, $col]);
	}		

	return @list_of_neighbors;
}
