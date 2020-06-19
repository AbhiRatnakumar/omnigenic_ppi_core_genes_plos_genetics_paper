#!/usr/bin/perl

my %efo_hash = ();
my %done = ();
&make_the_relevant_output_files;

sub make_the_relevant_output_files
{
	my $file_in = "check8.txt";
	open(INFO, $file_in);

	my $file_out = "GENE_LIST_for_each_DISEASE_ID.txt";
	open(OUT, ">$file_out");
	print OUT "study_accession\tdisease_trait\tefo_term\tparent_term\tgene\tunique_id\n";

	my $file_out3 = "COUNT_of_DISEASE_STUDY_IDs_per_EFO_TERM.txt";
        open(OUT3, ">$file_out3");
	print OUT3 "no_of_studies\tefo_term\tlist_of_studies\n";

	my $file_out4 = "MULTIPLE_STUDY_EFO_TERMS.txt";
        open(OUT4, ">$file_out4");
	print OUT4 "no_of_studies\tefo_term\tlist_of_studies\n";	

	my $file_out5 = "SINGLE_STUDY_EFO_TERMS.txt";
        open(OUT5, ">$file_out5");
	print OUT5 "no_of_studies\tefo_term\tlist_of_studies\n";

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry, $efo_term, $parent_term) = split(/\t/,$_);
		if(!($unique_id =~ /unique_id/))
		{
			my $study_accession= $study_accession;
			my $store = "$study_accession\t$efo_term\t$parent_term\t$gene";
			if(!$done{$store})
			{
				print OUT "$study_accession\t$disease_trait\t$efo_term\t$parent_term\t$gene\t$unique_id\n";
			}
			$done{$store} = $store;
                        $efo_hash{$efo_term}{$study_accession} = $efo_term;
		}
	}
	close(INFO);
	close(OUT);
	
	foreach my $efo_term ( sort keys %efo_hash ) 
	{
		my $count_study_accessions = 0;
		my $list = "";
     		for my  $study_accession ( sort keys %{ $efo_hash{$efo_term} } ) 
		{
     			$count_study_accessions++;
			if(!$list)
			{
				$list = $study_accession;
			}
			else
			{
				$list = $list.",".$study_accession;
			}
		}
		print OUT3 "$count_study_accessions\t$efo_term\t$list\n";
		if($count_study_accessions > 1)
		{
			print OUT4 "$count_study_accessions\t$efo_term\t$list\n";
		}
		elsif($count_study_accessions == 1)
		{
			print OUT5 "$count_study_accessions\t$efo_term\t$list\n";
		}		
	}
	close(OUT3);
	close(OUT4);
	close(OUT5);
}
