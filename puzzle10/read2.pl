# day10 part 2  
# Find the completion string for each incomplete line, score the completion strings, and sort the scores. What is the middle score?

# $file='sample_input.txt';
# middle score: 288957

$file='actual_input.txt';
# middle score: 3049320156

my $valid_open_chars = "([{<";
my $valid_close_chars = ")]}>";
my @points_each_error = (3, 57, 1197, 25137); # based on position in valid_close_chars
my @points_each_incomplete = (1, 2, 3, 4); # based on position in valid_close_chars
my @errors_list;
my @incompletes_list;

my $max_row;

readInput($file);
outputErrors();
outputIncompletes();

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

		processLine($row, $line);
		$row++;
	}
	$max_row = $row;
	close(INFO);

	print "Read rows: $max_row\n";


}

sub processLine()
{
	my $row  = $_[0];
	my $line = $_[1];
	my @stack;
	
	my $col = 0;
	
	my $illegalFlag = 0;
	
	foreach $char (split('', $line))
	{
		if (index($valid_open_chars, $char) >= 0)
		{
			# store open char
			push (@stack, $char);
		}
		if (index($valid_close_chars, $char) >= 0)
		{
			# it's a closing char
			# pop stack, check for opening char
			$check_char = pop(@stack);
			# legal?
			if (legalChunk($check_char, $char))
			{
				# ok
			}
			else
			{
				# it's illegal char
				$illegalFlag = 1;
				# print "Expected " . expectedCloseChar($check_char) . ", but found " . $char . " instead. ($col)\n";
				push(@errors_list, "$char");
				# skip line
				last;
			}			
		}
		$col++;	
	}
	
	# what's the state of the stack, are there any remaining chars?
	if  ((! $illegalFlag) && (scalar @stack > 0))
	{
		# store the remaining items in the incomplete_list
		push(@incompletes_list, join('', @stack));
	}
}


sub outputIncompletes()
{
	my @completion_scores;
	
	print "Incompletes found:\n";
	my $i = 0;
	
	foreach $line (@incompletes_list)
	{
		print $line . " ";
		@completion_scores[$i] = completeIncompletes($line);
		$i++;
	}
	
	$num_incompletes = scalar @incompletes_list;
	# sort completion_scores
	my @sorted_completion_scores = sort { $a <=> $b } @completion_scores;

	# find the "middle" score
	print "middle score: " . $sorted_completion_scores[$num_incompletes/2] ."\n";
}


sub completeIncompletes()
{
	my $line = $_[0];

	my $closing_string = "";
	my $completion_score = 0;
	
	my @stack = split('', $line);
	while (@stack)
	{
		my $char = pop(@stack);
		# find closing character
		 $closing_string .= expectedCloseChar($char);
		 # update score 5 * prior score + points for the closing character
		 $completion_score = ($completion_score * 5) + $points_each_incomplete[index($valid_close_chars, expectedCloseChar($char))];
	}	
	
	print "$closing_string  - $completion_score\n";
	return $completion_score;
}

sub expectedOpenChar()
{
	my $char = $_[0];
	
	$i = index($valid_close_chars, $char);
	
	return substr($valid_open_chars, $i, 1);
}

sub expectedCloseChar()
{
	my $char = $_[0];
	
	$i = index($valid_open_chars, $char);
	
	return substr($valid_close_chars, $i, 1);
}

sub legalChunk()
{
	my $open_char = $_[0];
	my $close_char = $_[1];
	
	my $legal = 0;
	
	if (($open_char eq "(") && ($close_char eq ")"))
	{
		$legal = 1;
	}
	if (($open_char eq "[") && ($close_char eq "]"))
	{
		$legal = 1;
	}
	if (($open_char eq "{") && ($close_char eq "}"))
	{
		$legal = 1;
	}
	if (($open_char eq "<") && ($close_char eq ">"))
	{
		$legal = 1;
	}
	
	return $legal;
}

sub outputErrors()
{

	my $total_error_score = 0;
	
	print "Errors found:\n";
	foreach $error_char (@errors_list)
	{
		print $error_char . " ";
		my $error_value = $points_each_error[index($valid_close_chars, $error_char)];
		$total_error_score += $error_value;
		print $error_value . "\n";
	}
	
	print "Total syntax error score: $total_error_score\n";
}
