#!/usr/bin/perl
#
my %degree_with_multiple_nodes = ();
my %keep_hash = ();

&read_in_counts_hash;
&make_keep_hash;

&loop_through_files;


sub loop_through_files
{
	foreach my $file (`ls My_own_randomized_network_STRING_*`)
	{
		chomp($file);
		&filter_network($file);
	}
}

sub filter_network
{
	my $file_in = shift;
	open(INFO, $file_in);

	my $file_out = $file_in."_UNIQUE_DEGREE.csv";
	open(OUT, ">$file_out");

	my $file_other = $file_in."_UNIQUE_DEGREE_EVERYTHING_ELSE.csv";
        open(OTHER, ">$file_other");
	while(<INFO>)
	{
		chomp;
		my ($node1, $node2, $junk1, $junk2) = split(/ /,$_);
		if((exists $keep_hash{$node1})||(exists $keep_hash{$node2}))
		{
			print OUT "$_\n";
		}
		else
		{
			print OTHER "$_\n";		
		}
	}
	close(INFO);
	close(OUT);
	close(OTHER);
}


sub make_keep_hash
{
        my $file_in = "String_PPI_hgnc_converted_score_gt_700_only_binding_CONVERTED_TO_CSV_UNIQUE_PPI_COUNTS_SORTED.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
                my ($count, $node) = split(/\t/,$_);
               
	 	if($degree_with_multiple_nodes{$count}	== 1)
		{
			$keep_hash{$node} = $node;
		}
        }
        close(INFO);
}




sub read_in_counts_hash
{
	my $file_in = "String_PPI_hgnc_converted_score_gt_700_only_binding_CONVERTED_TO_CSV_UNIQUE_PPI_COUNTS_SORTED.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($count, $node) = split(/\t/,$_);
		$degree_with_multiple_nodes{$count}++;
	}
	close(INFO);
}

