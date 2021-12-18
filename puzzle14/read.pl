# day14 part 1 
# Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?

#$file='sample_input.txt';
#After step 10:
#N : 865
#B : 1749
#H : 161
#C : 298
#Least Common Element H : 161
#Most Common Element B : 1749
#Most - Least = 1588

$file='actual_input.txt';
#After step 10:
#H : 3037
#B : 1038
#S : 1201
#P : 2303
#K : 1983
#V : 1252
#F : 4156
#O : 1139
#C : 2179
#N : 1169
#Least Common Element B : 1038
#Most Common Element F : 4156
#Most - Least = 3118


$template;
%elements_count;
%pairs;
%pair_insertion_rules;

readInput($file);
countElementsInTemplate();
processTemplateIntoPairs();
displayInput();

$max_steps = 10;

for ($step = 1; $step <= $max_steps; $step++)
{
	processStep();
	displayOutput();
}	
exit;

sub readInput()
{
	my $file = $_[0];
	open(INFO, $file) or die("Could not open file.");

	my $line_count = 0;
	my $insertion_rule_count;
	
	# read input
	foreach my $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;
		
		if ($line_count == 0)
		{
			# it's the polymer template
			$template = $line;
		}
		elsif ($line eq "")
		{
			# blank line
			next;
		}
		else
		{
			# first two chars are the pair ab
			my $a = substr($line, 0, 1);
			my $b = substr($line, 1, 1);
			# followed by the insert c
			my $c = substr($line,6, 1); 
			#
			$pair_insertion_rules{"$a$b"} = "$c";

		}

					
		$line_count++;
	}
	close(INFO);


}

sub countElementsInTemplate()
{
	foreach $element (split('',$template))
	{
		$elements_count{"$element"} += 1;
	}
}

sub displayInput()
{
	print "Template: $template\n";
	
	foreach my $pair_chars (keys %pairs)
	{
		print $pair_chars . " : " . $pairs{"$pair_chars"} . "\n";
	}
	foreach my $pair_chars (keys %pair_insertion_rules)
	{
		print $pair_chars . "->" . $pair_insertion_rules{"$pair_chars"} . "\n";
	}
	
}

sub displayOutput()
{
	print "After step $step:\n";
	
	my $least = 0;
	my $lce;
	my $most = 0;
	my $mce;

	# breakdown by elements
	foreach $element (keys %elements_count)
	{
		print "$element : " . $elements_count{"$element"} ."\n";
		if (($least == 0) || ($elements_count{"$element"} < $least))
		{
			$least = $elements_count{"$element"};
			$lce   = $element;
		}
		if (($most == 0) || ($elements_count{"$element"} > $most))
		{
			$most = $elements_count{"$element"};
			$mce  = $element;
		}	
	}

	print "Least Common Element $lce : $least\n";
	print "Most Common Element $mce : $most\n";
	print "Most - Least = "  . ($most - $least) . "\n";	
}
	
sub processTemplateIntoPairs()
{
	for ($i = 0; $i < length($template) - 1; $i++)
	{
		my $pair_chars = substr($template, $i, 2);
		$pairs{"$pair_chars"} += 1;
	}
}

sub processStep()
{
	my %pairs_after_step;
	
	# initialize pairs after step
	foreach my $pair_chars (keys %pairs)
	{
		$pairs_after_step{"$pair_chars"} = $pairs{"$pair_chars"};
	}

	foreach my $pair_chars (keys %pairs)
	{
		# process rules
		if ($pair_insertion_rules{"$pair_chars"} ne "")
		{
			#apply rule
			my ($a, $b) = split('', $pair_chars);
			my $c = $pair_insertion_rules{"$pair_chars"} ; 
#			print "Applying rule ". $pair_chars . " -> $a$c,$c$b\n";
	
			# increment element c count by number of existing pair_char
			$elements_count{"$c"} += $pairs{"$pair_chars"};
			# increment count of new_pairs by number of existing pair_chars
			$pairs_after_step{"$a$c"} += $pairs{"$pair_chars"};
			# increment count of new_pairs[1] by number of existing pair_chars
			$pairs_after_step{"$c$b"} += $pairs{"$pair_chars"};
			
			# decrement count of original pairs
			$pairs_after_step{"$pair_chars"} -=  $pairs{"$pair_chars"};

		}
	}
	
	# update pairs
	%pairs = %pairs_after_step;
}