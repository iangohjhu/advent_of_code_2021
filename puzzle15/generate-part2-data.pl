# day15 part 2 this generates the five x larger map given the input

#$file='sample_input.txt';
$file='actual_input.txt';

my @cave_map; # the cave

my @max_row = 0;
my @max_col = 0;

my $lowest_total_risk = 0;

readInput($file);
expandMap(\@cave_map);
outputMap(\@cave_map);

exit;

sub readInput()
{
	my $file = $_[0];
	my $row = 0;

	open(INFO, $file) or die("Could not open file.");

	# read input into cave map
	foreach my $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;

		my $col = 0;
		foreach $value (split('', $line))
		{
			$cave_map[$row][$col] = $value;

			$col++;
		}
		$row++;
		$max_col = $col;
	}
	$max_row = $row;
	close(INFO);

}


sub outputMap()
{
	my $cave_ref = @_[0];
	my $cave_map = $cave_ref->[0];

 	for ($row = 0; $row < 5*$max_row; $row++)
 	{
 		for ($col = 0; $col < 5*$max_col; $col++)
 		{
 			print $cave_map[$row][$col];
 		}
 		# end row
 		print "\n";
 	}
}


sub expandMap()
{
	my $cave_ref = @_[0];
	my $cave_map = $cave_ref->[0];
	
	# repeat five times
	
	for ($tile_row = 0; $tile_row < 5; $tile_row++)
	{
		for ($tile_col = 0; $tile_col < 5; $tile_col++)
		{
 			for ($row = 0; $row < $max_row; $row++)
 			{
 				for ($col = 0; $col < $max_col; $col++)
 				{
 					my $value =  $cave_map[$row][$col] + $tile_row + $tile_col;
 					if ($value > 9)
 					{	
 						$value = $value - 9;
 					}
 					
 					$cave_map[($max_row * $tile_row) + $row][($max_col * $tile_col) + $col] = $value;
 				}
	 		}
 		}
	}
}