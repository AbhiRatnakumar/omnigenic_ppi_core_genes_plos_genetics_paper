#!/usr/bin/perl

my %hash = ();
my %keep_hash = ();
my %all_hash = ();
&get_empty_string_p_value_text;

sub get_empty_string_p_value_text
{
	my $file_in = "SNP_platform_for_each_publication.txt";
	open(INFO, $file_in);

	my $file_out = "SNP_platform_for_each_publication_largest_SNP_platform.txt";
	open(OUT, ">$file_out");
	while(<INFO>)
	{
		chomp;
		my ($publication_id, $snp_platform) = split(/\t/,$_);
		if($snp_platform =~ /\[([\>\~\s\w\d+]+)\]/)
                {
                 	$no_of_snps = $1;
                        my $new_no_of_snps = $no_of_snps;
			$new_no_of_snps =~ s/\D//g;
               		$hash{$publication_id}{$new_no_of_snps} = $snp_platform;
			$all_hash{$publication_id} = $snp_platform;
		}
	}
	foreach my $publication_id ( keys %hash ) 
	{
		my $count = 0;
     		my $line = $publication_id;
		my $no_of_snps;
		for my $no_of_snps ( sort {$b <=> $a} keys %{ $hash{$publication_id} } ) 
		{
			$line = $line."\t".$hash{$publication_id}{$no_of_snps};
			$count++;
		}
		if($count > 1)
		{
			my ( $publication_id, $snp_platform1, $junk) = split(/\t/,$line,3);
			$keep_hash{$publication_id} = $snp_platform1;
		}
	}		
	foreach my $publication_id (keys %keep_hash)
	{
		print OUT "$publication_id\t$keep_hash{$publication_id}\n";
	}
	foreach my $publication_id (keys %all_hash)
        {
		if(!exists $keep_hash{$publication_id})
		{
                	print OUT "$publication_id\t$all_hash{$publication_id}\n";
        	}
	}			
	close(OUT);
	close(INFO);
}
