#!/usr/bin/perl
#
#
#

my %hash = ();


my $file_out = $ARGV[2];
open(OUT, ">$file_out");

&print_everythinhg_else;
&print_unique_degrees;

close(OUT); 

sub print_unique_degrees
{
	my $file_in = $ARGV[1];
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($node1, $node2, $junk) = split(/ /,$_);
		if((!(exists $hash{$node1}{$node2}))&&(!(exists $hash{$node2}{$node1})))
		{
			if($node1 lt $node2)
                	{
                        	print OUT "$node1\t$node2\n";	
			}
			elsif($node2 lt $node1)
			{
				print OUT "$node2\t$node1\n"; 
			}	
		}
	}
	close(INFO);
}


sub print_everythinhg_else
{
	my $file_in = $ARGV[0];
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($node1, $node2, $junk) = split(/ /,$_);
		if($node1 lt $node2)
		{
			print OUT "$node1\t$node2\n";
			$hash{$node1}{$node2} = $node1;
		}
		elsif($node2 lt $node1)
		{
			print OUT "$node2\t$node1\n";
			$hash{$node2}{$node1} = $node1;
		}
	}
	close(INFO);
}
