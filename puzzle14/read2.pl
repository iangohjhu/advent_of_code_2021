# day14 part 2 
# Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?

#$file='sample_input.txt';
#After step 40:
#N : 1096047802353
#C : 6597635301
#B : 2192039569602
#H : 3849876073
#Least Common Element H : 3849876073
#Most Common Element B : 2192039569602
#Most - Least = 2188189693529

$file='actual_input.txt';
#After step 40:
#F : 5261970270224
#K : 1830815304037
#V : 1487519108047
#O : 1350726992433
#B : 929082822053
#P : 2393361822903
#C : 2200912037121
#H : 3280326752359
#S : 1115359269491
#N : 1040646549077
#Least Common Element B : 929082822053
#Most Common Element F : 5261970270224
#Most - Least = 4332887448171


$template;
%elements_count;
%pairs;
%pair_insertion_rules;

readInput($file);
countElementsInTemplate();
processTemplateIntoPairs();
displayInput();

$max_steps = 40;

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