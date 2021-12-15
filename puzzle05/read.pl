# day05 part 1 Consider only horizontal and vertical lines. At how many points do at least two lines overlap?

# $file='sample_input.txt';
# Overlap: 5

$file='actual_input.txt';
# Overlap: 6007
 
# sample array
#$max_array = 9;

# actual array
$max_array = 1000;

# initialize array 
for ($y = 0; $y <= $max_array; $y++)
{
	for ($x = 0; $x <= $max_array; $x++)
	{
		$array[$x][$y] = 0;
	}
}

$overlap = 0;

readInput($file);
#		printArray();
checkOverlap();
displayOutput();
exit;

sub readInput()
{

	my $file = $_[0];
	open(INFO, $file) or die("Could not open  file.");

	foreach $line (<INFO>)  {   

		# trim white space at end
		$line =~ s/\s+$//;
 #   print $line;    
		processLine($line);
	}    

	close(INFO);

}

sub processLine ()
{
	my $line = $_[0];
	my @row = split(' ',$line);	
	my $xy1 = $row[0];
	my $xy2 = $row[2];

#		print "line xy1: $xy1 , xy2: $xy2\n";
	drawLine($xy1, $xy2);

}

sub drawLine ()
{
	my $xy1 = $_[0];
	my $xy2 = $_[1];

	my @xy1 = split(',', $xy1);
	my $x1 = $xy1[0];
	my $y1 = $xy1[1];
	
	my @xy2 = split(',', $xy2);
	my $x2 = $xy2[0];
	my $y2 = $xy2[1];

#	print "line xy1: $x1 $y1 , xy2: $x2 $y2\n";

	# if X stays the same
	if ($x1 == $x2)
	{
		# if y1 > y2, swap
		if ($y1 > $y2)
		{
			my $temp = $y1;
			$y1 = $y2;
			$y2 = $temp;
		}
		
		for ($y = $y1; $y <= $y2; $y++) 
		{
			$array[$x1][$y] += 1;
		}
	}
	# if Y stays the same
	if ($y1 == $y2)
	{
	
		# if x1 > x2, swap
		if ($x1 > $x2)
		{
			my $temp = $x1;
			$x1 = $x2;
			$x2 = $temp;
		}
		
		for ($x = $x1; $x <= $x2; $x++)
		{
			$array[$x][$y1] = $array[$x][$y1] + 1;
		}	
	}

} 


sub printArray ()
{
	for ($y = 0; $y <= $max_array; $y++)
	{
		for ($x = 0; $x <= $max_array; $x++)
		{
			print "$array[$x][$y] ";
		}
		print "\n"; #end row
	}
	print "\n";
} 


sub checkOverlap ()
{


	for ($y = 0; $y <= $max_array; $y++)
	{
		for ($x = 0; $x <= $max_array; $x++)
		{
			if ($array[$x][$y] >= 2)
			{
				#increment overlap
				$overlap += 1;
			}
		}
	}
} 

sub displayOutput()
{
	print "Overlap: $overlap\n";
}