#!/usr/bin/perl

my %ignore_hash = ();
my %remove_from_analysis = ();


my $file_remove = "LINES_TO_REMOVE.txt";
open(REMOVE, ">$file_remove");

&make_ignore_hash;
&count_proportions;
&filter_from_analysis;

close(REMOVE);

sub filter_from_analysis
{
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies_GENES_TAGGED_UNTAGGED.txt";
        open(INFO, $file_in);

	my $file_out = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies_GENES_TAGGED_UNTAGGED_filter_out_GWAS_HITS_that_are_within_1_Mb.txt";
	open(OUT, ">$file_out");


        while(<INFO>)
        {
                chomp;
                my ($study_accession, $disease_trait, $core_gene, $gwas_hits, $junk) = split(/\t/,$_);
		if(!exists ($remove_from_analysis{$core_gene}{$gwas_hits}))
		{
			print OUT "$_\n";
		}
	}
	close(INFO);
	close(OUT);
}



sub count_proportions
{
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies_GENES_TAGGED_UNTAGGED.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $core_gene, $gwas_hits, $junk) = split(/\t/,$_);
		my @cols = split(/,/,$gwas_hits);
		my $length = $#cols + 1;
		my $count = 0;
		for(my $i =0; $i<@cols; $i++)
		{
			if(exists $ignore_hash{$core_gene}{$cols[$i]})
			{
				$count++;
			}
		}
		if($length)
		{
			my $prop = $count/$length;
			my $left_over = $length - $count;
			if($prop)
			{
				if($left_over < 2)
				{
					print REMOVE "REMOVED\t$left_over\t$prop\t$count\t$length\t$core_gene\t$gwas_hits\t$_\n";	
					$remove_from_analysis{$core_gene}{$gwas_hits} = $gwas_hits;
				}
				else
				{
					print REMOVE "EVERYTHING_ELSE\t$left_over\t$prop\t$count\t$length\t$core_gene\t$gwas_hits\t$_\n";
				}
			}
		}
	}
	close(INFO);
}





sub make_ignore_hash
{
	my $file_in = "GWAS_HITS_WITHIN_1MB_OF_EACH_OTHER.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($distance, $core_gene, $gwas_hit1, $gwas_hit2) = split(/\t/,$_);
		$ignore_hash{$core_gene}{$gwas_hit1} = $gwas_hit1;
		$ignore_hash{$core_gene}{$gwas_hit2} = $gwas_hit2;
	}
	close(INFO);	
}
