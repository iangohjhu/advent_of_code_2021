# day08 part 1 In the output values, how many times do digits 1, 4, 7, or 8 appear?

#$file='sample_input.txt';
# Saw 26 1, 4, 7, or 8 in output

$file='actual_input.txt';
# Saw 383 1, 4, 7, or 8 in output

$total_count = 0;

readInput($file);
displayOutput();
exit;


sub readInput()
{
	my $file = $_[0];
	
	open(INFO, $file) or die("Could not open file.");

	foreach my $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;
 #   	print $line;    

		# our number segments array; it'll be different for each line read
		my @number_segments;
 
	
		foreach $i (0..9)
		{
			$number_segments[$i] = 0;
		}	
	
		processLine($line);
	}
	close(INFO);
}

sub displayOutput()
{
	print "Saw $total_count 1, 4, 7, or 8 in output\n";
}

sub processLine()
{
	my $line = @_[0];

	# init our number hash array
	my %number_hash;
	
	# find pipe (|)
	my $pipe_loc = index($line, "|");

	# left side = signal patterns
	my $signal_patterns = substr($line, 0, $pipe_loc -1);

	#  right side = output values
	my $output_values = substr($line, $pipe_loc + 1, length($line) - $pipe_loc -1);

#	print "signal patterns: "  . $signal_patterns . "\n";
#	print "output values  : " . $output_values . "\n";

	# sort our signal patterns by length
	my @length_two_words;
	my @length_three_words;
	my @length_four_words;
	my @length_seven_words;
	my @length_six_words;
	my @length_five_words;

	foreach my $word (split(' ', $signal_patterns))
	{
		my $len = length($word);

		if ($len == 2)
		{
			push(@length_two_words, $word);
		} 
		elsif ($len == 3)
		{
			push(@length_three_words, $word);
		}
		elsif ($len == 4)
		{
			push(@length_four_words, $word);
		} 
		elsif ($len == 5)
		{
			push(@length_five_words, $word);
		}
		elsif ($len == 6)
		{
			push(@length_six_words, $word);
		}	
		elsif ($len == 7)
		{
			push(@length_seven_words, $word);
		}		
	}


	# want to process in this order of string length
	# testing length two , must be 1
	returnNumber($length_two_words[0]) . "\n"; 
#	print $number_segments[1] . "\n";
	
	# testing length three, must be 7
	returnNumber($length_three_words[0]) . "\n";

	# testing length four, must be 4
	returnNumber($length_four_words[0]). "\n";

	# testing length seven, must be 8
	returnNumber($length_seven_words[0]) . "\n";

# seven contains one
#if (str1ContainsStr2($number_segments[7], $number_segments[1]))
#{
#	print "seven contains a one\n";
#};


	# try length six
	returnNumber($length_six_words[0]) . "\n";
	returnNumber($length_six_words[1]) . "\n";
	returnNumber($length_six_words[2]) . "\n";


	# try length five
	returnNumber($length_five_words[0]) . "\n";
	returnNumber($length_five_words[1]) . "\n";
	returnNumber($length_five_words[2]) . "\n";

	# generate hashes from string to value
	for $i (0 .. 9)
	{
		my $str = $number_segments[$i];
		$number_hash{$str} = $i;
	}
	
	# now try the output
	foreach $word (split(' ',$output_values))
	{
#		print "output: " . $word . "\n";
		$value = $number_hash{sortStr($word)};
		if ($value == 1 || $value == 4 || $value == 7 || $value == 8)
		{
			$total_count++;
		}
	}
}

sub returnNumber ()
{
	my $str = @_[0];
	my $value = -1; #return -1 if it's not a number we know
	
	# if length two, it's a one
	if (length($str) == 2)
	{
		# found a one
		$value = 1;

	}
	
	# if lenth three, it's a seven
	if (length($str) == 3)
	{
		# found a seven
		$value = 7;
	}	
	
	# if length four, it's a four
	if (length($str) == 4)
	{
		# found a four
		$value = 4;
	}		

	# if length five, it could be a 2, 3 or 5
	if (length($str) == 5)
	{
		# does this contain a seven, if so, it has to be a 3
		if (str1ContainsStr2($str, $number_segments[7]))
		{
			$value = 3;
		}
		else
		{
#			print "Could be a 2 or 5\n";
			# check how many matches to a four
			if (str1IsTwo($str))
			{
				$value = 2;
			}
			else
			{
				$value = 5;

			}
		}
	}		

	# if length six, it could be a 6,9,0
	if (length($str) == 6)
	{

		# does this contain a seven, if so, it could be 9 or 0, but cannot be a 6
		if (str1ContainsStr2($str, $number_segments[7]))
		{
#			print "could be a 9 or 0\n";
			# does it contain a four, if so, it's a 9
			if (str1ContainsStr2($str, $number_segments[4]))
			{
				$value = 9;
			}
			else
			{
				# else it's a 0
				$value = 0;
			}
		}
		else
		{
			$value = 6;
		}
	}		
	
	# if length seven, it's a eight
	if (length($str) == 7)
	{
		# found a eight
		$value = 8;
	}		
	
	if ($value > -1) {
		# store the segments
		$number_segments[$value] = sortStr($str);
	}
	return $value;
}


sub str1ContainsStr2 ()
{
	my $str1 = @_[0];
	my $str2 = @_[1];
	
	$match = 0;
	
	
	# to check if str1 contains str2
	foreach $char (split('',$str2))
	{
#		print "Checking if $char in $str1\n";
		if (index($str1, $char) > -1)
		{
			$match++;
		}
	
	}
	
	# check if number of matches = length $str2 (means we matched all chars)
	if ($match == length($str2))
	{
		# str1 contains str2
		return 1;
	}
	
	# str1 doesn't contain str2
	return 0;
}


sub str1IsTwo ()
{
	my $str1 = @_[0];
	my $str2 = $number_segments[4];
	
	$match = 0;
	
	
	# to check if str1 contains str2
	foreach $char (split('',$str2))
	{
#		print "Checking if $char in $str1\n";
		if (index($str1, $char) > -1)
		{
			$match++;
		}
	
	}

	if ($match == 2)
	{
		# matches four in two places so it's two
		return 1;
	}
	
	# it's not a two
	return 0;
}

sub sortStr()
{
	my $str =@_[0];
	
	my $list = "abcdefg";
	my @char_array;
	
	foreach my $char (split('', $str))
	{
		$char_array[index($list,  $char)] = $char;
	}

	return join('',@char_array);
}