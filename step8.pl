#!/usr/bin/perl

&make_it_R_friendly;

sub make_it_R_friendly
{
	my $file_in = "check7.txt";
	open(INFO, $file_in);

	my $file_out = "check8.txt";
	open(OUT, ">$file_out");

	print OUT "study_accession\tunique_id\tloci_id\tpublication_id\tdisease_trait\tp_value\todds_ratio\tbeta_coefficient\tgene\tsnp_platform\tancestry\tefo_term\tparent_term\n";
	while(<INFO>)
	{
		chomp;
		my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry, $efo_term, $parent_term) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			my $new_line = $_;
			$new_line =~ s/'//g;
                	$new_line =~ s/,//g;
                	$new_line =~ s/\(//g;
                	$new_line =~ s/\)//g;
                	$new_line =~ s/\///g;
                	$new_line =~ s/ /_/g;
			print OUT "$new_line\n";
		}	
	}
	close(INFO);
	close(OUT);
}

