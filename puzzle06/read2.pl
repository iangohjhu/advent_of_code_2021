# day06 part 2 How many lanternfish would there be after 256 days?

# get list of lantern fish states
#$file='sample_input.txt';
# After 18 days Total : 26
# After 80 days Total : 5934

# actual input
$file='actual_input.txt';
# After 80 days Total : 361169
# After 256 days Total : 1634946868992

# $max_days = 18;
my $max_days = 256;

@fish_by_age_array;

readInput($file);
processDays($max_days);
displayOutput();
exit;

sub readInput()
{
	my $file = $_[0];
	
	my @fish_array;
	
	open(INFO, $file) or die("Could not open file.");

	foreach $line (<INFO>)  
	{   
		# trim white space at end
		$line =~ s/\s+$//; 
		@fish_array = split(',', $line);

	}

	# should only be one line
	close(INFO);
	
	# initialize fish_by_age_array

	foreach my $i (0..8 )
	{
		 $fish_by_age_array[$i] = 0;
	}


	foreach my $i (0 .. (@fish_array -1))
	{
		# store fish by age
		my $fish_age = $fish_array[$i];
		$fish_by_age_array[$fish_age] += 1;
	}
}

sub processDays()
{
	my $max_days = $_[0];

	foreach $day (0.. $max_days) 
	{

		if ($day == 0) {
#			displayFishByAge($day);
			next;
		}

#		displayFishByAge($day);
		decrementFishTimer();
	
	}
}



sub displayFishByAge()
{
	my $day = $_[0];

	if ($day == 0) 
	{
		print "Initial state: \n";
	} 
	elsif ($day == 1 ) 
	{
			print "After 1 day: \n";
	} 
	elsif ($day > 1) 
	{
		print "After $day days: \n";
	}
			
	foreach my $i (0..8 )
	{
		print "Age : $i, Num Fish: $fish_by_age_array[$i]\n";
	}
	
}

sub displayOutput()
{
	my $total_fish = 0;
	
	foreach my $i (0..8 )
	{
		$total_fish += $fish_by_age_array[$i];
	}

	print "After $max_days days Total : $total_fish\n";
}

sub decrementFishTimer()
{

	my @new_fish_by_age_array;
	
	# initialize new_fish_by_age_array
	foreach my $i (0..8 )
	{
		 $new_fish_by_age_array[$i] = 0;
	}
	
	# for ages 1 .. 8 just move to previous slot
	foreach my $i (1..8 )
	{
		@new_fish_by_age_array[$i - 1] = $fish_by_age_array[$i];
	}

	# for age 0, reset to age 6 and add new fish to age 8
	@new_fish_by_age_array[6] += $fish_by_age_array[$0];
	@new_fish_by_age_array[8] += $fish_by_age_array[$0];
	
	#make current fish_by_age_array = new array
	@fish_by_age_array = @new_fish_by_age_array;
}
