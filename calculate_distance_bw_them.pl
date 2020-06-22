#!/usr/bin/perl




&calculate_distance_between_them;

sub calculate_distance_between_them
{
	my $file_in = "Distance_bw_core_genes_and_the_gwas_hits_the_core_genes_were_detected_from.txt";
	open(INFO, $file_in);

	my $file_out = "SAME_CHROMOSOME_ANNOTATED_WITH_DIFFERENCE_Distance_bw_core_genes_and_the_gwas_hits_the_core_genes_were_detected_from.txt";
	open(OUT, ">$file_out");

	print OUT "difference\tid1\tid2\n";
	
	
	while(<INFO>)
	{
		chomp;
		my ($chr1, $start1, $end1, $id1, $chr2, $start2, $end2, $junk1, $id2) = split(/\t/,$_);
		my $diff = "";
		if($chr1 eq $chr2)
		{
			if($start2>$end1)
			{
				$diff = abs($start2 - $end1);
				print OUT "$diff\t$id1\t$id2\n"; 
			}
			elsif($start1 > $end2)
			{
				$diff = abs($start1 - $end2);
                                print OUT "$diff\t$id1\t$id2\n";
			}
			else
			{
				print OUT "0\t$id1\t$id2\n";
			}	
			
		}
	}
	close(INFO);
	close(OUT);
}
