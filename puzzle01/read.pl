# day01 part 1  count the number of times a depth measurement increases from the previous measurement.

#$file='sample_input.txt';
# There are 7 measurements that are larger than previous measurement.

$file='actual_input.txt';
# There are 1711 measurements that are larger than previous measurement.

# holds the number of times a depth measurement increases from the previous measurement
$count = 0; 

readInput($file);
displayOutput();

exit;

sub readInput()
{
	my $file = $_[0];
	open(INFO, $file) or die("Could not open file.");

	my $row = 0;
	my $previous_measurement = 0;
	
	foreach my $measurement (<INFO>)  {   
		# trim white space at end
		$measurement =~ s/\s+$//;

		processLine($measurement, $previous_measurement);

		$row++;
		$previous_measurement = $measurement;
	}
	close(INFO);

	$max_row = $row;
	close(INFO);

	print "Read rows: $max_row\n";

}

sub processLine()
{
	my $measurement          = $_[0];
	my $previous_measurement = $_[1];
	

	if ($previous_measurement > 0)
	{
		if ($measurement > $previous_measurement)
		{
			# depth measurement increased
			$count++;
		}
	}
}

sub displayOutput()
{
	print "There are $count measurements that are larger than previous measurement.\n";

}