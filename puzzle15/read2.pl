# day15 

# part 1 find a path with the lowest total risk.
# implementing Bellman Ford algorithm
# https://www.tutorialspoint.com/shortest-path-algorithm-in-computer-network

# part 2 just a larger input (5 x cave map)

# $file='sample2_input.txt';
# Lowest total risk : 315

$file='actual2_input.txt';
# Lowest total risk : 2899

my @cave_map; # the cave

my @max_row = 0;
my @max_col = 0;

my $lowest_total_risk = 0;

readInput($file);
#displayMap(\@cave_map);
start();
iterate();
displayOutput();

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

print "Read rows: $max_row, cols: $max_col\n";
}

sub displayOutput()
{
	print "Lowest total risk : " . $dist[$max_row -1][$max_col -1] . "\n";
}


sub displayMap()
{
	my $cave_ref = @_[0];
	my $cave_map = $cave_ref->[0];

 	for ($row = 0; $row < $max_row; $row++)
 	{
 		for ($col = 0; $col < $max_col; $col++)
 		{
 			print $cave_map[$row][$col];
 		}
 		# end row
 		print "\n";
 	}
 	print "\n";
}

sub start()
{

	# init set
	for ($row = 0; $row < $max_row; $row++)
 	{
 		for ($col = 0; $col < $max_col; $col++)
 		{
 			$dist[$row][$col] = -1;
 		}
 		# end col
 	}	
	# start position
	my $row = 0;
	my $col = 0;
	
	$dist[$row][$col] = 0;

}
 
sub iterate()
{
	my $total_iterations = $max_col * $max_row -1;
    my @dist_prev;

    for ($i = 0 ; $i < $total_iterations; $i++)
	{
		print "Step $i of $total_iterations\n";

        # store previous run
        for ($row = 0; $row < $max_row; $row++)
         {
             for ($col = 0; $col < $max_col; $col++)
             {
                 $dist_prev[$row][$col] = $dist[$row][$col];
             }
             # end col
         }
        
        
        for ($row = 0; $row < $max_row; $row++)
        {
            for ($col = 0; $col < $max_col; $col++)
            {
            
                my @neighbors = findNeighbors($row, $col);
			
                foreach $neighbor_ref (@neighbors)
                {
                    my ($nrow, $ncol) = @{$neighbor_ref};

                    $alt = $dist[$row][$col] + $cave_map[$nrow][$ncol];
                    if (($dist[$nrow][$ncol] == -1) ||  ($alt <  $dist[$nrow][$ncol]))
                    {
                        $dist[$nrow][$ncol] = $alt;
                    }
                }
            }
        } # end for
        
        # check if there's any difference between previous run and current
        my $diff = 0;
        
        for ($row = 0; $row < $max_row; $row++)
        {
            for ($col = 0; $col < $max_col; $col++)
            {
                if ($dist_prev[$row][$col] != $dist[$row][$col])
                {
                    $diff = 1;
                }
            
            #
            }
            # end col
        } # end for

        if ($diff == 0)
        {
           # no diff between prev run and current, so let's get out
           last;
        }

    } # end for iterate
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

