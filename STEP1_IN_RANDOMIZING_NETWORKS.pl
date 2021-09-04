#!/usr/bin/perl
use List::Util 'shuffle';
use Array::Shuffle qw(shuffle_array);

my @data = ();
my %hash = ();
my %swapped_hash = ();
my %overall_hash = ();
my %degree_with_muliple_nodes= ();

my $file_out = "My_own_randomized_network_STRING_TEST.csv";
open(OUT, ">$file_out");

&make_hash;
&read_in_counts_hash;
&do_iterations;
&print_hash;

close(OUT);

sub do_iterations
{
	foreach (my $iterations =0; $iterations < 1000; $iterations++)
	{
		&loop_through_counts;
	}
}

sub loop_through_counts
{
	foreach my $count ( keys %overall_hash )
        {
		if($degree_with_muliple_nodes{$count} > 1)
		{
			@data = ();
                	for my $node ( keys %{ $overall_hash{$count} } )
			{
				 push(@data, $node);
			}
        		shuffle_array(@data);
                	if(($data[0])&&($data[1]))
			{
				&swap_hash($data[0], $data[1]);
			}
		}
	}
}


sub read_in_counts_hash
{
	my $file_in = "String_PPI_hgnc_converted_score_gt_700_only_binding_CONVERTED_TO_CSV_UNIQUE_PPI_COUNTS_SORTED.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($count, $node) = split(/\t/,$_);
		$overall_hash{$count}{$node} = $count;	
		$degree_with_muliple_nodes{$count}++;
	}
	close(INFO);
}


sub print_hash
{
	foreach my $node1 ( sort {$a <=> $b} keys %hash ) 
	{
     		for my $node2 ( sort {$a <=> $b} keys %{ $hash{$node1} } ) 
		{
			print OUT "$node1 $node2\n";
		}
 	}
}

sub swap_hash
{
	my $swap1 = shift;
	my $swap2 = shift;
	my %new_hash = ();
	foreach my $node1 ( keys %hash )
        {
                for my $node2 ( keys %{ $hash{$node1} } )
                {
			my $new_node1 = $node1;
			my $new_node2 = $node2;
                        if($node1 eq $swap1)
			{
                		$new_node1 = $swap2."_swap";
			}
			if($node1 eq $swap2)
                        {
                                $new_node1 = $swap1."_swap";
                        }
			if($node2 eq $swap1)
                        {
                        	$new_node2 = $swap2."_swap";
			}
			if($node2 eq $swap2)
                        {
                                $new_node2 = $swap1."_swap";
                        }
			if($new_node1 lt $new_node2)
			{
				$new_hash{$new_node1}{$new_node2} = $new_node1;
			}
			else
			{
				$new_hash{$new_node2}{$new_node1} = $new_node1;
			}
		}
        }
	%hash = ();
	foreach my $node1 ( keys %new_hash )
        {
                for my $node2 ( keys %{ $new_hash{$node1} } )
                {
                        my $new_node1 = $node1;
                        my $new_node2 = $node2;
                        if($node1 =~ /_swap/)
                        {
                                $new_node1 = $node1;
                                $new_node1 =~ s/_swap//g;
                        }
                        if($node2 =~ /_swap/)
                        {
                                $new_node2 = $node2;
				$new_node2 =~ s/_swap//g;
                        }
                        if($new_node1 lt $new_node2)
                        {
                                $hash{$new_node1}{$new_node2} = $new_node1;
                        }
                        else
                        {
                                $hash{$new_node2}{$new_node1} = $new_node1;
                        }
                }
        }

}

sub make_hash
{
	my $file_in = "String_PPI_hgnc_converted_score_gt_700_only_binding_CONVERTED_TO_CSV_UNIQUE.csv";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($node1, $node2) = split(/\s+/,$_,2);
		if($node1 lt $node2)
		{
			$hash{$node1}{$node2} = $node1;
		}
		elsif($node2 lt $node1)
		{
			$hash{$node2}{$node1} = $node1;
		}
	}
	close(INFO);	
}
