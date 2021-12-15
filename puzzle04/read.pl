# day04 part 1 figure out which board will win first. What will your final score be if you choose that board?

#$file='sample_input.txt';
# Card 2, computing score
# Score: 188 X 24 = 4512

$file='actual_input.txt';
# Card 11, computing score
# Score: 473 X 49 = 23177

$total_cards = 0;
@calls;
@card_stack;

readInput($file);
processCalls();
exit;

sub readInput()
{
	my $file = $_[0];
	
	open(INFO, $file) or die("Could not open file.");

	my $line_count = 0;
	my $card_num = 0;
	my $card_row = 0;

	foreach $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;
 #   print $line;    

		# first line in input are the calls
    
    	if ($line_count == 0)
		{
			# store calls
			@calls = split(',', $line);
			$line_count++;
			next; 
		}

		# skip blank line between rows
		if ($line eq "") 
		{ 		
			$line_count++;
			next; 
		}

		# split line by spaces
		@row = split(' ',$line);	
	
		for ($j =0; $j < 5; $j++)
		{
			$card_stack[$card_num][$card_row][$j] = $row[$j];
		}
	
		if ($card_row < 4)
		{
			$card_row += 1;	
		}
		else
		{
			$card_row = 0;
			$card_num += 1;
		}
		
		$line_count++;
	}
	close(INFO);
	
	$total_cards = $card_num; 

	print "Read $total_cards cards\n";
}


sub processCalls()
{
	foreach my $call (@calls)
	{
		for (my $card  = 0; $card < $total_cards; $card++ )
		{
			matchCard($card, $call);
			displayCard($card);
			if (checkCardBingo($card))
			{
				print "Bingo!\n";
				scoreCard($card, $call);
				exit;
			}
		}
	}
}


sub displayCard ()
{
	$card_num = $_[0];

	print "Card $card_num\n";	
	for ($i = 0; $i < 5; $i++)
	{
		for ($j =0; $j <5; $j++) 
		{
			print $card_stack[$card_num][$i][$j] . " ";
		}
		print "\n";
	}

	print "\n";
} 


sub matchCard ()
{
	$card_num = $_[0];
	$call = $_[1];

	print "Card $card_num, checking for $call\n";	
	for ($i = 0; $i < 5; $i++)
	{
		for ($j =0; $j <5; $j++) 
		{
			if ($card_stack[$card_num][$i][$j] == $call)
			{
				# match
				print "Card: $card_num, match $call, at $i $j\n";
				#
				$card_stack[$card_num][$i][$j] = -1;
			}
		}
	}
} 

sub checkCardBingo()
{
	$card_num = $_[0];
	print "Card $card_num, checking for Bingo\n";	
	
	my $bingo = 0;
	
	# check row for bingo (if all -1, then Bingo)
	for ($i = 0; $i < 5; $i++)
	{
		my $row_value = 0;
		
		for ($j = 0; $j < 5; $j++)
		{
			$row_value += $card_stack[$card_num][$i][$j];
		}
	
		if ($row_value == -5)
		{
			$bingo = 1;
		}
	}
	
	# check column for Bingo (if all -1, then Bingo)		
	for ($j = 0; $j < 5; $j++)
	{
		my $col_value = 0;
		
		for ($i = 0; $i < 5; $i++)
		{
			$col_value += $card_stack[$card_num][$i][$j];
		}
			
	
		if ($col_value == -5)
		{
			$bingo = 1;
		}
	}	
	
	return $bingo;
}


sub scoreCard ()
{
	$card_num = $_[0];
	$call = $_[1];

	print "Card $card_num, computing score\n";	
	
	$sum_unmarked_numbers = 0;
	
	for ($i = 0; $i < 5; $i++)
	{
		for ($j =0; $j <5; $j++) 
		{
			if ($card_stack[$card_num][$i][$j] > -1)
			{
				$sum_unmarked_numbers += $card_stack[$card_num][$i][$j];
			}
		}
	}
	
	$score = $sum_unmarked_numbers * $call;
	
	print "Score: $sum_unmarked_numbers X $call = $score\n;"
} 