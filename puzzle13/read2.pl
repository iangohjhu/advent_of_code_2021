# day13 part 2 
# Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.
# What code do you use to activate the infrared thermal imaging camera system?

$file='actual_input.txt';
# RLBCJGLU

$max_x=0;
$max_y=0;
@paper_array;
@fold_instructions;
$total_dots = 0;

readInput($file);
processFoldInstructions();

countDots();
displayOutput();
exit;

sub readInput()
{
	my $file = $_[0];
	open(INFO, $file) or die("Could not open file.");

	# read input into paper array
	foreach my $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;
		
		processLine($line);
			
	}
	close(INFO);


}

sub displayOutput()
{
	# output
	print "Total dots: $total_dots\n";
	
}

sub processLine()
{
	my $line = $_[0];

	if ($line =~ /fold along/)
	{
		# instructions
		push(@fold_instructions, $line);
	}
	elsif ($line =~ ",")
	{	
		# it's a dot position
		my @pos = split (',', $line);
		my $x = $pos[0];
		my $y = $pos[1];
		$paper_array[$x][$y] = 1;
		
		print "dot: $x, $y\n";
		
		if ($x > $max_x)
		{
			# track largest x
			$max_x = $x;
		}
		
		if ($y > $max_y)
		{
			# track largest y
			$max_y = $y;
		}
	}
}

sub processFoldInstructions()
{
	foreach $instruction (@fold_instructions)
	{
		processFold($instruction);
		displayPaper();
	}

}

sub processFold()
{
	my $instruction = $_[0];

	my $idx = index($instruction, "x=");
	if ($idx > -1)
	{
		# it's a fold along x instruction
		my $fold_x = substr($instruction, $idx+2, length($instruction - $idx) +1);
		foldAlongX($fold_x);
	}
	my $idx = index($instruction, "y=");
	if ($idx > -1)
	{
		# it's a fold along y instruction
		my $fold_y = substr($instruction, $idx+2, length($instruction - $idx) +1);
		foldAlongY($fold_y);
	}
}



sub displayPaper()
{
	print "Paper: $max_x x $max_y\n";

	for ($y = 0; $y <= $max_y; $y++)
	{
		for ($x = 0; $x <= $max_x; $x++)
		{
			if ( $paper_array[$x][$y] > 0 )
			{
				print "#";
			} 
			else
			{
				print ".";
			}
		}
		# end row
		print "\n";
	}
	print "\n";
}

sub countDots()
{
	print "Paper: $max_x x $max_y\n";

	$total_dots = 0;
	
	for ($y = 0; $y <= $max_y; $y++)
	{
		for ($x = 0; $x <= $max_x; $x++)
		{
			if ( $paper_array[$x][$y] > 0 )
			{
				$total_dots++;
			} 
		}
		# end row
	}
}

sub foldAlongX()
{
	my $fold_x = $_[0];

	print "Fold Along X=$fold_x\n";
	
	for ($y = 0; $y <= $max_y; $y++)
	{
		for ($x = $fold_x; $x <= $max_x; $x++)
		{
			# any x  after pos fold x becomes x - 2*(x-fold_x) 
			my $new_x = $x - 2*($x - $fold_x);
			
			# if either position has a dot, it'll stay a dot
			$paper_array[$new_x][$y] += $paper_array[$x][$y];	
		}
	}
	
	# update max_x
	$max_x = $fold_x -1;
}

sub foldAlongY()
{
	my $fold_y = $_[0];
	
	print "Fold Along Y=$fold_y\n";
	
	for ($x = 0; $x <= $max_x; $x++)
	{
		for ($y = $fold_y; $y <= $max_y; $y++)
		{
			# any y after pos fold y becomes y - 2*(y-fold_y)
			my $new_y = $y - 2*($y - $fold_y);
			
			# if either position has a dot, it'll stay a dot
			$paper_array[$x][$new_y] += $paper_array[$x][$y];
		}
	}
	
	#update max_y
	$max_y = $fold_y -1;
}