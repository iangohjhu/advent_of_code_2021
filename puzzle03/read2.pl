# day03 part 2 Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating, then multiply them together. What is the life support rating of the submarine? (Be sure to represent your answer in decimal, not binary.)

# $file='sample_input.txt';
# Final C02   : 01010
# Final Oxygen: 10111
# CO2 scrubber rating    : 10
# Oxygen generator rating: 23
# CO2 x Oxygen rating : 230

$file='actual_input.txt';
# Final C02   : 010010100110
# Final Oxygen: 100100101101
# CO2 scrubber rating    : 1190
# Oxygen generator rating: 2349
# CO2 x Oxygen rating : 2795310

$line_count = 0; 
$length_input = 0;
@co2_line_array;
@oxygen_line_array;

readInput($file);
$co2_output = processLinesCO2();
$oxygen_output = processLinesOxygen();
displayOutput($co2_output , $oxygen_output);
exit;

sub readInput
{
	my $file = $_[0];
	open(INFO, $file) or die("Could not open file.");

	foreach $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;
  
 		# store lines for later
		push(@co2_line_array, $line);
    	push(@oxygen_line_array, $line);
    		
    	if ($line_count == 0)
		{
			# get length of input string
			$length_input = length($line);

		}
	
		$line_count += 1;
	}
	close(INFO);
	print "\nRead $line_count lines, length: $length_input\n"; 

}

sub processLinesCO2()
{
	print "Processing CO2\n";

	for (my $i = 0; $i < $length_input; $i++)
	{
		my $count_zeroes = 0;
		my $count_ones = 0;

		# check bit at index
		my @zeroes_set = ();
		my @ones_set = ();

		if ( $#co2_line_array == 0)
		{
			#only one line left so exit
#			print  $co2_line_array[0] . "\n";
			return $co2_line_array[0];
		};
		
		foreach $line (@co2_line_array)
		{
			$bit = substr($line, $i, 1);
			if ($bit eq "0")
			{
				$count_zeroes += 1;
				push (@zeroes_set, $line);
			}
			else
			{
				$count_ones += 1;
				push (@ones_set, $line);
			}
		}

		print "At index $i, zeroes: $count_zeroes, ones: $count_ones\n";

		# find the least common value for CO2 scrubber rating
		# if count_zeroes <= count_ones, keep 0s

		if ($count_zeroes <= $count_ones)
		{
			# keep zeroes
			@co2_line_array = @zeroes_set;
		}	
		else
		{
			#keep ones
			@co2_line_array = @ones_set;
		}
	}
	
#	print  $co2_line_array[0] . "\n";
	return $co2_line_array[0];	
}


sub processLinesOxygen()
{
	print "Processing Oxygen\n";
	
	for (my $i = 0; $i < $length_input; $i++)
	{
		my $count_zeroes = 0;
		my $count_ones = 0;

		# check bit at index
		my @zeroes_set = ();
		my @ones_set = ();

		if ( $#oxygen_line_array == 0)
		{
			#only one line left so exit
#			print  $oxygen_line_array[0] . "\n";
			return $oxygen_line_array[0];
		};
		
		foreach $line (@oxygen_line_array)
		{
			$bit = substr($line, $i, 1);
			if ($bit eq "0")
			{
				$count_zeroes += 1;
				push (@zeroes_set, $line);
			}
			else
			{
				$count_ones += 1;
				push (@ones_set, $line);
			}
		}

		print "At index $i, zeroes: $count_zeroes, ones: $count_ones\n";

		# find the most common value for oxygen_generator_rating
		# if count_ones >= count_zeroes, keep 1s

		if ($count_ones >= $count_zeroes)
		{
			# keep ones
			@oxygen_line_array = @ones_set;
		}	
		else
		{
			#keep zeroes
			@oxygen_line_array = @zeroes_set;
		}
	}

#	print  $oxygen_line_array[0] . "\n";
	return $oxygen_line_array[0];	
}

sub displayOutput()
{
	my $co2_line    = $_[0];
	my $oxygen_line = $_[1];
	print "Final C02   : $co2_line\n";
	print "Final Oxygen: $oxygen_line\n";
	
	# convert to decimal
	my $co2_sum = 0;
	for ($i = 0; $i < $length_input; $i++)
	{
		$bit = substr($co2_line, $i, 1);
	 	$co2_sum += $bit * (2**($length_input - $i - 1));
	}

	# convert to decimal
	my $oxygen_sum = 0;
	for ($i = 0; $i < $length_input; $i++)
	{
		$bit = substr($oxygen_line, $i, 1);
	 	$oxygen_sum += $bit * (2**($length_input - $i - 1));
	}

	print "CO2 scrubber rating    : $co2_sum\n";
	print "Oxygen generator rating: $oxygen_sum\n";
	
	# product
	print "CO2 x Oxygen rating : " .  $co2_sum * $oxygen_sum . "\n";

}