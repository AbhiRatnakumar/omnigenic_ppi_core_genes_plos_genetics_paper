#!/usr/bin/perl

my %degree_with_multiple_nodes = ();
my %keep_hash = ();

&read_in_counts_hash;
&make_keep_hash;
&filter_network;

sub filter_network
{
	my $file_in = "My_own_randomized_network_STRING_TEST.csv";
	open(INFO, $file_in);

	my $file_out = "My_own_randomized_network_STRING_TEST.csv_UNIQUE_DEGREE.csv";
	open(OUT, ">$file_out");

	while(<INFO>)
	{
		chomp;
		my ($node1, $node2, $junk1, $junk2) = split(/ /,$_);
		if((exists $keep_hash{$node1})||(exists $keep_hash{$node2}))
		{
			print OUT "$node1 $node2\n";
		}
	}
	close(INFO);
	close(OUT);
}


sub make_keep_hash
{
        my $file_in = "String_PPI_hgnc_converted_score_gt_700_only_binding_CONVERTED_TO_CSV_UNIQUE_PPI_COUNTS_SORTED.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
                my ($junk, $count, $node) = split(/\s+/,$_);
               
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
		my ($junk, $count, $node) = split(/\s+/,$_);
		$degree_with_multiple_nodes{$count}++;
	}
	close(INFO);
}

