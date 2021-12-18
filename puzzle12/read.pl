# day12 part 1 
# How many paths through this cave system are there that visit small caves at most once?

#$file='sample_input1.txt';
# Total paths: 10

#$file='sample_input2.txt';
# Total paths: 19

#$file='sample_input3.txt';
# Total paths: 226

$file='actual_input.txt';
# Total paths: 5457


my %cave_map;
my @list_of_paths;
my $total_paths;

readInput($file);
displayCave();

# start
my $current_path="";
visitCave($current_path, "start");

displayOutput();
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
		processLine($line);
			
		
		$row++;
	}
	$max_row = $row;
	close(INFO);


	print "Read rows: $max_row\n";


}

sub displayOutput()
{
	# output
	print "\nPaths:\n";
	foreach $path (@list_of_paths)
	{
		print $path . "\n";
	}
	print "Total paths: $total_paths\n";
	
}

sub processLine()
{
	my $line = $_[0];

	@parts = split('-', $line);
	
	@parts[0] =~ s/\s+$//;
	@parts[1] =~ s/\s+$//;

	# forward path
	if ($cave_map{$parts[0]} eq "")
	{
		$cave_map{$parts[0]} = "$parts[1]";
	}
	else
	{
		#append
		$cave_map{$parts[0]} .= ",$parts[1]";
	}

	# backward path
	if ($cave_map{$parts[1]} eq "")
	{
		$cave_map{$parts[1]} = "$parts[0]";
	}
	else
	{
		#append
		$cave_map{$parts[1]} .= ",$parts[0]";
	}	
}


sub displayCave()
{
	print "Cave Map:\n";
	for(keys %cave_map)
	{
		print " $_ -> $cave_map{$_}\n";
	}
	print "\n";
}
 
 sub visitCave()
 {
 	my $current_path = $_[0];
 	my $cave = $_[1];
 	
# 	print "Visiting $cave\n";


	# add cave to path
	if ($current_path eq "")
	{
		#initial cave
 		$current_path = "$cave";
 	}
  	else 
  	{
  		#add cave
  		$current_path .= ",$cave";
  	}
  		
#	print "current path: $current_path\n";
		
	if ($cave eq "end")
	{
		#finished a path
		push(@list_of_paths,$current_path);
		$total_paths += 1;
		return;
	}
		
	
 	# find caves to visit
	my @caves_to_visit = split(',', $cave_map{$cave});

	foreach $cave_to_visit (@caves_to_visit)
	{
		# visit those other caves except start
		if ($cave_to_visit eq "start")
		{
			# skip
			next;
		
		}

	 	if  ((isSmallCave($cave_to_visit)) && (haveVisitedCave($current_path, $cave_to_visit)))
		{
 			# already visited this small cave, skip
			next;
		}
		
#		print "I'd like to visit $cave_to_visit\n";
		visitCave($current_path, $cave_to_visit);
	} 	
 }
 
 sub isSmallCave
 {
 	my $cave = $_[0];
 	
 	if ($cave =~ /[a-z]/)
 	{
 #		print "$cave is a small cave\n";
 		return 1;
 	}
 	
#	print "$cave is a BIG cave\n";
 	return 0;
 }
 
 sub haveVisitedCave()
 {
  	my $current_path = $_[0];
 	my $cave = $_[1];
 
 
 	foreach $cave_in_path (split(',', $current_path))
 	{
 		if ($cave eq $cave_in_path)
 		{
 #			print "I have visited $cave before\n";
 			return 1;
 		}
	}
	
#	print "I have not visited $cave before\n";
	return 0;
 }
