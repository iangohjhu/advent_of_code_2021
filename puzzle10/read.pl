# day10 part 1
# Find the first illegal character in each corrupted line of the navigation subsystem. What is the total syntax error score for those errors?


#$file='sample_input.txt';
# Total syntax error score: 26397

$file='actual_input.txt';
# Total syntax error score: 339477

my $valid_open_chars = "([{<";
my $valid_close_chars = ")]}>";
my @points_each_error = (3, 57, 1197, 25137); # based on position in valid_close_chars

my @errors_list;
my $max_row;

readInput($file);
outputErrors();
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
				# it's illegal
				# print "Expected " . expectedCloseChar($check_char) . ", but found " . $char . " instead. ($col)\n";
				push(@errors_list, "$char");
				# skip line
				last;
			}			
		}
		$col++;	
	}
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